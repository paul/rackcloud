
module RackCloud
  
  class DatapathyRackCloudAdapter < Datapathy::Adapters::AbstractAdapter

    attr_reader :http,
                :token, :storage_token, 
                :urls, :auth_url,
                :user, :key

    def initialize(options = {})
      super

      @user, @key = options[:user], options[:key]

      @auth_url = options[:auth_url] || "https://auth.api.rackspacecloud.com/v1.0"
      @urls = {:auth => @auth_url}

      @http = Resourceful::HttpAccessor.new
      @http.logger = Resourceful::StdOutLogger.new
      @http.cache_manager = Resourceful::InMemoryCacheManager.new
      get_auth_token!
    end

    def read(query)
      response = resource(query.model, true).get(token_header.merge(:content_type => 'application/json'))
      records = parse_response(response)[root_name(query.model)]
      query.filter_records(records)
    end

    protected

    def parse_response(response)
      JSON.parse(response.body)
    end

    def base_url(model)
      case model.to_s
      when "Server", "Flavor", "Image", "SharedIpGroup"
        urls[:server_management]
      else
        raise ArgumentError, "Unknown model #{model}"
      end
    end

    def location(model)
      model.to_s.underscore.pluralize
    end

    def root_name(model)
      name = model.to_s.pluralize
      name[0] = name[0].chr.downcase![0]
      name
    end

    def resource(model, detail = false)
      url = "#{base_url(model)}/#{location(model)}#{detail ? "/detail" : ""}"
      http.resource(url)
    end

    def get_auth_token!
      response = request_auth

      @token          = response.header['X-Auth-Token'].first
      @storage_token  = response.header['X-Storage-Token'].first

      urls[:storage]            = response.header['X-Storage-Url'].first
      urls[:server_management]  = response.header['X-Server-Management-Url'].first
      urls[:cdn_management_uri] = response.header['X-CDN-Management-Url'].first
    end

    def request_auth
      http.resource(auth_url).get(auth_headers)
    end

    def auth_headers
      {
        'X-Auth-User' => user,
        'X-Auth-Key'  => key
      }
    end

    def token_header
      {
        'X-Auth-Token' => token
      }
    end


  end
end


