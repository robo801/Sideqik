require 'securerandom'

class Link < ApplicationRecord
  belongs_to :user
  validates :url, presence: true
  validates :short_link, :url, uniqueness: true

  before_save :create_short_link

  private
   def create_short_link
    self.short_link = SecureRandom.urlsafe_base64(6)
   end
end
