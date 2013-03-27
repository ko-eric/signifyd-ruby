require 'spec_helper'

describe Signifyd do
  context '.api_key' do
    context 'when setting an invalid API key' do
      context 'and when checking with the .configured? method' do
        subject {
          Signifyd.configured?
        }

        it { should_not be_nil }
        it { should be_false }
      end
    
      context 'and when checking the actual value' do
        subject {
          Signifyd.api_key
        }

        it { should be_nil }
        it { should be_false }
      end
    end
    
    context 'when setting a valid API key' do
      before {
        Signifyd.api_key = SIGNIFYD_API_KEY
      }

      after {
        Signifyd.api_key = nil
      }

      subject {
        Signifyd.configured?
      }

      it { should_not be_nil }
      it { should be_true }
    end
  end
  
  context '.request' do
    context 'when calling with a vald API key' do
      let(:hash) { SignifydRequests.valid_case }
      let(:json) { JSON.dump(hash) }

      before {
        Signifyd.api_key = SIGNIFYD_API_KEY
        
        stub_request(:post, "https://#{Signifyd.api_key}@api.signifyd.com/v1/cases").
          with(:body => json, :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>json.size, 'Content-Type'=>'application/json', 'User-Agent'=>'Signifyd Ruby v1'}).
          to_return(:status => 201, :body => "{\"investigationId\":14065}", :headers => {})
      }
    
      after {
        Signifyd.api_key = nil
      }
      
      subject {
        Signifyd.request(:post, '/v1/cases', hash)
      }
      
      it { should_not be_nil }
      it { should be_true }
    end
  end
end