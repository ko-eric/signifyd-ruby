module Signifyd
  module API
    module List
      module ClassMethods
        def all(filters={}, api_key=nil)
          Signifyd.request(:get, self.url, {}, api_key, filters)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end