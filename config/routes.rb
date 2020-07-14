# frozen_string_literal: true

Rails.application.routes.draw do
  get '/_ping', to: proc { |_env| [200, { 'Content-Type' => 'text/plain' }, []] }

  resources :invitations, only: [:create]

  require 'sidekiq/web'
  if Rails.env.production?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      username == ENV['SIDEKIQ_USERNAME'] && password == ENV['SIDEKIQ_PASSWORD']
    end
  end
  mount Sidekiq::Web, at: '/sidekiq'
end
