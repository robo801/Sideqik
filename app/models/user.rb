require 'jwt'

class User < ApplicationRecord
  HMAC_SECRET = 'mysecretkey'
  has_secure_password

  validates :password, presence: true, on: create
  validates :username, presence: true, uniqueness: true
  validates :token, allow_nil: true, uniqueness: true

  def generate_token
    payload = {username: self.username, created_at: self.created_at}
    self.update(token: (JWT.encode payload, HMAC_SECRET, 'HS256'))
    self.token
  end
end
