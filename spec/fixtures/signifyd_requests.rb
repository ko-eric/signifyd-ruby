class SignifydRequests
  class << self
    def valid_case
      email           = Faker::Internet.email
      full_name       = "#{Faker::Name.first_name} #{Faker::Name.last_name}"
      street_address  = Faker::Address.street_address
      username        = Faker::Internet.user_name
      phone_number    = Faker::PhoneNumber.phone_number
      
      {
        "attackMethod" => "STOLEN_CC", 
        "purchase" => {
          "browserIpAddress" => "50.141.59.109", 
          "createdAt" => "2013-02-21T18:37:35-05:00", 
          "currency" => "CAD", 
          "totalPrice" => "495.00", 
          "shippingPrice" => "20.00", 
          "products" => [
            {
              "itemId"        =>  (rand * 1000000).ceil, 
              "itemName"      =>  Faker::Company.catch_phrase, 
              "itemQuantity"  =>  (rand * 10).ceil, 
              "itemPrice"     =>  "#{(rand * 60).round(2)}", 
              "itemWeight"    =>  (rand * 10).ceil
            }
          ]
        }, 
        "recipient"=> {
          "fullName"=>full_name, 
          "confirmationEmail"=>nil, 
          "deliveryAddress"=> {
            "streetAddress"=>street_address, 
            "unit"=>nil, 
            "city"=>"Palo Alto", 
            "provinceCode"=>"CA", 
            "postalCode"=>"94306", 
            "countryCode"=>"US", 
            "latitude"=>"37.4248", 
            "longitude"=>"-122.148"
          }
        }, 
        "card"=> {
          "cardHolderName"=>full_name, 
          "bin"=>nil, 
          "billingAddress"=> {
            "streetAddress"=>street_address,  
            "unit"=>nil, 
            "city"=>"Palo Alto", 
            "provinceCode"=>"CA", 
            "postalCode"=>"94306", 
            "countryCode"=>"US", 
            "latitude"=>"37.4248", 
            "longitude"=>"-122.148"
          }
        }, 
        "userAccount"=>{ 
            "email"=>email, 
            "username"=>username, 
            "phone"=>phone_number, 
            "createdDate"=>nil, 
            "accountNumber"=>nil, 
            "lastOrderId"=>nil, 
            "aggregateOrderCount"=>nil, 
            "aggregateOrderDollars"=>nil, 
            "lastUpdateDate"=>nil
        },
        "seller"=> {
          "name"=> "Amazon",
          "domain"=> "amazon.com",
          "shipFromAddress"=> {
              "streetAddress"=> "1850 Mercer Rd",
              "unit"=> nil,
              "city"=> "Lexington",
              "provinceCode"=> "KY",
              "postalCode"=> "40511",
              "countryCode"=> "US",
              "latitude"=> nil,
              "longitude"=> nil
          },
          "corporateAddress"=> {
              "streetAddress"=> "410 Terry Ave",
              "unit"=> "3L",
              "city"=> "Seattle",
              "provinceCode"=> "WA",
              "postalCode"=> "98109",
              "countryCode"=> "US",
              "latitude"=> nil,
              "longitude"=> nil
          }
        }
      }
    end
    
    # systematic: example of correctly formatted json
    def correct_case_json
      "{\"attackMethod\":\"STOLEN_CC\",\"purchase\":{\"browserIpAddress\":\"50.141.59.109\",\"createdAt\":\"2013-02-21T18:37:35-05:00\",\"currency\":\"CAD\",\"totalPrice\":\"495.00\",\"shippingPrice\":\"20.00\",\"products\":[{\"itemId\":272111,\"itemName\":\"Intuitive 4th generation Graphic Interface\",\"itemQuantity\":5,\"itemPrice\":\"59.53\",\"itemWeight\":7}]},\"recipient\":{\"fullName\":\"Courtney Cruickshank\",\"confirmationEmail\":null,\"deliveryAddress\":{\"streetAddress\":\"22660 Greenholt Camp\",\"unit\":null,\"city\":\"Palo Alto\",\"provinceCode\":\"CA\",\"postalCode\":\"94306\",\"countryCode\":\"US\",\"latitude\":\"37.4248\",\"longitude\":\"-122.148\"}},\"card\":{\"cardHolderName\":\"Courtney Cruickshank\",\"bin\":null,\"billingAddress\":{\"streetAddress\":\"22660 Greenholt Camp\",\"unit\":null,\"city\":\"Palo Alto\",\"provinceCode\":\"CA\",\"postalCode\":\"94306\",\"countryCode\":\"US\",\"latitude\":\"37.4248\",\"longitude\":\"-122.148\"}},\"userAccount\":{\"email\":\"tom_berge@breitenbergbauch.org\",\"username\":\"tamia\",\"phone\":\"(715)038-1226\",\"createdDate\":null,\"accountNumber\":null,\"lastOrderId\":null,\"aggregateOrderCount\":null,\"aggregateOrderDollars\":null,\"lastUpdateDate\":null},\"seller\":{\"name\":\"Amazon\",\"domain\":\"amazon.com\",\"shipFromAddress\":{\"streetAddress\":\"1850 Mercer Rd\",\"unit\":null,\"city\":\"Lexington\",\"provinceCode\":\"KY\",\"postalCode\":\"40511\",\"countryCode\":\"US\",\"latitude\":null,\"longitude\":null},\"corporateAddress\":{\"streetAddress\":\"410 Terry Ave\",\"unit\":\"3L\",\"city\":\"Seattle\",\"provinceCode\":\"WA\",\"postalCode\":\"98109\",\"countryCode\":\"US\",\"latitude\":null,\"longitude\":null}}}"
    end
    
    # synopsis: Removed ":" between attackMethod and STOLEN_CC - should be attackMethod:STOLEN_CC
    def invalid_case_bad_json_01
      "{\"attackMethod\"    \"STOLEN_CC\",\"purchase\":{\"browserIpAddress\":\"50.141.59.109\",\"createdAt\":\"2013-02-21T18:37:35-05:00\",\"currency\":\"CAD\",\"totalPrice\":\"495.00\",\"shippingPrice\":\"20.00\",\"products\":[{\"itemId\":272111,\"itemName\":\"Intuitive 4th generation Graphic Interface\",\"itemQuantity\":5,\"itemPrice\":\"59.53\",\"itemWeight\":7}]},\"recipient\":{\"fullName\":\"Courtney Cruickshank\",\"confirmationEmail\":null,\"deliveryAddress\":{\"streetAddress\":\"22660 Greenholt Camp\",\"unit\":null,\"city\":\"Palo Alto\",\"provinceCode\":\"CA\",\"postalCode\":\"94306\",\"countryCode\":\"US\",\"latitude\":\"37.4248\",\"longitude\":\"-122.148\"}},\"card\":{\"cardHolderName\":\"Courtney Cruickshank\",\"bin\":null,\"billingAddress\":{\"streetAddress\":\"22660 Greenholt Camp\",\"unit\":null,\"city\":\"Palo Alto\",\"provinceCode\":\"CA\",\"postalCode\":\"94306\",\"countryCode\":\"US\",\"latitude\":\"37.4248\",\"longitude\":\"-122.148\"}},\"userAccount\":{\"email\":\"tom_berge@breitenbergbauch.org\",\"username\":\"tamia\",\"phone\":\"(715)038-1226\",\"createdDate\":null,\"accountNumber\":null,\"lastOrderId\":null,\"aggregateOrderCount\":null,\"aggregateOrderDollars\":null,\"lastUpdateDate\":null},\"seller\":{\"name\":\"Amazon\",\"domain\":\"amazon.com\",\"shipFromAddress\":{\"streetAddress\":\"1850 Mercer Rd\",\"unit\":null,\"city\":\"Lexington\",\"provinceCode\":\"KY\",\"postalCode\":\"40511\",\"countryCode\":\"US\",\"latitude\":null,\"longitude\":null},\"corporateAddress\":{\"streetAddress\":\"410 Terry Ave\",\"unit\":\"3L\",\"city\":\"Seattle\",\"provinceCode\":\"WA\",\"postalCode\":\"98109\",\"countryCode\":\"US\",\"latitude\":null,\"longitude\":null}}}"
    end
    
    # synopsis: Removed "," between STOLEN_CC and purchase - should be STOLEN_CC, purchase
    def invalid_case_bad_json_02
      "{\"attackMethod\":\"STOLEN_CC\"  \"purchase\":{\"browserIpAddress\":\"50.141.59.109\",\"createdAt\":\"2013-02-21T18:37:35-05:00\",\"currency\":\"CAD\",\"totalPrice\":\"495.00\",\"shippingPrice\":\"20.00\",\"products\":[{\"itemId\":272111,\"itemName\":\"Intuitive 4th generation Graphic Interface\",\"itemQuantity\":5,\"itemPrice\":\"59.53\",\"itemWeight\":7}]},\"recipient\":{\"fullName\":\"Courtney Cruickshank\",\"confirmationEmail\":null,\"deliveryAddress\":{\"streetAddress\":\"22660 Greenholt Camp\",\"unit\":null,\"city\":\"Palo Alto\",\"provinceCode\":\"CA\",\"postalCode\":\"94306\",\"countryCode\":\"US\",\"latitude\":\"37.4248\",\"longitude\":\"-122.148\"}},\"card\":{\"cardHolderName\":\"Courtney Cruickshank\",\"bin\":null,\"billingAddress\":{\"streetAddress\":\"22660 Greenholt Camp\",\"unit\":null,\"city\":\"Palo Alto\",\"provinceCode\":\"CA\",\"postalCode\":\"94306\",\"countryCode\":\"US\",\"latitude\":\"37.4248\",\"longitude\":\"-122.148\"}},\"userAccount\":{\"email\":\"tom_berge@breitenbergbauch.org\",\"username\":\"tamia\",\"phone\":\"(715)038-1226\",\"createdDate\":null,\"accountNumber\":null,\"lastOrderId\":null,\"aggregateOrderCount\":null,\"aggregateOrderDollars\":null,\"lastUpdateDate\":null},\"seller\":{\"name\":\"Amazon\",\"domain\":\"amazon.com\",\"shipFromAddress\":{\"streetAddress\":\"1850 Mercer Rd\",\"unit\":null,\"city\":\"Lexington\",\"provinceCode\":\"KY\",\"postalCode\":\"40511\",\"countryCode\":\"US\",\"latitude\":null,\"longitude\":null},\"corporateAddress\":{\"streetAddress\":\"410 Terry Ave\",\"unit\":\"3L\",\"city\":\"Seattle\",\"provinceCode\":\"WA\",\"postalCode\":\"98109\",\"countryCode\":\"US\",\"latitude\":null,\"longitude\":null}}}"
    end
    
    # synopsis: All json here will be of standard, the date will just be in wrong format for the SignifydPlatform API
    def invalid_case_bad_formatted_date_01
      "{\"attackMethod\":\"STOLEN_CC\",\"purchase\":{\"browserIpAddress\":\"50.141.59.109\",\"createdAt\":\"2013-02-afdadafasdf:77:35-05:00\",\"currency\":\"CAD\",\"totalPrice\":\"495.00\",\"shippingPrice\":\"20.00\",\"products\":[{\"itemId\":272111,\"itemName\":\"Intuitive 4th generation Graphic Interface\",\"itemQuantity\":5,\"itemPrice\":\"59.53\",\"itemWeight\":7}]},\"recipient\":{\"fullName\":\"Courtney Cruickshank\",\"confirmationEmail\":null,\"deliveryAddress\":{\"streetAddress\":\"22660 Greenholt Camp\",\"unit\":null,\"city\":\"Palo Alto\",\"provinceCode\":\"CA\",\"postalCode\":\"94306\",\"countryCode\":\"US\",\"latitude\":\"37.4248\",\"longitude\":\"-122.148\"}},\"card\":{\"cardHolderName\":\"Courtney Cruickshank\",\"bin\":null,\"billingAddress\":{\"streetAddress\":\"22660 Greenholt Camp\",\"unit\":null,\"city\":\"Palo Alto\",\"provinceCode\":\"CA\",\"postalCode\":\"94306\",\"countryCode\":\"US\",\"latitude\":\"37.4248\",\"longitude\":\"-122.148\"}},\"userAccount\":{\"email\":\"tom_berge@breitenbergbauch.org\",\"username\":\"tamia\",\"phone\":\"(715)038-1226\",\"createdDate\":null,\"accountNumber\":null,\"lastOrderId\":null,\"aggregateOrderCount\":null,\"aggregateOrderDollars\":null,\"lastUpdateDate\":null},\"seller\":{\"name\":\"Amazon\",\"domain\":\"amazon.com\",\"shipFromAddress\":{\"streetAddress\":\"1850 Mercer Rd\",\"unit\":null,\"city\":\"Lexington\",\"provinceCode\":\"KY\",\"postalCode\":\"40511\",\"countryCode\":\"US\",\"latitude\":null,\"longitude\":null},\"corporateAddress\":{\"streetAddress\":\"410 Terry Ave\",\"unit\":\"3L\",\"city\":\"Seattle\",\"provinceCode\":\"WA\",\"postalCode\":\"98109\",\"countryCode\":\"US\",\"latitude\":null,\"longitude\":null}}}"
    end
    
    # synopsis: All json here will be of standard, the date will just be in wrong format for the SignifydPlatform API
    def invalid_case_bad_formatted_date_02
      "{\"attackMethod\":\"STOLEN_CC\",\"purchase\":{\"browserIpAddress\":\"50.141.59.109\",\"createdAt\":\"2013-02-:z\",\"currency\":\"CAD\",\"totalPrice\":495.00\",\"shippingPrice\":\"20.00\",\"products\":[{\"itemId\":272111,\"itemName\":\"Intuitive 4th generation Graphic Interface\",\"itemQuantity\":5,\"itemPrice\":\"59.53\",\"itemWeight\":7}]},\"recipient\":{\"fullName\":\"Courtney Cruickshank\",\"confirmationEmail\":null,\"deliveryAddress\":{\"streetAddress\":\"22660 Greenholt Camp\",\"unit\":null,\"city\":\"Palo Alto\",\"provinceCode\":\"CA\",\"postalCode\":\"94306\",\"countryCode\":\"US\",\"latitude\":\"37.4248\",\"longitude\":\"-122.148\"}},\"card\":{\"cardHolderName\":\"Courtney Cruickshank\",\"bin\":null,\"billingAddress\":{\"streetAddress\":\"22660 Greenholt Camp\",\"unit\":null,\"city\":\"Palo Alto\",\"provinceCode\":\"CA\",\"postalCode\":\"94306\",\"countryCode\":\"US\",\"latitude\":\"37.4248\",\"longitude\":\"-122.148\"}},\"userAccount\":{\"email\":\"tom_berge@breitenbergbauch.org\",\"username\":\"tamia\",\"phone\":\"(715)038-1226\",\"createdDate\":null,\"accountNumber\":null,\"lastOrderId\":null,\"aggregateOrderCount\":null,\"aggregateOrderDollars\":null,\"lastUpdateDate\":null},\"seller\":{\"name\":\"Amazon\",\"domain\":\"amazon.com\",\"shipFromAddress\":{\"streetAddress\":\"1850 Mercer Rd\",\"unit\":null,\"city\":\"Lexington\",\"provinceCode\":\"KY\",\"postalCode\":\"40511\",\"countryCode\":\"US\",\"latitude\":null,\"longitude\":null},\"corporateAddress\":{\"streetAddress\":\"410 Terry Ave\",\"unit\":\"3L\",\"city\":\"Seattle\",\"provinceCode\":\"WA\",\"postalCode\":\"98109\",\"countryCode\":\"US\",\"latitude\":null,\"longitude\":null}}}"
    end
    
    def invalid_case_non_existent_key
      "{\"attackMethod\":\"STOLEN_CC\",\"purchase\":{\"browserIpAddress\":\"50.141.59.109\",\"createdAt\":\"2013-02-21T18:37:35-05:00\",\"hotDogs\":\"with ketchup\",\"currency\":\"CAD\",\"totalPrice\":\"495.00\",\"shippingPrice\":\"20.00\",\"products\":[{\"itemId\":272111,\"itemName\":\"Intuitive 4th generation Graphic Interface\",\"itemQuantity\":5,\"itemPrice\":\"59.53\",\"itemWeight\":7}]},\"recipient\":{\"fullName\":\"Courtney Cruickshank\",\"confirmationEmail\":null,\"deliveryAddress\":{\"streetAddress\":\"22660 Greenholt Camp\",\"unit\":null,\"city\":\"Palo Alto\",\"provinceCode\":\"CA\",\"postalCode\":\"94306\",\"countryCode\":\"US\",\"latitude\":\"37.4248\",\"longitude\":\"-122.148\"}},\"card\":{\"cardHolderName\":\"Courtney Cruickshank\",\"bin\":null,\"billingAddress\":{\"streetAddress\":\"22660 Greenholt Camp\",\"unit\":null,\"city\":\"Palo Alto\",\"provinceCode\":\"CA\",\"postalCode\":\"94306\",\"countryCode\":\"US\",\"latitude\":\"37.4248\",\"longitude\":\"-122.148\"}},\"userAccount\":{\"email\":\"tom_berge@breitenbergbauch.org\",\"username\":\"tamia\",\"phone\":\"(715)038-1226\",\"createdDate\":null,\"accountNumber\":null,\"lastOrderId\":null,\"aggregateOrderCount\":null,\"aggregateOrderDollars\":null,\"lastUpdateDate\":null},\"seller\":{\"name\":\"Amazon\",\"domain\":\"amazon.com\",\"shipFromAddress\":{\"streetAddress\":\"1850 Mercer Rd\",\"unit\":null,\"city\":\"Lexington\",\"provinceCode\":\"KY\",\"postalCode\":\"40511\",\"countryCode\":\"US\",\"latitude\":null,\"longitude\":null},\"corporateAddress\":{\"streetAddress\":\"410 Terry Ave\",\"unit\":\"3L\",\"city\":\"Seattle\",\"provinceCode\":\"WA\",\"postalCode\":\"98109\",\"countryCode\":\"US\",\"latitude\":null,\"longitude\":null}}}"
    end
  end
end
