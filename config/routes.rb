Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'games#dashboard', as: 'games_dashboard'

  get 'rotate_direction' => 'games#rotate_direction', as: 'games_rotate_direction'
  get 'move_direction' => 'games#move_direction', as: 'games_move_direction'
end
