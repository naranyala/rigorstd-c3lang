module examples::basic_chat;

import std::llm::client;
import std::llm::types;
import std::io;

fn int main(String[] args) {
    LLMConfig config = {
        .model = "llama3",
        .api_key = "local-key",
        .base_url = "http://localhost:11434",
    };

    Message[] messages;
    messages.push(Message { .role = Role.USER, .content = "Explain C3 language in one sentence." });

    io::printn("--- Sync Response ---");
    Completion res = client::complete(config, messages);
    io::printn(res.text);

    io::printn("\n--- Streaming Response ---");
    client::complete_stream(config, messages, fn(String token) {
        io::print(token + " ");
    });
    io::printn("");

    return 0;
}
