module examples::playground_bench;

import std::llm::playground;
import std::llm::runtime;
import std::llm::manager;
import std::io;

fn int main(String[] args) {
    // 1. Setup Backends
    BackendProvider ollama = runtime::create_ollama_backend("http://localhost:11434");
    BackendProvider mock = runtime::create_ollama_backend("http://mock:11434"); // Simulating another provider

    // 2. Setup Playground
    Playground pg = {
        .manager = { .active_backend = &ollama },
        .rag_enabled = false,
    };

    BackendProvider[] backends = { ollama, mock };
    String[] models = { "llama3", "mistral" };

    io::printn("Running Model Comparison...");
    ExperimentResult[] results = playground::playground_run_comparison(&pg, "Why is C3 better than C?", backends, models);

    for (ExperimentResult res : results) {
        io::printn("---");
        io::printn("Model: " + res.model_name + " | Backend: " + res.backend_name);
        io::printn("Latency: " + res.latency_ms + "ms");
        io::printn("Output: " + res.output);
    }

    return 0;
}
