require 'spec_helper'

describe Signifyd do
  let(:hash) { SignifydRequests.valid_case }
  let(:json) { JSON.dump(hash) }

  context '.verify_ssl_certs' do
    context 'when calling for the verify_ssl_certs' do
      before {
        Signifyd.api_key = SIGNIFYD_API_KEY
      }

      after {
        Signifyd.api_key = nil
      }

      subject {
        Signifyd.verify_ssl_certs = true
      }

      it { should be_true }
      it { should_not be_nil }
      it { expect(subject).to eq(true) }
    end
  end

  context '.verify_ssl_certs=' do
    context 'when setting the verify_ssl_certs' do
      before {
        Signifyd.api_key = SIGNIFYD_API_KEY
      }

      after {
        Signifyd.api_key = nil
        Signifyd.verify_ssl_certs = true
      }

      subject {
        Signifyd.verify_ssl_certs = false
      }

      it { should be_false }
      it { should_not be_nil }
      it { expect(subject).to eq(false) }
    end
  end

  context '.api_base=' do
    context 'when setting the api_base' do
      before {
        Signifyd.api_key = SIGNIFYD_API_KEY
      }

      after {
        Signifyd.api_key = nil
        Signifyd.api_base = 'https://api.signifyd.com'
      }

      subject {
        Signifyd.api_base = 'https://signifyd.com'
      }

      it { should be_true }
      it { should_not be_nil }
      it { expect(subject).to eq('https://signifyd.com') }
    end
  end

  context '.api_base' do
    context 'when calling for the api_base' do
      before {
        Signifyd.api_key = SIGNIFYD_API_KEY
      }

      after {
        Signifyd.api_key = nil
      }

      subject {
        Signifyd.api_base
      }

      it { should be_true }
      it { should_not be_nil }
      it { expect(subject).to eq('https://api.signifyd.com') }
    end
  end

  context '.ssl_bundle_path' do
    context 'when calling for the ssl_bundle_path' do
      before {
        Signifyd.api_key = SIGNIFYD_API_KEY
      }

      after {
        Signifyd.api_key = nil
      }

      subject {
        Signifyd.ssl_bundle_path
      }

      it { should be_true }
      it { should_not be_nil }
      it { expect(subject).to include('data/ca-certificates.crt') }
    end
  end

  context '.verify_ssl_certs' do
    context 'when calling for the verify_ssl_certs' do
      before {
        Signifyd.api_key = SIGNIFYD_API_KEY
      }

      after {
        Signifyd.api_key = nil
      }

      subject {
        Signifyd.verify_ssl_certs
      }

      it { should be_true }
      it { should_not be_nil }
      it { expect(subject).to be_true }
    end
  end

  context '.test_mode' do
    context 'when calling for the test_mode' do
      before {
        Signifyd.api_key = SIGNIFYD_API_KEY
      }

      after {
        Signifyd.api_key = nil
      }

      subject {
        Signifyd.test_mode
      }

      it { should be_false }
      it { should_not be_nil }
      it { expect(subject).to be_false }
    end
  end

  context '.test_mode=' do
    context 'when setting the test_mode' do
      before {
        Signifyd.api_key = SIGNIFYD_API_KEY
      }

      after {
        Signifyd.api_key = nil
        Signifyd.api_version = '/v2'
      }

      subject {
        Signifyd.test_mode = false
      }

      it { should be_false }
      it { should_not be_nil }
      it { expect(subject).to be_false }
    end
  end


  context '.local_mode' do
    context 'when calling for the local_mode' do
      before {
        Signifyd.api_key = SIGNIFYD_API_KEY
      }

      after {
        Signifyd.api_key = nil
      }

      subject {
        Signifyd.local_mode
      }

      it { should be_false }
      it { should_not be_nil }
      it { expect(subject).to be_false }
    end
  end

  context '.local_mode=' do
    context 'when setting the local_mode' do
      before {
        Signifyd.api_key = SIGNIFYD_API_KEY
      }

      after {
        Signifyd.api_key = nil
        Signifyd.api_version = '/v2'
      }

      subject {
        Signifyd.local_mode = false
      }

      it { should be_false }
      it { should_not be_nil }
      it { expect(subject).to be_false }
    end
  end

  context '.api_version=' do
    context 'when setting the api_version' do
      before {
        Signifyd.api_key = SIGNIFYD_API_KEY
      }

      after {
        Signifyd.api_key = nil
        Signifyd.api_version = '/v2'
      }

      subject {
        Signifyd.api_version = '/v2'
      }

      it { should be_true }
      it { should_not be_nil }
      it {
        expect(subject).to eq('/v2')
      }
    end
  end

  context '.api_version' do
    context 'when calling for the api_version' do
      before {
        Signifyd.api_key = SIGNIFYD_API_KEY
      }

      after {
        Signifyd.api_key = nil
      }

      subject {
        Signifyd.api_version
      }

      it { should be_true }
      it { should_not be_nil }
      it {
        expect(subject).to eq('/v2')
      }
    end
  end

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
    context 'with a valid API key set' do
      before {
        Signifyd.api_key = SIGNIFYD_API_KEY

        stub_request(:post, "https://#{Signifyd.api_key}@api.signifyd.com/v2/cases").
          with(:body => json, :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>json.size, 'Content-Type'=>'application/json', 'User-Agent'=>'Signifyd Ruby v2'}).
          to_return(:status => 201, :body => "{\"investigationId\":14065}", :headers => {})
      }

      after {
        Signifyd.api_key = nil
      }

      subject {
        Signifyd.request(:post, '/v2/cases', hash)
      }

      it { should_not be_nil }
      it { should be_true }
    end

    context 'with a non valid or nil API key' do
      before {
        Signifyd.api_key = nil
      }

      subject {
        Signifyd.request(:post, '/v2/cases', hash)
      }

      it { lambda { subject }.should raise_error(Signifyd::AuthenticationError) }
    end

    context 'when VERIFY_NONE is set to false' do
      before {
        Signifyd.api_key = SIGNIFYD_API_KEY
        Signifyd.verify_ssl_certs = false

        stub_request(:post, "https://#{Signifyd.api_key}@api.signifyd.com/v2/cases").
          with(:body => json, :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>json.size, 'Content-Type'=>'application/json', 'User-Agent'=>'Signifyd Ruby v2'}).
          to_return(:status => 201, :body => "{\"investigationId\":14065}", :headers => {})
      }

      after {
        Signifyd.api_key = nil
        Signifyd.verify_ssl_certs = true
      }

      subject {
        Signifyd.request(:post, '/v2/cases', hash)
      }

      it { should_not be_nil }
      it { should be_true }
    end

    context 'when there is an authentication on invalid request error' do
      context 'and returns a 400' do
        before {
          Signifyd.api_key = nil

          stub_request(:post, "https://#{Signifyd.api_key}@api.signifyd.com/v2/cases").
            with(:body => json, :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>json.size, 'Content-Type'=>'application/json', 'User-Agent'=>'Signifyd Ruby v2'}).
            to_return(:status => 400, :body => "{\"investigationId\":14065}", :headers => {})
        }

        subject {
          Signifyd.request(:post, '/v2/cases', hash)
        }

        it { lambda { subject }.should raise_error(Signifyd::AuthenticationError) }
      end

      context 'and returns a 404' do
        before {
          Signifyd.api_key = SIGNIFYD_API_KEY

          stub_request(:post, "https://#{Signifyd.api_key}@api.signifyd.com/v2/cases").
            with(:body => json, :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Content-Length'=>json.size, 'Content-Type'=>'application/json', 'User-Agent'=>'Signifyd Ruby v2'}).
            to_return(:status => 404, :body => "{\"investigationId\":14065}", :headers => {})
        }

        subject {
          Signifyd.request(:post, '/v2/cases', hash)
        }

        it { lambda { subject }.should raise_error(Signifyd::InvalidRequestError) }
      end
    end
  end

  context '.handle_restclient_error' do
    before {
      Signifyd.api_key = nil
    }

    context 'when RestClient::ServerBrokeConnection OR RestClient::RequestTimeout' do
      subject {
        Signifyd.handle_restclient_error RestClient::ServerBrokeConnection.new
      }

      it { lambda { subject }.should raise_error(Signifyd::APIConnectionError) }
    end

    context 'when RestClient::SSLCertificateNotVerified' do
      subject {
        Signifyd.handle_restclient_error RestClient::SSLCertificateNotVerified.new('error')
      }

      it { lambda { subject }.should raise_error(Signifyd::APIConnectionError) }
    end

    context 'when SocketError' do
      subject {
        Signifyd.handle_restclient_error SocketError.new
      }

      it { lambda { subject }.should raise_error(Signifyd::APIConnectionError) }
    end

    context 'when StandardError' do
      subject {
        Signifyd.handle_restclient_error StandardError.new
      }

      it { lambda { subject }.should raise_error(Signifyd::APIConnectionError) }
    end
  end

  context '.handle_api_error' do
    before {
      Signifyd.api_key = nil
    }

    context 'when 400 or 404' do
      subject {
        Signifyd.handle_api_error(400, "{\"error\":true}")
      }

      it { lambda { subject }.should raise_error(Signifyd::InvalidRequestError) }
    end

    context 'when 401' do
      subject {
        Signifyd.handle_api_error(401, "{\"error\":true}")
      }

      it { lambda { subject }.should raise_error(Signifyd::AuthenticationError) }
    end

    context 'when 500' do
      subject {
        Signifyd.handle_api_error(500, "{\"error\":true}")
      }

      it { lambda { subject }.should raise_error(Signifyd::APIError) }
    end
  end

  context '.invalid_request_error' do
    before {
      @error = {}
      @error[:message] = "Invalid request error"
      @error[:param] = "Left out json body"
      @rcode = 400
      @rbody = "{\"error\":true}"
    }

    subject {
      Signifyd.invalid_request_error @error, @rcode, @rbody
    }

    it { lambda { subject }.should raise_error(Signifyd::InvalidRequestError) }
  end

  context '.authentication_error' do
    before {
      @error = {}
      @error[:message] = "Authentication Error"
      @error[:param] = "Left out api key"
      @rcode = 404
      @rbody = "{\"error\":true}"
    }

    subject {
      Signifyd.authentication_error @error, @rcode, @rbody
    }

    it { lambda { subject }.should raise_error(Signifyd::AuthenticationError) }
  end

  context '.general_api_error' do
    before {
      @error = {}
      @error[:message] = "Api Error"
      @error[:param] = "Left out api key"
      @rcode = 404
      @rbody = "{\"error\":true}"
    }

    subject {
      Signifyd.general_api_error @rcode, @rbody
    }

    it { lambda { subject }.should raise_error(Signifyd::APIError) }
  end
end