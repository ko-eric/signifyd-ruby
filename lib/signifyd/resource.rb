module Signifyd
  class Resource < SignifydObject
    def self.class_name
      self.name.split('::')[-1]
    end
    
    def self.url
      raise NotImplementedError.new('APIResource is an abstract class. You should perform actions on its subclasses (Case).') if self == Resource
     "#{@@api_version}#{CGI.escape(class_name.downcase)}s"
    end
    
    def url
      unless id = self['id']
        raise InvalidRequestError.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{id.inspect}", 'id')
      end
      "#{self.class.url}/#{CGI.escape(id)}"
    end
  end
end