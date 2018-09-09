# frozen_string_literal: true

module OAuthService
  class FetchOAuthUser
    def self.call(auth)
      profile = SocialProfile.find_for_oauth(auth)
      user = current_or_profile_user(profile)
      unless user
        user = User.find_by(email: email) if verified_email_from_oauth(oauth)
        user ||= find_or_create_new_user(auth)
      end
      associate_user_with_profile!(user, profile)
      user
    end

    class << self
      private

      def current_or_profile_user(profile)
        User.current_user.presence || profile.user
      end

      def find_or_create_new_user(auth)
        email = verified_email_from_oauth(auth)
        user = User.find_by(email: email) if email
        return if user

        temporary_email = "#{User::TEMPORARY_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
        user = User.new(
          username: auth.extra.raw_info.name,
          email: email || temporary_email,
          password: Devise.friendly_token[0, 20]
        )
        user.skip_confirmation!
        user.save(validate: false)
        user
      end

      def verified_email_from_oauth(auth)
        auth.info.email if auth.info.email && (auth.info.verified || auth.info.verified_email)
      end
    end
  end
end
