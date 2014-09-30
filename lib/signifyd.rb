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
require 'signifyd/api/list'
require 'signifyd/api/update'
require 'signifyd/case'

# Internal Dependencies
require 'signifyd/errors/signifyd_error'
require 'signifyd/errors/api_error'
require 'signifyd/errors/api_connection_error'
require 'signifyd/errors/authentication_error'
require 'signifyd/errors/invalid_request_error'
require 'signifyd/errors/not_implemented_error'

module Signifyd
  # ssl_bundle_path
  #
  # Path to hold Signifyd.com's certificate
  # @return: String[path to certificate file]
  @@ssl_bundle_path = File.join(File.dirname(__FILE__), 'data/ca-certificates.crt')

  # api_key
  #
  # Default point for where the application will hold the API_KEY
  # for the current instance. If not set, must be passed in all calls
  # as last parameter.
  # @return String[unique identifier]
  @@api_key = nil

  # api_base
  #
  # Root url where the Signifyd API endpoints will live. This can be
  # changed by setting Signifyd.test_mode = true and will default to
  # staging env.
  # @return: String[url to Signifyd's API]
  @@api_base = 'https://api.signifyd.com'

  # api_version
  #
  # Version right now will be the url structure, might change later.
  # For now this is ok.
  # @return: String[url path of our current api version]
  @@api_version = '/v2'

  # verify_ssl_certs
  #
  # When this is set to false, any request made will not be a verfied
  # and supported request by Signifyd. This should be set to true and
  # the library will use the Signifyd keys..not for now :/
  # @return: Boolean
  @@verify_ssl_certs = true

  # test_mode
  #
  # When set to true, will default to Signifyd's staging environment.
  # This as well should always be set to false.
  # @return: Boolean
  @@test_mode = false

  # local_mode
  #
  # When set to true, will default to a local environment of localhost:9000.
  # This as well should always be set to false.
  # @return: Boolean
  @@local_mode = false

  # ssl_bundle_path
  #
  # Returns the path to the certificate store location
  def self.ssl_bundle_path
    @@ssl_bundle_path
  end

  # api_url
  #
  # This method is used to set the full url that the request will be made
  # to. Ideally, pass in the version of the API and then the method that
  # will be requested.
    # An example retrun would be: 'https://signifyd.com/v2/cases
  # @return: String[url for request to be made]
  def self.api_url(url='')
    @@api_base + url
  end

  # api_key=
  #
  # Setter method to set the API key. Set into class variable and used
  # globally on all calls made.
  # @return: String[api key]
  def self.api_key=(api_key)
    @@api_key = api_key
  end

  # api_key
  #
  # Getter method for the API key that has been set by the application.
  # @return: String[api key]
  def self.api_key
    @@api_key
  end

  # api_version=
  #
  # Setter method to set the API version. Set into class variable and used
  # globally on all calls made.
  # @return: String[api url version]
  def self.api_version=(api_version)
    @@api_version = api_version
  end

  # api_version
  #
  # Getter method for the API version that has been set by the application.
  # @return: String[api url version]
  def self.api_version
    @@api_version
  end

  # api_base=
  #
  # Setter method to set the API url base. Set into class variable and used
  # globally on all calls made.
  # @return: String[api base]
  def self.api_base=(api_base)
    @@api_base = api_base
  end

  # api_base
  #
  # Getter method for the API base that has been set by the application.
  # @return: String[api base]
  def self.api_base
    @@api_base
  end

  # verify_ssl_certs=
  #
  # Setter method to set the API verify_ssl_certs. Set into class variable and
  # used globally on all calls made.
  # @return: Boolean
  def self.verify_ssl_certs=(verify)
    @@verify_ssl_certs = verify
  end

  # verify_ssl_certs
  #
  # Getter method for the API verify_ssl_certs that has been set by the application.
  # @return: Boolean
  def self.verify_ssl_certs
    @@verify_ssl_certs
  end

  # test_mode=
  #
  # Setter method to set the API test_mode. Set into class variable and used
  # globally on all calls made.
  # @return: Boolean
  def self.test_mode=(test_mode)
    Signifyd.api_base = 'https://staging.signifyd.com' if test_mode && !self.local_mode
    @@test_mode = test_mode
  end

  # test_mode
  #
  # Getter method for the API test_mode that has been set by the application.
  # @return: Boolean
  def self.test_mode
    @@test_mode
  end

  # local_mode=
  #
  # Setter method to set the API local_mode. Set into class variable and used
  # globally on all calls made.
  # @return: Boolean
  def self.local_mode=(local_mode)
    Signifyd.api_base = 'http://localhost:9000' if local_mode && !self.test_mode
    @@local_mode = local_mode
  end

  # local_mode
  #
  # Getter method for the API test_mode that has been set by the application.
  # @return: Boolean
  def self.local_mode
    @@local_mode
  end

  # request
  #
  # Global method that will use RestClient to make all requests. Everything else
  # is set between Signifyd.{setter} methods. This method is called from other
  # methods so direct calls won't be necessary.
  #
  # @param[Req]: String[method] - :get, :post, :put, :delete
  # @param[Req]: String[url] - '/cases'
  # @param[Req]: Hash[params] - {transaction...}
  # @param[Opt]: String[api_key] - 'YOUR-API-KEY'
  # @param[Opt]: Hash[options] - optional parameters
  # @return: Hash - containing response code, body, and other data
  def self.request(method, url, params={}, api_key=nil, options={})
    api_key = api_key.nil? ? @@api_key : api_key
    raise AuthenticationError.new('No API key provided. Fix: Signifyd.api_key = \'Your API KEY\'') unless api_key

    uname = (@@uname ||= RUBY_PLATFORM =~ /linux|darwin/i ? `uname -a 2>/dev/null`.strip : nil)
    lang_version = "#{RUBY_VERSION} p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE})"
    ua = {
      :bindings_version => Signifyd::VERSION,
      :lang => 'ruby',
      :lang_version => lang_version,
      :platform => RUBY_PLATFORM,
      :publisher => 'signifyd',
      :uname => uname
    }

    if @@verify_ssl_certs
      ssl_opts = {
        :verify_ssl  => OpenSSL::SSL::VERIFY_PEER,
        :ssl_ca_file => @@ssl_bundle_path
      }
    else
      ssl_opts = {
        :verify_ssl => OpenSSL::SSL::VERIFY_NONE
      }
    end

    # Determine how to send the data and encode it based on what method we are sending. Some
    # are necessary, some are not.
    case method.to_s
    when 'get'
      if options.has_key?(:order_id)
        url = url.gsub('cases', "orders/#{options[:order_id]}/case")
      end
    when 'post'

    when 'put'
      # we need to eject out the case_id from the params hash and append it to the url
      if params.has_key?(:case_id) || params.has_key?('case_id')
        case_id = params.delete(:case_id)
        params.reject! { |k| k == :case_id || k == 'case_id' }
        url << "/#{case_id}"
      end
    when 'delete'

    end

    # Create the full url here
    url = self.api_url(url)

    # Parse into valid json
    payload = JSON.dump(params)

    # Convert the key
    authkey = api_key == {} || api_key == nil ? '' : Base64.encode64(api_key)

    # Headers must contain these keys
    headers = {
      "Content-Length"  => payload.size,
      "Content-Type"    => "application/json",
      "Authorization"   => "Basic #{authkey}",
      'User-Agent'      => "Signifyd Ruby #{@@api_version.gsub('/', '')}"
    }

    # All necessary options must be set
    opts = {
      :method => method,
      :url => url,
      :headers => headers,
      :open_timeout => 30,
      :payload => payload,
      :timeout => 80
    }.merge(ssl_opts)

    # Make the request
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
    return {code: rcode, body: JSON.parse(rbody)}
  end

  # execute_request
  #
  # Handles the request, pass in opts hash, RestClient makes the call.
  # @param: Hash[opts] - Configured options from Signifyd.request method.
  # @return: RestClient::Request - the result of the request.
  def self.execute_request(opts)
    RestClient::Request.execute(opts)
  end

  # handle_restclient_error
  #
  # @param: RestClient[error] - could be many different types of errors.
  # @return: String[error message]
  def self.handle_restclient_error(e)
    case e
    when RestClient::ServerBrokeConnection, RestClient::RequestTimeout
      message = "Could not connect to Signifyd (#{@@api_base}).  Please check your internet connection and try again."
    when RestClient::SSLCertificateNotVerified
      message = "Could not verify Signifyd's SSL certificate.  Please make sure that your network is not intercepting certificates.  (Try going to https://api.signifyd.com/v2 in your browser.)  If this problem persists, let us know at support@signifyd.com."
    when SocketError
      message = "Unexpected error communicating when trying to connect to Signifyd.  HINT: You may be seeing this message because your DNS is not working.  To check, try running 'host signifyd.com' from the command line."
    else
      message = "Unexpected error communicating with Signifyd.  If this problem persists, let us know at support@signifyd.com."
    end
    message += "\n\n(Network error: #{e.message})"
    raise APIConnectionError.new(message)
  end

  # handle_api_error
  #
  # @param: String
  # @param: String
  def self.handle_api_error(rcode, rbody)
    error = {}
    case rcode
    when 400, 404
      error[:message] = "Invalid request"
      error[:param]  = ""
      raise invalid_request_error error, rcode, rbody
    when 401
      error[:message] = "Authentication error"
      error[:param]  = ""
      raise authentication_error error, rcode, rbody
    else
      error[:message] = "API error"
      error[:param]  = ""
      raise general_api_error rcode, rbody
    end
  end

  def self.invalid_request_error(error, rcode, rbody)
    raise InvalidRequestError.new(error[:message], error[:param], rcode, rbody)
  end

  def self.authentication_error(error, rcode, rbody)
    raise AuthenticationError.new(error[:message], error[:param], rcode, rbody)
  end

  def self.general_api_error(rcode, rbody)
    raise APIError.new("Invalid response object from API: #{rbody.inspect} (HTTP response code was #{rcode})", rcode, rbody)
  end

  private
    # configured?
    #
    # Check to see if the API key has been set
    # @return: Boolean
    def self.configured?
      !!@@api_key
    end
end