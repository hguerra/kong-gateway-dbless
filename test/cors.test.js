function request() {
  var settings = {
    url: "http://localhost:8080/gateway/health/status?auth_token=xyz",
    method: "GET",
    timeout: 0,
  };

  $.ajax(settings).done(function (response) {
    console.log("cors liberado com sucesso.");
    console.log(response);
  });
}

function testCors() {
  console.log("cors-test");

  request();
}
