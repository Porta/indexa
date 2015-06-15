require 'msgpack'
require 'redic'


class Indexa

    NAMESPACE   = 'Busca' #TODO: Confirm gem name
    LUA_CACHE   = Hash.new { |h, k| h[k] = Hash.new }
    LUA_INDEX   = File.expand_path("./lib/lua/index.lua")
    LUA_REMOVE  = File.expand_path("./lib/lua/remove.lua")

    def initialize(namespace = NAMESPACE, opts = {})
        @namespace = namespace
        redis = opts[:redis] || Redic.new
    end

    def add(document_id, words)
        index_id = script( LUA_INDEX, 0,
           @namespace.to_msgpack,
           document_id.to_msgpack,
           words.to_msgpack
          )
        return index_id
    end

    def remove(id)
        result = script( LUA_REMOVE, 0,
           @namespace.to_msgpack,
           id.to_msgpack
        )
        return result        
    end

    def redis
        @redis ||= Redic.new
    end


    protected

    def key(name)
        Nido.new(NAMESPACE)[name]
    end

    def redis=(redis)
        @redis = redis
    end  

    def script(file, *args)
        cache = LUA_CACHE[redis.url]

        if cache.key?(file)
          sha = cache[file]
        else
          src = File.read(file)
          sha = redis.call("SCRIPT", "LOAD", src)

          cache[file] = sha
        end

        redis.call("EVALSHA", sha, *args)
    end

end