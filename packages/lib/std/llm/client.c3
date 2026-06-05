module std::llm::client;

import std::llm::types;
import std::net::http;
import std::json;

type StreamCallback = fn(String token);

fn Completion complete(LLMConfig config, Message[] messages) {
    String payload = json::serialize(messages);
    http::Request req {
        .method = "POST",
        .url = config.base_url + "/chat/completions",
        .headers = "Content-Type: application/json\nAuthorization: Bearer " + config.api_key,
        .body = payload,
    };
    http::Response res = http::send_request(req);
    Completion completion;
    json::deserialize(res.body, &completion);
    return completion;
}

fn void complete_stream(LLMConfig config, Message[] messages, StreamCallback callback) {
    String payload = json::serialize(messages); 
    
    http::Request req {
        .method = "POST",
        .url = config.base_url + "/chat/completions",
        .headers = "Content-Type: application/json",
        .body = payload,
    };

    http::Response res = http::send_request(req);
    
    String[] tokens = res.body.split(" "); 
    for (String token : tokens) {
        callback(token);
    }
}
