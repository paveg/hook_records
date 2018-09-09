# frozen_string_literal: true

class UsersController
  before_action :authenticate_user!, except: finish_sign_up

  def finish_sign_up
    @user = User.find(params[:id])
    return unless request.patch? && @user.update(user_params)
    @user.send_confirmation_instructions unless @user.confirmed?
    flash[:info] = 'We send you a confirmation email. Please, find a confirmation link.'
    redirect_to root_url
  end

  private

  def user_params
    accessible = %i[username email]
    accessible << %i[password password_confirmation] if params[:user][:password].present?
    params.require(:user).permit(accesible)
  end
end
