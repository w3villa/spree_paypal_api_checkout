module Spree
  class Gateway::PayPalCheckout < Gateway
    preference :api_key, :string
    preference :secret_key, :string
    preference :server, :string, default: 'api-m.sandbox.paypal.com'

    def supports?(source)
      true
    end

    def provider_class;end

    def provider;end

    def auto_capture?
      true
    end

    def method_type
      'paypal_checkout'
    end

    def generate_access_token
      uri = URI.parse("https://#{preferred_server}/v1/oauth2/token")
      request = Net::HTTP::Post.new(uri)
      request.basic_auth("#{preferred_api_key}", "#{preferred_secret_key}")
      request.content_type = 'application/json'
      request.body = 'grant_type=client_credentials'

      req_options = { use_ssl: uri.scheme == 'https' }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        response = http.request(request)
      end
      return JSON.parse(response.read_body)['access_token']
    end

    def generate_client_token
      uri = URI.parse("https://#{preferred_server}/v1/identity/generate-token")
      return post_response(uri)
    end

    def create_order order, body
      uri = URI.parse("https://#{preferred_server}/v2/checkout/orders")
      return post_response(uri, body)
    end

    def capture_payment order_id
      uri = URI.parse("https://#{preferred_server}/v2/checkout/orders/#{order_id}/capture")
      return post_response(uri)
    end

    def refund_payment id, body
      uri = URI.parse("https://#{preferred_server}/v2/payments/captures/#{id}/refund")
      return post_response(uri, body)
    end

    def purchase(amount, express_checkout, gateway_options={})
      if express_checkout.success?
        Class.new do
          def success?; true; end
          def authorization; nil; end
        end.new
      else
        'No transaction'
      end
    end

    def refund(payment, amount)
      refund_type = payment.amount == amount.to_f ? "Full" : "Partial"
      refund_transaction = {
        transaction_id: payment.source.transaction_id,
        amount: {
          value: payment.order.item_total,
          currency_code: payment.currency
        },
        invoice_id: payment.order.number,
        refund_type: refund_type,
        refund_source: 'any'
      }
      refund_transaction_response = refund_payment(payment.source.transaction_id, refund_transaction)
      if refund_transaction_response['status']=='COMPLETED'
        payment.source.update({
          :refunded_at => Time.now,
          :refund_transaction_id => refund_transaction_response['id'],
          :state => "refunded",
          :refund_type => refund_type
        })

        payment.class.create!(
          :order => payment.order,
          :source => payment,
          :payment_method => payment.payment_method,
          :amount => amount.to_f.abs * -1,
          :response_code => refund_transaction_response['id'],
          :state => 'completed'
        )
      end
      refund_transaction_response
    end

    def post_response uri, body={}
      request = Net::HTTP::Post.new(uri)
      request['Authorization'] = "Bearer #{generate_access_token}"
      request.content_type = 'application/json'
      req_options = { use_ssl: uri.scheme == 'https' }

      request.body = body.to_json if body.present?
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        response = http.request(request)
      end
      return JSON.parse(response.read_body)
    end
  end
end

#   payment.state = 'completed'
#   current_order.state = 'complete'
