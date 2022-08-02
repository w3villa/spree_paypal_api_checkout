module Spree
  class PaypalCheckoutController < StoreController
    skip_before_action :verify_authenticity_token

    def express
      order = current_order || raise(ActiveRecord::RecordNotFound)
      items = order.line_items.map(&method(:line_item))

      additional_adjustments = order.all_adjustments.additional
      tax_adjustments = additional_adjustments.tax
      shipping_adjustments = additional_adjustments.shipping
      promotion_adjustments = additional_adjustments.promotion

      additional_adjustments.eligible.each do |adjustment|
        # Because PayPal doesn't accept $0 items at all. See #10
        # https://cms.paypal.com/uk/cgi-bin/?cmd=_render-content&content_ID=developer/e_howto_api_ECCustomizing
        # "It can be a positive or negative value but not zero."
        next if adjustment.amount.zero?
        next if tax_adjustments.include?(adjustment) || shipping_adjustments.include?(adjustment) || promotion_adjustments.include?(adjustment)

        items << {
          name: adjustment.label,
          quantity: 1,
          unit_amount: {
            currency_code: order.currency,
            value: adjustment.amount
          }
        }
      end

      details = express_checkout_request_details(order: order, items: items, tax_adjustments: tax_adjustments, promotion_adjustments: promotion_adjustments)
      pp_response = provider.parse_response(provider.create_order(order, details))

      render json: pp_response
    end

    def confirm
      order = current_order || raise(ActiveRecord::RecordNotFound)

      response = provider.set_payment_records(order, params[:number], payment_method)

      render json: response
    end

    def proceed
      order = current_order || raise(ActiveRecord::RecordNotFound)
      order.payments.last.source.update(transaction_id: params[:transaction_id])
      order.payments.last.update(response_code: params[:transaction_id])
      order.next
      path = checkout_state_path(order.state)
      if order.complete?
        flash.notice = Spree.t(:order_processed_successfully)
        flash[:order_completed] = true
        session[:order_id] = nil
        path = completion_route(order)
      end
      render json: { redirect_to: path }
    end

    def cancel
      flash[:notice] = Spree.t('flash.cancel', scope: 'paypal')
      order = current_order || raise(ActiveRecord::RecordNotFound)
      redirect_to checkout_state_path(order.state, paypal_cancel_token: params[:token])
    end

    private

    def line_item(item)
      {
          name: item.product.name,
          sku: item.variant.sku,
          quantity: item.quantity,
          description: item.product.meta_description,
          unit_amount: {
            currency_code: item.order.currency,
            value: item.price
          },
          item_category: "Physical"
      }
    end

    def express_checkout_request_details order:, items:, tax_adjustments:, promotion_adjustments:
      {
        intent: 'CAPTURE',
        purchase_units: [
          {
            invoice_id: current_order.number,
            amount: {
              currency_code: current_order.currency,
              value: order.total,
              breakdown: {
                item_total: {
                  currency_code: current_order.currency,
                  value: items.sum{|r| (r[:unit_amount][:value] * r[:quantity]) }
                },
                shipping: {
                  currency_code: current_order.currency,
                  value: current_order.shipments.sum(:cost)
                },
                tax_total: {
                  currency_code: current_order.currency,
                  value: tax_adjustments.sum(:amount)
                },
                discount: {
                  currency_code: current_order.currency,
                  value: promotion_adjustments.sum(:amount).abs
                }
              }
            },
            items: items,
            shipping: address_options
          },
        ]
      }
    end

    def address_options
      address = current_order.ship_address
      {
        name: { full_name: address.try(:full_name) },
        address: {
          address_line_1: address.address1,
          address_line_2: address.address2,
          # phone: address.phone,
          admin_area_1: address.state_text,
          admin_area_2: address.city,
          country_code: address.country.iso,
          postal_code: address.zipcode
        },
        type: 'SHIPPING'
      }
    end

    def payment_method
      Spree::PaymentMethod.find(params[:payment_method_id])
    end

    def provider
      payment_method
    end

    def completion_route(order)
      order_path(order)
    end
  end
end
