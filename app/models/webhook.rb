class Webhook < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true
  validates :url, presence: true
  validates :zip_code, presence: true
end
