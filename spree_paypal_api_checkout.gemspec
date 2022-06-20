Gem::Specification.new do |s|
  s.name = "spree_paypal_api_checkout".freeze
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Spree Commerce".freeze]
  s.date = "2022-02-22"
  s.description = "Adds PayPal API Checkout as a Payment Method to Spree Commerce".freeze
  s.email = "gems@spreecommerce.com".freeze
  s.files = [".gitignore".freeze, "Gemfile".freeze, "README.md".freeze, "Rakefile".freeze, "app/assets/javascripts/spree/backend/spree_paypal_checkout.js".freeze, "app/assets/javascripts/spree/frontend/spree_paypal_checkout.js".freeze, "app/assets/stylesheets/spree/backend/spree_paypal_checkout.css".freeze, "app/assets/stylesheets/spree/frontend/spree_paypal_checkout.css".freeze, "app/controllers/spree/admin/payments_controller_decorator.rb".freeze, "app/controllers/spree/admin/paypal_checkout_payments_controller.rb".freeze, "app/controllers/spree/paypal_checkout_controller.rb".freeze, "app/models/spree/gateway/pay_pal_checkout.rb".freeze, "app/models/spree/paypal_api_checkout.rb".freeze, "app/views/spree/admin/payments/_paypal_complete.html.erb".freeze, "app/views/spree/admin/payments/paypal_refund.html.erb".freeze, "app/views/spree/admin/payments/source_forms/_paypal.html.erb".freeze, "app/views/spree/admin/payments/source_views/_paypal.html.erb".freeze, "app/views/spree/checkout/payment/_paypal_checkout.html.erb".freeze, "config/locales/de.yml".freeze, "config/locales/en.yml".freeze, "config/locales/es.yml".freeze, "config/locales/it.yml".freeze, "config/locales/pl.yml".freeze, "config/locales/pt.yml".freeze, "config/routes.rb".freeze, "db/migrate/20220620042734_create_spree_paypal_api_checkouts.rb".freeze, "lib/generators/spree_paypal_api_checkout/install/install_generator.rb".freeze, "lib/spree_paypal_api_checkout.rb".freeze, "lib/spree_paypal_api_checkout/engine.rb".freeze, "lib/spree_paypal_api_checkout/version.rb".freeze, "script/rails".freeze, "spree_paypal_api_checkout.gemspec".freeze]
  s.homepage = "http://www.spreecommerce.com".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 2.2.2".freeze)
  s.requirements = ["none".freeze]
  s.rubygems_version = "3.2.3".freeze
  s.summary = "Adds PayPal API Checkout as a Payment Method to Spree Commerce".freeze
  # s.test_files = ["spec/controllers/paypal_controller_spec.rb".freeze, "spec/features/paypal_spec.rb".freeze, "spec/models/pay_pal_express_spec.rb".freeze, "spec/spec_helper.rb".freeze, "spec/support/capybara.rb".freeze, "spec/support/capybara_ext.rb".freeze]

  s.installed_by_version = "3.2.3" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<spree_core>.freeze, [">= 3.1.0", "< 5.0"])
    s.add_runtime_dependency(%q<spree_auth_devise>.freeze, [">= 3.1.0", "< 5.0"])
    s.add_runtime_dependency(%q<paypal-sdk-merchant>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<spree_extension>.freeze, [">= 0"])
    s.add_development_dependency(%q<capybara>.freeze, [">= 0"])
    s.add_development_dependency(%q<capybara-screenshot>.freeze, [">= 0"])
    s.add_development_dependency(%q<selenium-webdriver>.freeze, [">= 0"])
    s.add_development_dependency(%q<webdrivers>.freeze, ["~> 4.1"])
    s.add_development_dependency(%q<coffee-rails>.freeze, [">= 0"])
    s.add_development_dependency(%q<database_cleaner>.freeze, [">= 0"])
    s.add_development_dependency(%q<factory_bot>.freeze, ["~> 4.7"])
    s.add_development_dependency(%q<ffaker>.freeze, [">= 0"])
    s.add_development_dependency(%q<rspec-rails>.freeze, ["~> 4.0.0.beta2"])
    s.add_development_dependency(%q<rspec-activemodel-mocks>.freeze, [">= 0"])
    s.add_development_dependency(%q<sass-rails>.freeze, [">= 0"])
    s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_development_dependency(%q<pry>.freeze, [">= 0"])
    s.add_development_dependency(%q<require_all>.freeze, [">= 0"])
    s.add_development_dependency(%q<pg>.freeze, [">= 0"])
    s.add_development_dependency(%q<puma>.freeze, [">= 0"])
    s.add_development_dependency(%q<mysql2>.freeze, [">= 0"])
    s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_development_dependency(%q<appraisal>.freeze, [">= 0"])
  else
    s.add_dependency(%q<spree_core>.freeze, [">= 3.1.0", "< 5.0"])
    s.add_dependency(%q<spree_auth_devise>.freeze, [">= 3.1.0", "< 5.0"])
    s.add_dependency(%q<paypal-sdk-merchant>.freeze, [">= 0"])
    s.add_dependency(%q<spree_extension>.freeze, [">= 0"])
    s.add_dependency(%q<capybara>.freeze, [">= 0"])
    s.add_dependency(%q<capybara-screenshot>.freeze, [">= 0"])
    s.add_dependency(%q<selenium-webdriver>.freeze, [">= 0"])
    s.add_dependency(%q<webdrivers>.freeze, ["~> 4.1"])
    s.add_dependency(%q<coffee-rails>.freeze, [">= 0"])
    s.add_dependency(%q<database_cleaner>.freeze, [">= 0"])
    s.add_dependency(%q<factory_bot>.freeze, ["~> 4.7"])
    s.add_dependency(%q<ffaker>.freeze, [">= 0"])
    s.add_dependency(%q<rspec-rails>.freeze, ["~> 4.0.0.beta2"])
    s.add_dependency(%q<rspec-activemodel-mocks>.freeze, [">= 0"])
    s.add_dependency(%q<sass-rails>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<require_all>.freeze, [">= 0"])
    s.add_dependency(%q<pg>.freeze, [">= 0"])
    s.add_dependency(%q<puma>.freeze, [">= 0"])
    s.add_dependency(%q<mysql2>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_dependency(%q<appraisal>.freeze, [">= 0"])
  end
end
