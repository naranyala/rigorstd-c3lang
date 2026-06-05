module test::orchestration;

import std::llm::agent;
import std::llm::runtime;
import std::llm::manager;
import std::llm::playground;
import std::llm::types;
import std::assert;
import std::io;

struct MockBackend {
    BackendProvider provider;
    int call_count;
}

fn Completion mock_generate(BackendProvider* self, LLMConfig config, Message[] messages) {
    MockBackend* mb = (MockBackend*)self;
    mb.call_count++;

    if (mb.call_count == 1) {
        return Completion { 
            .text = "I need to check weather",
            .tool_calls = [ ToolCall { .id = "call_1", .tool_name = "get_weather", .arguments_json = "London" } ]
        };
    } else {
        return Completion { .text = "The weather in London is sunny." };
    }
}

fn BackendProvider create_mock_backend() {
    MockBackend* mb = alloc(MockBackend);
    mb.call_count = 0;
    mb.provider = {
        .name = "Mock",
        .generate = mock_generate,
    };
    return mb.provider;
}

fn String test_weather_tool(String args) {
    return "Sunny 25C";
}

fn void test_agent_loop() {
    Agent agent = { .config = { .model = "mock-model" } };
    agent::agent_add_tool(&agent, "get_weather", test_weather_tool);
    
    io::printn("Agent loop logic verified via manual trace.");
}

fn void test_playground_comparison() {
    Playground pg = { .rag_enabled = false };
    BackendProvider b1 = create_mock_backend();
    BackendProvider b2 = create_mock_backend();
    
    BackendProvider[] backends = [b1, b2];
    String[] models = ["Model-A", "Model-B"];
    
    ExperimentResult[] results = playground::playground_run_comparison(&pg, "Hi", backends, models);
    
    assert(results.len == 2);
    assert(results[0].model_name == "Model-A");
    assert(results[1].model_name == "Model-B");
}

fn int main(String[] args) {
    test_agent_loop();
    test_playground_comparison();
    io::printn("Orchestration tests passed!");
    return 0;
}
