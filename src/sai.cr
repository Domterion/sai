require "kemal"
require "html"
require "./*"

module Sai
  VERSION  = "0.1.0"
  DATABASE = Sai::Database.new

  class Utils
    def self.clean(meeting : Sai::Meeting)
      meeting.passcode = meeting.passcode ? HTML.escape(meeting.passcode.as(String)) : nil
      meeting.notes = meeting.notes ? HTML.escape(meeting.notes.as(String)) : nil

      puts meeting

      meeting
    end
  end

  add_handler Sai::Handler.new

  get "/" do |env|
    render "src/views/index.ecr", layout: "src/views/layout.ecr"
  end

  get "/add" do |env|
    render "src/views/add.ecr", layout: "src/views/layout.ecr"
  end

  post "/api/add" do |env|
    begin
      id = env.params.json["id"].as(Int64)
    rescue
      # next {msg: "Invalid Meeting ID provided."}.to_json, status_code: 400
      halt env, 400, ({msg: "Invalid Meeting ID provided."}.to_json)
    end

    if !id.nil?
      if id > 100_000_000_000 || DATABASE.meetings.fetch(id) { nil }
        # next {msg: "Invalid Meeting ID provided, it may already be in our database."}.to_json, status_code: 400
        halt env, 400, ({msg: "Invalid Meeting ID provided, it may already be in our database."}.to_json)
      end
    end

    begin
      passcode = env.params.json["passcode"].as(String?)
      if !passcode.nil?
        if passcode.as(String).size > 16
          # next {msg: "Invalid passcode."}.to_json, status_code: 400
          halt env, 400, ({msg: "Invalid passcode."}.to_json)
        end
      end
    rescue
      passcode = nil
    end

    begin
      notes = env.params.json["notes"].as(String?)
      if !notes.nil?
        if notes.as(String).size > Sai::Config::NOTE_LIMIT
          # next {msg: "Invalid notes, these cant be over #{Sai::Config::NOTE_LIMIT} characters."}.to_json, status_code: 400
          halt env, 400, ({msg: "Invalid notes, these cant be over #{Sai::Config::NOTE_LIMIT} characters."}.to_json)
        end
      end
    rescue
      notes = nil
    end

    meeting = Sai::Meeting.from_json({"id": id, "passcode": passcode, "notes": notes, "created": Time.utc.to_unix}.to_json)

    DATABASE.add_meeting meeting

    meeting.to_json
  end

  delete "/api/delete" do |env|
    begin
      id = env.params.json["id"].as(Int64)
    rescue
      # next {msg: "Invalid Meeting ID provided."}.to_json, status_code: 400
      halt env, 400, ({msg: "Invalid Meeting ID provided."}.to_json)
    end

    DATABASE.delete_meeting id

    {msg: "OK"}.to_json
  end

  Kemal.run port: Sai::Config::PORT
end
