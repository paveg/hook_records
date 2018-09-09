# frozen_string_literal: true

class User < ApplicationRecord
  has_many :social_profiles, dependent: :destroy

  # devise modules.
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable,
         :confirmable, :omniauthable

  TEMPORARY_EMAIL_PREFIX = 'change@me'
  TEMPORARY_EMAIL_REGEXP = /\Achange@me/
  validates :email, presence: true, email: true

  # @param [String / Symbol] provider
  def social_profile(provider)
    social_profiles.find { |sp| sp.provider == provider.to_s }
  end

  def email_verified?
    email && !email.match?(TEMPORARY_EMAIL_PREFIX)
  end

  # Check user email again.
  def reset_confirmation!
    update(confirmed_at: nil)
  end

  # Set current user in Thread.
  def self.current_user=(user)
    Thread.current[:current_user] = user
  end

  # Get current user from Thread.
  def self.current_user
    Thread.current[:current_user]
  end
end
