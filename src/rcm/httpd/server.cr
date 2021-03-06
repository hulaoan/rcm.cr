require "http/server"

module Rcm::Httpd
  class Server
    delegate config, to: Kemal
    
    def initialize(@redis : ::Redis::Client, @listen : Bootstrap)
      config.add_handler RedisHandler.new(@redis, watch_interval: 1.second)
      pass = @redis.password || @listen.pass
      if pass
        auth_handler = HTTPBasicAuth.new("redis", pass)
        config.add_handler auth_handler
      end

      config.port = @listen.port
    end
    
    def start
      Kemal.run
    end
  end  
end
