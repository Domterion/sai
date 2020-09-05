require "./*"

require "mongo"

module Sai
  class Database
    @@meetings = {} of Int64 => Sai::Meeting
    @@client = Mongo::Client.new Sai::Config::MONGO
    @@db : Mongo::Database = @@client["sai"]
    @@collection : Mongo::Collection = @@db["sai"]

    def initialize
      @@collection.find({"_id" => {"$gt" => 0}}).each do |doc|
        meeting = Sai::Meeting.from_json({"id": doc["_id"].as(Int64), "passcode": doc["passcode"].as(String?), "notes": doc["notes"].as(String?), "created": doc["created"].as(Int64)}.to_json)
        add_meeting(meeting, false)
      end
    end

    def add_meeting(meeting : Sai::Meeting, db : Bool = true)
      if db
        begin
          meeting = Sai::Utils.clean(meeting)
          @@collection.insert({"_id" => meeting.id, "passcode" => meeting.passcode, "notes" => meeting.notes, "created" => meeting.created})
        rescue
          puts "[MONGO] Error when inserting meeting #{meeting}"
        end
      end

      @@meetings[meeting.id] = meeting
    end

    def delete_meeting(id : Int64)
      begin
        @@collection.remove({"_id" => id})
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
