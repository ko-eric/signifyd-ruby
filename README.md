# Signifyd Ruby 

[![Build Status](https://travis-ci.org/signifyd/signifyd-ruby.png?branch=master)](https://travis-ci.org/signifyd/signifyd-ruby)
[![Code Climate](https://codeclimate.com/github/signifyd/signifyd-ruby.png)](https://codeclimate.com/github/signifyd/signifyd-ruby)
[![Coverage Status](https://coveralls.io/repos/signifyd/signifyd-ruby/badge.png?branch=master)](https://coveralls.io/r/signifyd/signifyd-ruby)

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
	
Otherwise include and set this in an initialization block of your Sinatra or Ruby application. This will persist throughout the lifetime of your application. If you do not set your API key globally like the example above. You can pass your key into any method and it will authenticate on each single request as follows:

```ruby
create = Signifyd::Case.create(transaction_hash, 'YOUR-API-KEY')
update = Signifyd::Case.update(case_id, attributes_hash, 'YOUR-API-KEY')
```

## Errors
You can catch your erros based on these sub classes. 

```ruby
begin
  	# Make your call
rescue Signifyd::InvalidRequestError => e
	# The request you made was invalid
rescue Signifyd::AuthenticationError => e
	# The api_key is most likely incorrect or not set
rescue => e
  	# Something else happened, completely unrelated to Signifyd
end
```

Upon a successful case/investigation creation or any endpoint called. Signifyd will return an [HTTP status code](http://httpstatus.es/) that makes sense for the resource called and data manipulated for the restfull endpoint.

## Methods
Currently Signifyd supports the following methods for investigations against your transactions. The Cases endpoint is where you will start. Encode your transaction to match the JSON we require for a successful creation and make your request.

### Cases
To create a case, follow the instructions below. Please read the [documentation](https://www.signifyd.com/docs/api) under your account. It is imperative that you follow the guides correctly and encode all pieces of data with the correct format and data types otherwise this will effect the score we rank your transaction at. 

To create a case, align all hash attributes to match our [documentation](https://www.signifyd.com/docs/api) and then call the create method. We will do our best to parse through your request before actually making it to our server. Please follow the [documentation](https://www.signifyd.com/docs/api) verbatim. 

```ruby
transaction = {
    "attackMethod" => "STOLEN_CC",
        "purchase" => {
        "browserIpAddress" => "50.141.59.109",
               "createdAt" => "2013-02-21T18:37:35-05:00",
                "currency" => "CAD",
              "totalPrice" => "495.00",
           "shippingPrice" => "20.00",
                "products" => [
                    {
                              "itemId" => 61389,
                            "itemName" => "Progressive disintermediate moderator",
                        "itemQuantity" => 6,
                           "itemPrice" => "38.57",
                          "itemWeight" => 4
                    }
        ]
    },
    "recipient" => {
                 "fullName" => "Greyson Yundt",
        "confirmationEmail" => "greyson.yundt@domain.com",
          "deliveryAddress" => {
            "streetAddress" => "9822 Terrance Valleys",
                     "unit" => "Apt 2323",
                     "city" => "Palo Alto",
             "provinceCode" => "CA",
               "postalCode" => "94306",
              "countryCode" => "US",
                 "latitude" => "37.4248",
                "longitude" => "-122.148"
        }
    },
    "card" => {
        "cardHolderName" => "Greyson Yundt",
                   "bin" => 407441,
        "billingAddress" => {
            "streetAddress" => "9822 Terrance Valleys",
                     "unit" => "Apt 2323",
                     "city" => "Palo Alto",
             "provinceCode" => "CA",
               "postalCode" => "94306",
              "countryCode" => "US",
                 "latitude" => "37.4248",
                "longitude" => "-122.148"
        }
    },
    "userAccount" => {
                        "email" => "annie.dach@schambergerdaniel.name",
                     "username" => "lydia_rowe",
                        "phone" => "268.513.3896",
                  "createdDate" => nil,
                "accountNumber" => nil,
                  "lastOrderId" => nil,
          "aggregateOrderCount" => nil,
        "aggregateOrderDollars" => nil,
               "lastUpdateDate" => nil
    },
    "seller" => {
                    "name" => "Amazon",
                  "domain" => "amazon.com",
         "shipFromAddress" => {
            "streetAddress" => "1850 Mercer Rd",
                     "unit" => nil,
                     "city" => "Lexington",
             "provinceCode" => "KY",
               "postalCode" => "40511",
              "countryCode" => "US",
                 "latitude" => "38.3241",
                "longitude" => "-127.342"
        },
        "corporateAddress" => {
            "streetAddress" => "410 Terry Ave",
                     "unit" => "3L",
                     "city" => "Seattle",
             "provinceCode" => "WA",
               "postalCode" => "98109",
              "countryCode" => "US",
                 "latitude" => "22.3216",
                "longitude" => "-119.232"
        }
    }
}
```

Now create your case with the given hashed data:

```ruby
request = Signifyd::Case.create(transaction, {})
```
	
Upon successful case post, this will return a response that contains data on whether or not this was successful. It will look something like this:


