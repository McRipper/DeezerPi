class Playlist
  include DataMapper::Resource
  property :id,         Serial
  property :user_id,    Integer
  property :link,       String
  property :created_at, DateTime
end


