Rails.application.routes.draw do
  root to: 'home#index'

  # for overrides devise controllers.
  devise_for :users, controllers: {
      omniauth_callbacks: 'omniauth_callbacks',
      registrations: 'registrations',
      confirmations: 'confirmations'
  }

  # for input email process after authenticate with omniauth.
  match '/users/:id/finish_sign_up' => 'users#finish_sign_up', via: [:get, :patch], as: :finish_sign_up
end
