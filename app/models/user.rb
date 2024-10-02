class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :Uid, type: String
  field :Name, type: String
  field :Email, type: String

  validates :Uid, presence: true, uniqueness: true

  has_many :pet
end
