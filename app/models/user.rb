class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
    :rememberable, :trackable, :validatable

  before_create :generate_authentication_token!

  validates :auth_token, uniqueness: true

  def generate_authentication_token!
    # TODID: Figure out how this construction works
    # Does not #exist? until after save or whatever,
    # so the `while` cond only compares to preexisting stuff
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end
end
