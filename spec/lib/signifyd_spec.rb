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
    end
    
    context 'when calling with an invalid API key' do
    end
  end
end