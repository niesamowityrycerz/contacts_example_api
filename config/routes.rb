# frozen_string_literal: true

Rails.application.routes.draw do
  resources :contacts do
    collection do
      post :mass_create
    end
  end
end
