class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: :true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: :true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_insensitive: false }
  has_secure_password
  NO_SPACES_REGEX = Regexp.new '\A([^(\s)]{6,})\z'
  validates :password, length: { minimum: 6 }, format: { with: NO_SPACES_REGEX }

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
