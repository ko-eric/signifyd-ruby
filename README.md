# Signifyd Ruby 

[![Coverage Status](https://coveralls.io/repos/signifyd/signifyd-ruby/badge.png?branch=master)](https://coveralls.io/r/signifyd/signifyd-ruby)
[![Build Status](https://travis-ci.org/signifyd/signifyd-ruby.png?branch=master)](https://travis-ci.org/signifyd/signifyd-ruby)

## Introduction
This is the official ruby library for the Signifyd API. Install the gem, get your API key from the Signifyd portal at [Signifyd](https://signifyd.com) and start posting your transactions for fraud detection. Every transaction you post to the API will creaet a new investigation. 

Before using this library, be sure to look at our third party authentications you can add to your account. Signifyd allows you to connect your Stripe or Shopify store/account and it will automatically create investigations for your transactions. 

Please read the [documentation](https://www.signifyd.com/docs/api) for creating a case. Even though you are using the ruby library we have created, you must still adhere to the data type and encoding of the data to match what we expect a correct post will be.

## Installation 
The installation can be used for a stand alone ruby application, Sinatra or a Rails application.

	$ gem install signifyd
	
For Rails applications, include in Gemfile.

```ruby
gem 'signifyd'
```

Now that you have installed the gem. Go ahead and configured your API-key. In a Rails application, you can create a file `config/initializers/signifyd.com` and include this line. 

```ruby
require 'signifyd'
Signifyd.api_key = 'YOUR-API-KEY'
```
	
Otherwise include and set this in an intialization block of your Sinatra or Ruby application. This will persist throughout the lifetime of your application. 

## Methods
Currently Signifyd supports the following methods for investigations against your transactions. The Cases endpoint is where you will start. Encode your transaction to match the JSON we require for a successful creation and make your request.

### Cases
To create a case, follow the instructions below. Please read the [documentation](https://www.signifyd.com/docs/api) under your account. It is imperative that you follow the guides correctly and encode all pieces of data with the correct format and data types otherwise this will effect the score we rank your transaction at. 

To create a case, encode your json to match our documentation](https://www.signifyd.com/docs/api) and then pass it into this method:

```ruby
request = Signifyd::Case.create(json, {})
```
	
Upon successful case post, this will return a response that contains data on whether or not this was successful. It will look something like this:


