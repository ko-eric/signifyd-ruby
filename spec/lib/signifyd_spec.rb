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
      before {
        stub_request(:post, "https://100000000001001:@api.signifyd.com/v1/cases?%7B%7D").
          with(:body => "{}", :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => "", :headers => {})
        
        Signifyd.api_key = SIGNIFYD_API_KEY
      }

      after {
        Signifyd.api_key = nil
      }
      
      subject {
        Signifyd.request(:post, '/cases', "{}")
      }
      
      it { should_not be_nil }
      it { should be_true }
    end
    
    context 'when calling with an invalid API key' do
      before {
        Signifyd.api_key = nil
        stub_request(:post, "https://100000000001001:@api.signifyd.com/v1/cases?%7B%7D").
          with(:body => "{}", :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
          to_return(:status => 200, :body => "", :headers => {})        
      }
      
      it "throws an Authentication error" do  
        lambda { Signifyd.request(:post, '/cases', "{}") }.should raise_error
      end
    end
  end
end