"use strict";

$("#add").on("submit", function (e) {
  e.preventDefault();
  var data = new FormData(this);
  var object = {
    "id": parseInt(data.get("id")),
    "passcode": data.get("passcode").length > 0 ? data.get("passcode") : null,
    "notes": data.get("notes").length > 0 ? data.get("notes") : null
  };
  var json = JSON.stringify(object);
  $.ajax({
    type: "POST",
    url: "/api/add",
    contentType: "application/json",
    data: json,
    complete: function complete(xhr, text) {
      var code = xhr.status;

      if (code == 400) {
        $("#errors").append("<div class=\"alert alert-danger alert-dismissible fade show\" role=\"alert\">\n  <strong>Check to make sure you meet all field requirements.</strong>\n  <button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"Close\">\n    <span aria-hidden=\"true\">&times;</span>\n  </button>\n</div>");
        return;
      }

      window.location.href = "/";
    }
  });
});