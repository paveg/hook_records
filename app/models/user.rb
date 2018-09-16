# frozen_string_literal: true

class User < ApplicationRecord
  has_many :social_profiles, dependent: :destroy

  # devise modules.
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable,
         :confirmable, :omniauthable

  TEMPORARY_EMAIL_PREFIX = 'change@me'
  TEMPORARY_EMAIL_REGEXP = /\Achange@me/
  validates :email, presence: true, email: true

  def self.find_or_create_for_oauth!(auth)
    user = nil
    ApplicationRecord.transaction do
      # Auto insert secure password for skip validation.
      if (user = User.find_by(email: auth.info.email)).nil?
        user = User.new(email: auth.info.email) # only facebook
        user.password = SecureRandom.base64(15)
        user.save!
      end
      SocialProfile.find_or_create_by_auth!(auth, user)
    end
    user
  end

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
end
