class Pet
  include Mongoid::Document
  include Mongoid::Timestamps
  field :Breed, type: String
  field :Energy, type: Integer
  field :Allegiance, type: Integer
  field :Intelligence, type: Integer
  field :Territorial, type: Integer
  field :Loyalty, type: Integer
  field :Bonded, type: Integer
  field :Noisy, type: Integer
  field :ChildFriendly, type: Integer
  field :AnimalFriendly, type: Integer
  field :RaiseDifficulty, type: Integer
  field :AdultSize, type: Integer

  belongs_to :user
end
