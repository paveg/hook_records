# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def callback_for_providers
    if request['omniauth.auth'].blank?
      flash[:danger] = 'Authentication data was not provided'
      redirect_to(root_url) && return
    end
    provider = __callee__.to_s
    user = OAuthService::FetchOAuthUser.call(request['omniauth.auth'])

    sign_in_or_reset_confirmation(user, provider)
  end

  alias facebook callback_for_providers
  alias twitter callback_for_providers

  private

  def sign_in_or_reset_confirmation(user, provider)
    if user.persisted? && user.email_verified?
      sign_in_and_redirect(user, event: :authentication)
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      user.reset_confirmation!
      flash[:warning] = 'needs your email address before proceeding.'
      redirect_to finish_sign_up_path(user)
    end
  end
end
