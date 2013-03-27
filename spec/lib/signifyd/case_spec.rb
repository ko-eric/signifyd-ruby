require 'spec_helper'

describe Signifyd::Case do
  context '.create' do
    context 'when creating a case with a valid API key' do
      context 'and passing the correct parameters' do
        let(:hash) { SignifydRequests.valid_case }
        let(:json) { JSON.dump(hash) }
        
        before {
          Signifyd.api_key = SIGNIFYD_API_KEY
          
          stub_request(:post, "https://#{Signifyd.api_key}@api.signifyd.com/v1/cases").
            with(:body => json, :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>json.size, 'Content-Type'=>'application/json', 'User-Agent'=>'Signifyd Ruby v1'}).
            to_return(:status => 200, :body => "", :headers => {})
        }

        after {
          Signifyd.api_key = nil
        }
        
        subject {
          Signifyd::Case.create(hash)
        }
        
        it { should_not be_nil }
      end

      context 'and passing incorrect or nil parameters' do
        before {
          Signifyd.api_key = SIGNIFYD_API_KEY
        }

        after {
          Signifyd.api_key = nil
        }

        it {
          lambda { Signifyd::Case.create() }.should raise_error
        }
      end
    end
    
    context 'when creating a case with a over written API key as an option' do
    end

    context 'when creating a case with an invalid API key' do
    end
  end
end