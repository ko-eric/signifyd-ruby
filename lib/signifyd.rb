# External Dependencies
require 'net/http'

# Gem Version
require 'signifyd/version'

# Internal Dependencies
require 'signifyd/errors/signifyd_error'
require 'signifyd/errors/authentication_error'
require 'signifyd/errors/invalid_request_error'

module Signifyd
  @@ssl_bundle_path = File.join(File.dirname(__FILE__), 'data/ca-certificates.crt')
  @@api_key = nil
  @@api_base = 'https://api.signifyd.com'
  @@api_version = '/v1'
  @@verify_ssl_certs = true
  
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
  
  def self.request(method, url, api_key, params)
    api_key ||= @@api_key
    raise AuthenticationError.new('No API key provided. Fix: Signifyd.api_key = \'Your API KEY\'') unless api_key
    
    current_user_token = "#{api_key}:"
    encoded_user_token = Base64.encode64(current_user_token)
    
    headers  = {
      'Content-Type'  => "application/json",
      'Authorization' => "Basic #{encoded_user_token}"
    }
    
    # Post to the API with credentials
    http          = Net::HTTP.new(Signifyd.api_base, 443)
    http.use_ssl  = true
    
    store = OpenSSL::X509::Store.new
    store.set_default_paths
    store.add_cert(OpenSSL::X509::Certificate.new(File.read('data/signifyd.crt')))
    
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    http.cert_store  = store
    response = nil
   
    # Make the request
    case method.to_s
    when "get"
    when "post"
      response = http.post("#{Signifyd.api_version}#{url}?#{params}", "#{raw_json.to_json}", headers)
      return response
    when "put"
    when "delete"
    end
  end
  
  def self.configured?
    !!@@api_key
  end
end