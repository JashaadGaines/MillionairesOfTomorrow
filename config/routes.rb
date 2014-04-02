MoT::Application.routes.draw do
  get "home/index"

  get "home/index/images/youngAdultClassroom"

  root 'home#index'


end
