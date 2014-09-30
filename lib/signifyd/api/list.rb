module Signifyd
  module API
    module List
      module ClassMethods
        def all(filters={}, api_key=nil)
          Signifyd.request(:get, self.url, {}, api_key, filters)
        end
        # To retrieve case by orderId pass in {order_id: value}
        # into options
        def find(options={}, filters={},api_key=nil)
          Signifyd.request(:get, self.url, filters, api_key, options#f)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end