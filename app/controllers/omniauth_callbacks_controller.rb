# frozen_string_literal: true

require_relative '../helpers/o_auth/o_auth_service'
require_relative '../helpers/o_auth/o_auth_policy'
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def callback_for_providers
    auth = request.env['omniauth.auth']
    if request.env['omniauth.auth'].blank?
      flash[:danger] = 'Authentication data was not provided'
      redirect_to(root_url) && return
    end
    provider = __callee__.to_s
    @user = User.find_or_create_for_oauth!(auth)

    sign_in_or_reset_confirmation(provider)
  end
  alias facebook callback_for_providers
  # TODO: alias twitter callback_for_providers

  private

  def sign_in_or_reset_confirmation(provider)
    if @user.persisted? && @user.email_verified?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.capitalize)
      sign_in_and_redirect(@user, event: :authentication)
    else
      @user.reset_confirmation!
      flash[:warning] = 'needs your email address before proceeding.'
      redirect_to finish_sign_up_path(@user)
    end
  end
end
