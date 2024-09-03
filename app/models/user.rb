class User
  include Mongoid::Document
  include Mongoid::Timestamps
  field :Name, type: String
  field :Surname, type: String
  field :Username, type: String
  field :Email, type: String
  field :Password, type: String
  field :Phone, type: String
end
