module Signifyd
  class Case < Resource
    include Signifyd::API::Create
    include Signifyd::API::List
    include Signifyd::API::Update
  end
end