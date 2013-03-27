require 'spec_helper'

describe Signifyd::Case do
  context '.create' do
    context 'when creating a case with a valid API key' do
      context 'and passing the correct parameters' do
        let(:transaction) { SignifydRequests.valid_case }
        
        before {
          Signifyd.api_key = SIGNIFYD_API_KEY
        }

        after {
          Signifyd.api_key = nil
        }
        
        subject {
          Signifyd::Case.create({person: 'male', company: 'microsoft'}, '0')
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