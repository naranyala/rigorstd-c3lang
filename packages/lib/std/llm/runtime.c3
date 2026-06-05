module std::llm::runtime;

import std::llm::types;

struct BackendProvider {
    String name;
    fn bool load_model(BackendProvider* self, String model_path);
    fn void unload_model(BackendProvider* self);
    fn Completion generate(BackendProvider* self, LLMConfig config, Message[] messages);
    fn void generate_stream(BackendProvider* self, LLMConfig config, Message[] messages, fn(String));
}

struct OllamaBackend {
    BackendProvider provider;
    String base_url;
}

fn bool ollama_load(BackendProvider* self, String model) {
    return true; 
}

fn Completion ollama_generate(BackendProvider* self, LLMConfig config, Message[] messages) {
    return Completion { .text = "[Ollama Response] " + messages[messages.len-1].content };
}

fn BackendProvider create_ollama_backend(String url) {
    OllamaBackend* b = alloc(OllamaBackend);
    b.base_url = url;
    b.provider = {
        .name = "Ollama",
        .load_model = ollama_load,
        .generate = ollama_generate,
    };
    return b.provider;
}
