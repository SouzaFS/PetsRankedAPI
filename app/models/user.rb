class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :Name, type: String
  field :Email, type: String

  validates :Email, presence: true, uniqueness: true

  has_many :pets
end
