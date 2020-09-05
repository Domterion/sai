require "mongo"

module Sai
  class Meeting
    include JSON::Serializable
    property id : Int64
    property passcode : String | Nil
    property notes : String | Nil
    property created : Int64 = Time.utc.to_unix
  end
end
