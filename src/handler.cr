require "kemal"

module Sai
  class Handler < Kemal::Handler
    only ["/api/add", "/api/delete"]

    def call(env)
      return call_next(env) unless only_match?(env)
      env.response.content_type = "application/json"
    end
  end
end
