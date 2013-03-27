module Signifyd
  class Case < Resource
    include Signifyd::API::Create
    include Signifyd::API::Update
  end
end