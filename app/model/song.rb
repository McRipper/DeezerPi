class Song
  include DataMapper::Resource
  property :id,         Serial
  property :user_id,    Integer
  property :name,       String
  property :nickname,   String
  property :image,      String
  property :created_at, DateTime
end

