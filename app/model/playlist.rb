class Playlist
  include DataMapper::Resource
  property :id,          Serial
  property :user_id,     Integer

  property :title,       String
  property :artist_name, String
  property :album_title, String
  property :album_cover, String

  property :duration,    Integer # Seconds

  property :score,       Integer, default: 0
  property :playing,     Boolean, default: false

  property :link,        String
  property :created_at,  DateTime

  def self.set_playing(id)
    Playlist.all(playing: true).collect{ |p| p.playing = false; p.save } # Sett all plaing as false
    p = Playlist.first(id: id)
    if !p.nil?
      p.playing = true
      p.save
    end
  end
end


