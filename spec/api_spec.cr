require "./spec_helper"

# To run do KEMAL_ENV=test crystal spec

describe Sai do
  it "checks to make sure json is returned" do
    body = {"id": 999_9999_9999, "passcode": "passcode", "notes": "notes"}

    post("/api/add", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: body.to_json)

    response.body.should eq(body.to_json)
  end

  it "checks for id error" do
    body = {"id": 100_000_000_001, "passcode": "passcode", "notes": "notes"}

    post("/api/add", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: body.to_json)
    response.body.should eq({msg: "Invalid Meeting ID provided, it may already be in our database."}.to_json)
  end

  it "checks for passcode error" do
    body = {"id": 1, "passcode": "this should fail for password length", "notes": "notes"}

    post("/api/add", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: body.to_json)
    response.body.should eq({msg: "Invalid passcode."}.to_json)
  end

  it "checks for notes error" do
    body = {"id": 1, "passcode": "passcode", "notes": "Q3F1mcUjL5WFHzFKrvcGmk3Eged2GEIgkL1szQ5QgdEY825e8BJa7FBjayEtGDHUbAXDNvJXJsEhli52bNfSNukhDWETtcqSLDdT
    7UeaiqrXUFWfwzvOoecKmShuT7VZjp3QpP1DhnsRmZ8xvGbRbB9p5BDFYENwAYd4zj4FZ2QYf2y4VEOW9HQ8bRwLolzjgAjiuH
    aEDbUWSamoLe7rEwEg4i6exQNZl7qfwzEUSVV8SKHkdXkKYge8AhRXwzFcbJI8uMoX1VNmGMc0IFJbxZD3ZsNVN2svxYhlES48
    FmDR9F2T8AzpxZYnNgdkqV8FWaGyQEqwOl4LjkVjWxC4dxyCRuYPsZf9Fqt1cdKMw9Iw8DBN3rIlWPlqu0nMhBmuYKhfE6jFEu
    oeKGE8Avarl9rz8DNfGRaDAYxuNPPXnyHdpSttCLq9NyNA5QgDliNVydyHZDk1KE0lngusCHfTe0xKWY3viBdzW6VL27ZLrHoW
    pWaUM87uxLKDrYqf4Vqv9"}

    post("/api/add", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: body.to_json)
    response.body.should eq({msg: "Invalid notes, these cant be over 512 characters."}.to_json)
  end

  it "checks for notes error" do
    body = {"id": 1, "passcode": "passcode", "notes": "Q3F1mcUjL5WFHzFKrvcGmk3Eged2GEIgkL1szQ5QgdEY825e8BJa7FBjayEtGDHUbAXDNvJXJsEhli52bNfSNukhDWETtcqSLDdT
    7UeaiqrXUFWfwzvOoecKmShuT7VZjp3QpP1DhnsRmZ8xvGbRbB9p5BDFYENwAYd4zj4FZ2QYf2y4VEOW9HQ8bRwLolzjgAjiuH
    aEDbUWSamoLe7rEwEg4i6exQNZl7qfwzEUSVV8SKHkdXkKYge8AhRXwzFcbJI8uMoX1VNmGMc0IFJbxZD3ZsNVN2svxYhlES48
    FmDR9F2T8AzpxZYnNgdkqV8FWaGyQEqwOl4LjkVjWxC4dxyCRuYPsZf9Fqt1cdKMw9Iw8DBN3rIlWPlqu0nMhBmuYKhfE6jFEu
    oeKGE8Avarl9rz8DNfGRaDAYxuNPPXnyHdpSttCLq9NyNA5QgDliNVydyHZDk1KE0lngusCHfTe0xKWY3viBdzW6VL27ZLrHoW
    pWaUM87uxLKDrYqf4Vqv9"}

    post("/api/add", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: body.to_json)
    response.body.should eq({msg: "Invalid notes, these cant be over 512 characters."}.to_json)
  end

  it "deletes a meeting" do
    body = {"id": 999_9999_9999}

    delete("/api/delete", headers: HTTP::Headers{"Content-Type" => "application/json"}, body: body.to_json)

    response.body.should eq({msg: "OK"}.to_json)
  end
end
