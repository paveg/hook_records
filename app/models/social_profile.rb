# frozen_string_literal: true

require_relative '../helpers/o_auth/o_auth_service'
class SocialProfile < ApplicationRecord
  belongs_to :user
  store :others

  validates :user_id, :uid, :provider, presence: true
  validates :uid, uniqueness: { scope: :provider }

  def self.find_or_create_by_auth!(auth, user)
    find_or_create_by!(uid: auth.uid, provider: auth.provider, user_id: user.id)
  end

  def save_oauth_data!(auth)
    return unless valid_oauth?(auth)

    provider = auth['provider']
    policy = policy(provider, auth)

    update(
      uid: policy.uid,
      name: policy.name,
      nickname: policy.nickname,
      email: policy.email,
      url: policy.url,
      image_url: policy.image_url,
      description: policy.description,
      credentials: policy.credentials,
      raw_info: policy.raw_info
    )
  end

  private

  def policy(provider, auth)
    class_name = provider.to_s.classify
    "OAuthPolicy::#{class_name}".constantize.new(auth)
  end

  def valid_oauth?(auth)
    provider.to_s == auth['provider'].to_s && uid == auth['uid']
  end
end
