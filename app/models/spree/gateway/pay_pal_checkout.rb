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
      response = post_response_without_token(api_url('v1/oauth2/token'))
      return response['access_token']
    end

    def generate_client_token
      post_response(api_url('v1/identity/generate-token'))
    end

    def create_order order, body
      post_response(api_url('v2/checkout/orders'), body)
    end

    def capture_payment order_id
      post_response(api_url("v2/checkout/orders/#{order_id}/capture"))
    end

    def refund_payment id, body
      post_response(api_url("v2/payments/captures/#{id}/refund"), body)
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
      refund_entry = refund_payment(payment.source.transaction_id, refund_transaction)
      refund_transaction_response = parse_response(refund_entry)

      if success_response?(refund_transaction_response)
        payment.source.update({
          :refunded_at => Time.now,
          :refund_transaction_id => refund_transaction_response['id'],
          :state => "refunded",
          :refund_type => refund_type
        })

        refund_payment = payment.class.create!(
          :order => payment.order,
          :source => payment,
          :payment_method => payment.payment_method,
          :amount => amount.to_f.abs * -1,
          :response_code => refund_transaction_response['id'],
          :state => 'completed'
        )
        refund_payment.log_entries.create!(details: refund_entry.to_yaml)
      end
      refund_transaction_response
    end

    def post_response uri, body={}
      request = Net::HTTP::Post.new(uri)
      request['Authorization'] = "Bearer #{generate_access_token}"
      request.body = body.to_json if body.present?

      return hit_api(request: request, body: body, uri: uri)
    end

    def post_response_without_token uri, body={}
      request = Net::HTTP::Post.new(uri)
      request.basic_auth("#{preferred_api_key}", "#{preferred_secret_key}")
      request.body = 'grant_type=client_credentials'

      return parse_response(hit_api(request: request, body: body, uri: uri))
    end

    def hit_api request:, body:, uri:
      request.content_type = 'application/json'
      req_options = { use_ssl: uri.scheme == 'https' }

      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        response = http.request(request)
      end
      response
    end

    def parse_response response
      JSON.parse(response.read_body) rescue response
    end

    def api_url url
      URI.parse("https://#{preferred_server}/#{url}")
    end

    def set_payment_records order, number, payment_method
      raw_response = response = nil
      success = false
      begin
        payment_entry = capture_payment(number)
        response = parse_response(payment_entry)
        success = success_response?(response)

        payment = order.payments.create!({
          source: Spree::PaypalApiCheckout.create({
            token: response['id'],
            payer_id: response['payer']['payer_id']
          }),
          amount: order.total,
          payment_method: payment_method
        })
      rescue Exception => e
        raw_response = e.response.body
        response = response_error(raw_response)
      rescue JSON::ParserError
        response = json_error(raw_response)
      end

      payment.log_entries.create!(details: payment_entry.to_yaml)
      response
    end

    def response_error(raw_response)
      begin
        parse(raw_response)
      rescue JSON::ParserError
        json_error(raw_response)
      end
    end

    def json_error(raw_response)
      msg = 'Invalid response. Please contact team if you continue to receive this message.'
      msg += "  (The raw response returned by the API was #{raw_response.inspect})"
      {
        "error" => {
          "message" => msg
        }
      }
    end

    def success_response? response
      response.key?('status') && response.key?('id') && (response['status'] == 'COMPLETED')
    end
  end
end

#   payment.state = 'completed'
#   current_order.state = 'complete'
