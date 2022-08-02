module Spree
  module LogEntryDecorator
    def parsed_details
      @details ||= YAML.safe_load(details, [ActiveMerchant::Billing::Response, Net::HTTPCreated, URI::HTTPS, URI::RFC3986_Parser, Symbol, Regexp, Object])
    end

    def success_parsed_details?
      if parsed_details.is_a?(Net::HTTPCreated)
        parsed_paypal_entry == 'COMPLETED'
      elsif parsed_details.is_a?(ActiveMerchant::Billing::Response)
        parsed_details.success?
      else
        true
      end
    end

    def parsed_paypal_entry
      JSON.parse(parsed_details.read_body)['status'] rescue parsed_details.to_json
    end
  end
end
::Spree::LogEntry.prepend(Spree::LogEntryDecorator)
