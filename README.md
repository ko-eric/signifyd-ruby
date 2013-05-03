# Signifyd Ruby 

[![Build Status](https://travis-ci.org/signifyd/signifyd-ruby.png?branch=master)](https://travis-ci.org/signifyd/signifyd-ruby)
[![Dependency Status](https://gemnasium.com/signifyd/signifyd-ruby.png)](https://gemnasium.com/signifyd/signifyd-ruby)
[![Code Climate](https://codeclimate.com/github/signifyd/signifyd-ruby.png)](https://codeclimate.com/github/signifyd/signifyd-ruby)
[![Coverage Status](https://coveralls.io/repos/signifyd/signifyd-ruby/badge.png?branch=master)](https://coveralls.io/r/signifyd/signifyd-ruby)

## Introduction
This is the official ruby library for the Signifyd API rubygem. Install the gem, get your API key from the Signifyd portal at [Signifyd](https://signifyd.com) and start posting your transactions for fraud detection/scoring. Every transaction you post to the API, it will create a new investigation. 

Before using this library, be sure to look at our third party authentications you can add to your account. Signifyd allows you to connect your Stripe or Shopify store/account and it will automatically create investigations for your transactions as they come in realtime. 

Please read the [documentation](https://www.signifyd.com/docs/api) for creating a case. Even though you are using the ruby library we have created, you must still adhere to the data type and encoding of the data to match what we expect a correct post will be.

## Installation 
The installation can be used for a stand alone ruby application, Sinatra or a Rails application.

	$ gem install signifyd
	
For Rails applications, include in Gemfile.

```ruby
gem 'signifyd'
```

Now that you have installed the gem. Go ahead and configure your API-key. In a Rails application, you can create a file `config/initializers/signifyd.com` and include this line. 

```ruby
require 'signifyd'
Signifyd.api_key = 'YOUR-API-KEY'
```
	
Otherwise include and set this in an initialization block of your Sinatra or Ruby application. This will persist throughout the lifetime of your application. If you do not set your API key globally like the example above. You can pass your key into any method and it will authenticate on each single request as follows:

```ruby
# ***ONLY do this if you have not set your API key using the global 'Signifyd.api_key=' setter
create = Signifyd::Case.create(transaction_hash, 'YOUR-API-KEY')
update = Signifyd::Case.update(case_id, attributes_hash, 'YOUR-API-KEY')
```

## Errors
You can catch your errors based on these sub classes. 

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

Upon a successful case/investigation creation or any endpoint called. Signifyd will return an [HTTP status code](http://httpstatus.es/) that makes sense for the resource called and data manipulated for the restful endpoint.

## Methods
Currently Signifyd supports the following methods for investigations against your transactions. The Cases endpoint is where you will start. Encode your transaction to match the JSON we require for a successful creation and make your request.

### Cases
To create a case, follow the instructions below. Please read the [documentation](https://www.signifyd.com/docs/api) under your account. It is imperative that you follow the guides correctly and encode all pieces of data with the correct format and data types otherwise this will effect the score of your transaction's investigation. 

```ruby
transaction = {
    "attackMethod" => "STOLEN_CC",
        "purchase" => {
        "avsResponseCode"  => "Y",
        "cvvResponseCode"  => "M",
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

List cases:
```ruby
> Signifyd::Case.all({count: 100, offset: 0}, {})
=> {code: 200, body: []}
```

Create a case: 

```ruby
> Signifyd::Case.create(transaction, {})
=> {code: 201, body: {investigationId: 48573}}
```

Update a case: 

```ruby
> data = {'purchase' => {'avsResponseCode' => 'Y', 'cvvResponseCode' => 'M'}}
> Signifyd::Case.update(48573, JSON.dump(data), {})
=> {code: 200, body: {investigationBody}}
```

All methods will be restful and will respond to a CRUD interface. `/cases` accepts GET requests to return all your cases, POST, with a json body to create a case, PUT, with a case_id to update a case and DELETE to remove an investigation.