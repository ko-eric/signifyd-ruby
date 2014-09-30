require 'spec_helper'

describe Signifyd::Case do
  let(:hash) { SignifydRequests.valid_case }
  let(:json) { JSON.dump(hash) }
  let(:case_id) { (rand * 1000).ceil }
  let(:order_id) { 'unique_id'}
  let(:investigation) { "{\"investigationId\":#{case_id}}" }
  let(:retrieved_case) {"{\"orderId\":#{case_id}}" }

  context '.create' do
    context 'when creating a case with a valid API key' do
      context 'and passing the correct parameters' do
        before {
          Signifyd.api_key = SIGNIFYD_API_KEY

          stub_request(:post, "https://#{Signifyd.api_key}@api.signifyd.com/v2/cases").
            with(:body => json, :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>json.size, 'Content-Type'=>'application/json', 'User-Agent'=>'Signifyd Ruby v2'}).
            to_return(:status => 201, :body => investigation, :headers => {})
        }

        after {
          Signifyd.api_key = nil
        }

        subject {
          Signifyd::Case.create(hash)
        }

        it { should be_true }
        it { should_not be_nil }
        it { expect(subject[:code]).to eq(201) }
        it { expect(subject[:body][:investigationId]).to eq(JSON.parse(investigation)[:investigationId]) }
      end

      context 'and passing incorrect or nil parameters' do
        before {
          Signifyd.api_key = SIGNIFYD_API_KEY
        }

        after {
          Signifyd.api_key = nil
        }

        it { lambda { Signifyd::Case.create() }.should raise_error }
      end
    end

    context 'when creating a case with an invalid API key' do
      it { lambda { Signifyd::Case.create(hash) }.should raise_error }
    end
  end

  context '.update' do
    context 'when updating a case' do
      context 'and the proper case_id and parameters have been sent' do
        before {
          Signifyd.api_key = SIGNIFYD_API_KEY

          stub_request(:put, "https://#{Signifyd.api_key}@api.signifyd.com/v2/cases/#{case_id}").
            with(:body => json, :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>json.size, 'Content-Type'=>'application/json', 'User-Agent'=>'Signifyd Ruby v2'}).
            to_return(:status => 200, :body => investigation, :headers => {})
        }

        after {
          Signifyd.api_key = nil
        }

        subject {
          Signifyd::Case.update(case_id, hash)
        }

        it { should be_true }
        it { should_not be_nil }
        it { expect(subject[:code]).to eq(200) }
        it { expect(subject[:body][:investigationId]).to eq(JSON.parse(investigation)[:investigationId]) }
      end

      context 'and incorrect parameters have been passed' do
        before {
          Signifyd.api_key = SIGNIFYD_API_KEY
        }

        after {
          Signifyd.api_key = nil
        }

        it { lambda { Signifyd::Case.update(case_id, {}) }.should raise_error }
      end
    end
  end

  describe '#find' do
    before :each do
      Signifyd.api_key = SIGNIFYD_API_KEY
    end
    after :each do
      Signifyd.api_key = nil
    end
    context 'when case with orderId exists' do
      it 'should return case in hash format' do
        stub_request(:get, "https://#{Signifyd.api_key}@api.signifyd.com/v2/orders/#{order_id}/case").
          with(:body => {}, :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>2, 'Content-Type'=>'application/json', 'User-Agent'=>'Signifyd Ruby v2'}).
          to_return(:status => 200, :body => retrieved_case, :headers => {})

        subject = Signifyd::Case.find({order_id: order_id})
        expect(subject).to be_true
        expect(subject[:code]).to eq(200)
        expect(subject[:body][:orderId]).to eq(JSON.parse(retrieved_case)[:orderId])
      end
    end
    context 'when case with orderID does not exist' do
      it 'should raise exception' do
        exception = RestClient::ExceptionWithResponse.new('test')
        exception.should_receive(:http_code).and_return(400)
        exception.should_receive(:http_body).and_return('as')
        stub_request(:get, "https://#{Signifyd.api_key}@api.signifyd.com/v2/orders/#{order_id}/case").
          with(:body => {}, :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>2, 'Content-Type'=>'application/json', 'User-Agent'=>'Signifyd Ruby v2'}).
          to_raise(exception)

        expect {Signifyd::Case.find({order_id: order_id})}.to raise_error(Signifyd::InvalidRequestError)
      end
    end
  end

end
