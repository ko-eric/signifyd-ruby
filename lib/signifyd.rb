# External Dependencies
require 'i18n'
require 'active_support'
require 'rest_client'
require 'uri'
require 'json'
require 'base64'
require 'openssl'

# Gem Version
require 'signifyd/version'

# API operations
require 'signifyd/util'
require 'signifyd/signifyd_object'
require 'signifyd/resource'
require 'signifyd/api/create'
require 'signifyd/api/update'
require 'signifyd/case'

# Internal Dependencies
require 'signifyd/errors/signifyd_error'
require 'signifyd/errors/authentication_error'
require 'signifyd/errors/invalid_request_error'
require 'signifyd/errors/not_implemented_error'

module Signifyd
  @@ssl_bundle_path = File.join(File.dirname(__FILE__), 'data/signifyd.crt')
  @@api_key = nil
  @@api_base = 'https://api.signifyd.com'
  @@api_version = '/v1'
  @@verify_ssl_certs = false
  
  def self.api_url(url='')
    @@api_base + url
  end

  def self.api_key=(api_key)
    @@api_key = api_key
  end

  def self.api_key
    @@api_key
  end
  
  def self.api_version=(api_version)
    @@api_version = api_version
  end

  def self.api_version
    @@api_version
  end

  def self.api_base=(api_base)
    @@api_base = api_base
  end

  def self.api_base
    @@api_base
  end

  def self.verify_ssl_certs=(verify)
    @@verify_ssl_certs = verify
  end

  def self.verify_ssl_certs
    @@verify_ssl_certs
  end
  
  def self.request(method, url, params, api_key=nil)
    api_key = api_key.nil? ? @@api_key : api_key
    raise AuthenticationError.new('No API key provided. Fix: Signifyd.api_key = \'Your API KEY\'') unless api_key 
    
    uname = (@@uname ||= RUBY_PLATFORM =~ /linux|darwin/i ? `uname -a 2>/dev/null`.strip : nil)
    lang_version = "#{RUBY_VERSION} p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})"
    ua = {
      :bindings_version => Signifyd::VERSION,
      :lang => 'ruby',
      :lang_version => lang_version,
      :platform => RUBY_PLATFORM,
      :publisher => 'stripe',
      :uname => uname
    }
        
    url = self.api_url(url) 
    payload = JSON.dump(params)   
    authkey = Base64.encode64(api_key)
    headers = {
      "Content-Length"  => payload.size,
      "Content-Type"    => "application/json", 
      "Authorization"   => "Basic #{authkey}",
      'User-Agent'      => "Signifyd Ruby #{@@api_version.gsub('/', '')}"
    }
    
    if @@verify_ssl_certs
      ssl_opts = {
        :verify_ssl => OpenSSL::SSL::VERIFY_PEER,
        :ssl_ca_file => @@ssl_bundle_path
      }
    else
      ssl_opts = {
        :verify_ssl=> OpenSSL::SSL::VERIFY_NONE
      }
    end

    # Determine how to send the data and encode it based on what method we are sending
    case method.to_s
    when 'get'  || :get

    when 'post' || :post

    when 'put'  || :put
      # we need to eject out the case_id from the params hash and append it to the url
      if params.has_key?(:case_id) || params.has_key?('case_id')
        case_id = params.delete(:case_id) 
        url << "/#{case_id}"
      end

    when 'delete' || :delete

    end
    
    opts = {
      :method => method,
      :url => url,
      :headers => headers,
      :open_timeout => 30,
      :payload => payload,
      :timeout => 80
    }.merge(ssl_opts)
    
    begin
      response = execute_request(opts)
    rescue SocketError => e
      self.handle_restclient_error(e)
    rescue NoMethodError => e
      if e.message =~ /\WRequestFailed\W/
        e = APIConnectionError.new('Unexpected HTTP response code')
        self.handle_restclient_error(e)
      else
        raise
      end
    rescue RestClient::ExceptionWithResponse => e
      if rcode = e.http_code and rbody = e.http_body
        self.handle_api_error(rcode, rbody)
      else
        self.handle_restclient_error(e)
      end
    rescue RestClient::Exception, Errno::ECONNREFUSED => e
      self.handle_restclient_error(e)
    end
    
    rbody = response.body
    rcode = response.code
    {code: rcode, body: rbody}
  end
  
  def self.execute_request(opts)
    RestClient::Request.execute(opts)
  end
  
  def self.handle_restclient_error(e)
    case e
    when RestClient::ServerBrokeConnection, RestClient::RequestTimeout
      message = "Could not connect to Signifyd (#{@@api_base}).  Please check your internet connection and try again."
    when RestClient::SSLCertificateNotVerified
      message = "Could not verify Signifyd's SSL certificate.  Please make sure that your network is not intercepting certificates.  (Try going to https://api.signifyd.com/v1 in your browser.)  If this problem persists, let us know at support@signifyd.com."
    when SocketError
      message = "Unexpected error communicating when trying to connect to Signifyd.  HINT: You may be seeing this message because your DNS is not working.  To check, try running 'host signifyd.com' from the command line."
    else
      message = "Unexpected error communicating with Signifyd.  If this problem persists, let us know at support@signifyd.com."
    end
    message += "\n\n(Network error: #{e.message})"
    raise APIConnectionError.new(message)
  end
  
  private
  
  def self.configured?
    !!@@api_key
  end
end





















