module App
  class Web < Sinatra::Base

    configure do
      set :root, "#{File.dirname(__FILE__)}/../"
      set :public_folder, "#{File.dirname(__FILE__)}/../../public"
      set :views, Proc.new { File.join(root, "views") }

      set :protection, :except => :frame_options
    end

    helpers do
      def current_user
        @current_user ||= User.get(session[:user_id]) if session[:user_id]
      end
    end

    use Rack::Session::Cookie, secret: "7898cb07b5dc3ed138840767d743b4aa"

    use OmniAuth::Builder do
      provider :facebook, '203597956466980','c85ffc4e033df8623470014c7a3be1d0', scope: "user_likes"
    end

    get '/' do
      if current_user
        erb :index
      else
        erb :login
      end
    end

    get '/auth/:name/callback' do

      auth = request.env["omniauth.auth"]
      user = User.first_or_create({ :uid => auth["uid"]}, {
        :uid => auth["uid"],
        :nickname => auth["info"]["nickname"],
        :image => auth["info"]["image"],
        :name => auth["info"]["name"],
        :token => auth["credentials"]["token"],
        :created_at => Time.now })
      session[:user_id] = user.id

      puts "Facebook:"
      puts facebook(user)
      puts "\n"
      puts "Deezer:"
      puts deezer(user)

      redirect '/'
    end


    # Facebook
    #
    def facebook(user)

      return if user.nil?

      data = RestClient.get("https://graph.facebook.com/#{user.uid}/music?access_token=#{user.token}")

      results = MultiJson.load(data.body)

      results["data"].each do |d|
        Artist.first_or_create({ name: d["name"], user_id: user.id})
      end

      return results["data"].size

    end

    # Deezer
    #
    def deezer(user)

      return if user.nil?

      artists = Artist.all(user_id: user.id)
      artists.each do |a|
        data = RestClient.get("http://api.deezer.com/2.0/search?q=#{CGI.escape(a.name)}")
        results = MultiJson.load(data.body)
        if (r = results["data"]).any?
          r.each do |s|
            Playlist.first_or_create({ user_id: user.id, link: s["preview"] }, {
              title: s["title"],
              artist_name: s["artist"]["name"],
              album_title: s["album"]["title"],
              album_cover: s["artist"]["cover"],
              duration: s["duration"]
            })
          end
        end
      end
      return "OK!"
    end

    get '/success' do
      erb :success
    end

    get '/auth/failure' do
      content_type 'application/json'
      MultiJson.encode(request.env)
    end

    get '/logout' do
      session[:user_id] = nil
      redirect "/"
    end

    get '/playing' do

      content_type 'application/json', :charset => 'utf-8'

      p = Playlist.first(playing: true)
      if p
        {
          title: p.title,
          artist_name: p.artist_name,
          album_title: p.album_title,
          album_cover: p.album_cover,
          duration: p.duration
        }.to_json
      else
        {}.to_json
      end
    end

  end
end
