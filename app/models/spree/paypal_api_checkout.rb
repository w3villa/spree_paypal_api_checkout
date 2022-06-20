class Spree::PaypalApiCheckout < ApplicationRecord
  def success?; transaction_id.present?; end
end
