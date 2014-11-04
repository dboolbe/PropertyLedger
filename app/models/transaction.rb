class Transaction < ActiveRecord::Base
  validates :account, :presence => true
  validates :income, :expense, :miscellaneous,
            :presence => true,
            :numericality => true,
            :format => { :with => /\A(-)?\d{1,8}(\.\d{0,2})?\z/ }

  belongs_to :property
end
