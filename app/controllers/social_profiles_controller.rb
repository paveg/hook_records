# frozen_string_literal: true

class SocialProfilesController
  before_action :authenticate_user!
  before_action :correct_user!

  def destroy
    @provile.destroy
    flash[:success] = "Disconnected from #{@profile.provider.capitalize}"
    redirect_to root_url
  end

  private

  def correct_user!
    @profile = SocialProfile.find(params[:id])
    redirect_to root_url return unless @profile.user_id == current_user.id
  end
end
