module Signifyd
  module API
    module Update
      module ClassMethods
        def update(case_id, params={}, api_key=nil)
          raise InvalidRequestError.new('You have passed invalid parameters to Case.create') if params == {} || case_id.nil?
          Signifyd.request(:put, self.url, params.merge(case_id: case_id), api_key)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end