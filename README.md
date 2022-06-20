# Spree PayPal checkout

## Installation

1. Add this extension to your Gemfile with this line:
        
        gem 'spree_paypal_checkout', '~> 0.0.4'

2. Install the gem using Bundler:

        bundle install

3. Copy & run migrations

        bundle exec rake railties:install:migrations

4. Restart your server

        If your server was running, restart it so that it can find the assets properly.

### Sandbox Setup

#### PayPal

Go to [PayPal's Developer Website](https://developer.paypal.com/), sign in with your PayPal account, click "Applications" then "Sandbox Accounts" and create a new "Business" account. There you will get your CLIENT ID and CLIENT SECRET KEY.

You will also need a "Personal" account to test the transactions on your site. Create this in the same way, finding the account information under "Profile" as well. You may need to set a password in order to be able to log in to PayPal's sandbox for this user.

#### Spree Setup

In Spree, go to the admin backend, click "Configuration" and then "Payment Methods" and create a new payment method. Select "Spree::Gateway::PayPalcheckout" as the provider, and click "Create". Enter the email address, password and signature from the "API Credentials" tab for the **Business** account on PayPal.

### Production setup

#### PayPal

Go to [PayPal's Developer Website](https://developer.paypal.com/), sign in with your PayPal account, click "Applications" then "Sandbox Accounts" and create a new "Business" account. There you will get your CLIENT ID and CLIENT SECRET KEY.

### Spree Setup

Same as sandbox setup, but change "Server" from "sandbox" to "live".

## Configuration
This Spree extension supports *some* of those. If your favourite is not here, then please submit an issue about it, or better still a patch to add it in.

**Must** be an absolute path to the image.
