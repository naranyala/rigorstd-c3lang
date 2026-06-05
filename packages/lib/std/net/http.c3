module std::net::http;

struct Request {
    String method;
    String url;
    String headers;
    String body;
}

struct Response {
    int status_code;
    String headers;
    String body;
}

fn Response send_request(Request req) {
    return Response {
        .status_code = 200,
        .body = "{}",
    };
}
