# Spree PayPal checkout

[![Build Status](https://travis-ci.org/spree-contrib/better_spree_paypal_checkout.svg?branch=master)](https://travis-ci.org/spree-contrib/better_spree_paypal_checkout)

This is the official Paypal checkout extension for Spree. 

## Installation

1. Add this extension to your Gemfile with this line:
        
        gem 'spree_paypal_checkout', github: 'spree-contrib/better_spree_paypal_checkout'

2. Install the gem using Bundler:

        bundle install

3. Copy & run migrations

        bundle exec rails g spree_paypal_api_checkout:install

4. Restart your server

        If your server was running, restart it so that it can find the assets properly.

### Sandbox Setup

#### PayPal

Go to [PayPal's Developer Website](https://developer.paypal.com/), sign in with your PayPal account, click "Applications" then "Sandbox Accounts" and create a new "Business" account. Once the account is created, click on the triangle next to its email address, then "Profile". The "API Credentials" tab will provide your API credentials (probably). If this tab is blank, try refreshing the page.

You will also need a "Personal" account to test the transactions on your site. Create this in the same way, finding the account information under "Profile" as well. You may need to set a password in order to be able to log in to PayPal's sandbox for this user.

#### Spree Setup

In Spree, go to the admin backend, click "Configuration" and then "Payment Methods" and create a new payment method. Select "Spree::Gateway::PayPalcheckout" as the provider, and click "Create". Enter the email address, password and signature from the "API Credentials" tab for the **Business** account on PayPal.

### Production setup

#### PayPal

Sign in to PayPal, then click "Profile" and then (under "Account Information" on the left), click "API Access". On this page, select "Option 2" and click "View API Signature". The username, password and signature will be displayed on this screen.

If you are unable to find it, then follow [PayPal's own documentation](https://developer.paypal.com/webapps/developer/docs/classic/api/apiCredentials/).

#### Spree Setup

Same as sandbox setup, but change "Server" from "sandbox" to "live".

## Configuration
This Spree extension supports *some* of those. If your favourite is not here, then please submit an issue about it, or better still a patch to add it in.


**Must** be an absolute path to the image.

## Caveats
