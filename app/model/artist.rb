class Artist
  include DataMapper::Resource
  property :id,         Serial
  property :user_id,    Integer
  property :name,       String
  property :created_at, DateTime
end


