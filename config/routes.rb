Spree::Core::Engine.add_routes do
  post '/paypal_checkout', :to => "paypal_checkout#express", :as => :paypal_checkout
  post '/paypal_checkout/confirm', :to => "paypal_checkout#confirm", :as => :confirm_paypal_checkout
  get '/paypal_checkout/cancel', :to => "paypal_checkout#cancel", :as => :cancel_paypal_checkout
  get '/paypal_checkout/notify', :to => "paypal_checkout#notify", :as => :notify_paypal_checkout
  get '/paypal_checkout/proceed', :to => "paypal_checkout#proceed", :as => :proceed_paypal_checkout
  namespace :admin do
    # Using :only here so it doesn't redraw those routes
    resources :orders, :only => [] do
      resources :payments, :only => [] do
        member do
          get 'paypal_checkout_refund'
          post 'paypal_checkout_refund'
        end
      end
    end
  end
end