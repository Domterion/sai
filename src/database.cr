require "./*"

require "mongo"

module Sai
  class Database
    @@meetings = {} of Int64 => Sai::Meeting
    CLIENT     = Mongo::Client.new Sai::Config::MONGO
    DB         = CLIENT["sai"]
    COLLECTION = DB["sai"]

    def initialize
      COLLECTION.find({"_id" => {"$gt" => 0}}).each do |doc|
        meeting = Sai::Meeting.from_json({"id": doc["_id"].as(Int64), "passcode": doc["passcode"].as(String?), "notes": doc["notes"].as(String?), "created": doc["created"].as(Int64)}.to_json)
        add_meeting(meeting, false)
      end
    end

    def add_meeting(meeting : Sai::Meeting, db : Bool = true)
      if db
        begin
          meeting = Sai::Utils.clean(meeting)
          COLLECTION.insert({"_id" => meeting.id, "passcode" => meeting.passcode, "notes" => meeting.notes, "created" => meeting.created})
        rescue
          puts "[MONGO] Error when inserting meeting #{meeting}"
        end
      end

      @@meetings[meeting.id] = meeting
    end

    def delete_meeting(id : Int64)
      begin
        COLLECTION.remove({"_id" => id})
      rescue
        puts "[MONGO] Error when deleting meeting #{id}"
      end
      @@meetings.delete(id)
    end

    def meetings
      @@meetings
    end
  end
end
