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

    use Rack::Session::Cookie

    use OmniAuth::Builder do
      provider :facebook, '290594154312564','a26bcf9d7e254db82566f31c9d72c94e'
    end

    get '/' do
      if current_user
        # The following line just tests to see that it's working.
        #   If you've logged in your first user, '/' should load: "1 ... 1";
        #   You can then remove the following line, start using view templates, etc.
        current_user.id.to_s + " ... " + session[:user_id].to_s 
      else
        '<a href="/auth/facebook">sign in with Facebook</a>'
      end
    end

    get '/auth/:name/callback' do
      auth = request.env["omniauth.auth"]
      user = User.first_or_create({ :uid => auth["uid"]}, {
        :uid => auth["uid"],
        :nickname => auth["info"]["nickname"], 
        :name => auth["info"]["name"],
        :created_at => Time.now })
      session[:user_id] = user.id
      redirect '/'
    end

    get '/auth/failure' do
      content_type 'application/json'
      MultiJson.encode(request.env)
    end

  end
end
