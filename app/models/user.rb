class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :Name, type: String
  field :Email, type: String

  has_many :pets
end
