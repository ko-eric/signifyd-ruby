require 'spec_helper'

describe Signifyd::Case do
  context '.create' do
    let(:hash) { SignifydRequests.valid_case }
    let(:json) { JSON.dump(hash) }
    let(:investigation) { "{\"investigationId\":14065}" }
    
    context 'when creating a case with a valid API key' do
      context 'and passing the correct parameters' do
        before {
          Signifyd.api_key = SIGNIFYD_API_KEY
          
          stub_request(:post, "https://#{Signifyd.api_key}@api.signifyd.com/v1/cases").
            with(:body => json, :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>json.size, 'Content-Type'=>'application/json', 'User-Agent'=>'Signifyd Ruby v1'}).
            to_return(:status => 201, :body => investigation, :headers => {})
        }

        after {
          Signifyd.api_key = nil
        }
        
        subject {
          Signifyd::Case.create(hash)
        }
        
        it { should_not be_nil }
        it { should be_true }
        it {
          expect(subject[:code]).to eq(201)
        }
        it {
          expect(JSON.parse(subject[:body])[:investigationId]).to eq(JSON.parse(investigation)[:investigationId])
        }
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
    
    context 'when creating a case with an invalid API key' do
    end
  end
end
