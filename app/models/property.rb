class Property < ActiveRecord::Base
  validates :nickname, :presence => true
  validates :description, :presence => true
  validates :address, :presence => true

  belongs_to :user

  has_many :transactions, dependent: :destroy
end
