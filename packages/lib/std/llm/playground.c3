module std::llm::playground;

import std::llm::runtime;
import std::llm::manager;
import std::llm::types;
import std::rag::pipeline;

struct ExperimentResult {
    String model_name;
    String backend_name;
    String output;
    float latency_ms;
}

struct Playground {
    ModelManager manager;
    RAGPipeline* rag_pipeline;
    bool rag_enabled;
}

fn ExperimentResult[] playground_run_comparison(Playground* pg, String prompt, BackendProvider[] backends, String[] models) {
    ExperimentResult[] results;

    for (int i = 0; i < backends.len; i++) {
        BackendProvider* backend = backends[i];
        String model = models[i];

        String final_prompt = prompt;
        if (pg.rag_enabled && pg.rag_pipeline != null) {
            // dummy_vec should be defined or passed in
            final_prompt = pipeline::pipeline_query(pg.rag_pipeline, prompt, { .values = [0.0f] });
        }

        Message[] messages;
        messages.push(Message { .role = Role.USER, .content = final_prompt });

        float start_time = 0.0f; // Replace with actual get_time_ms()
        Completion res = backend.generate(backend, { .model = model }, messages);
        float end_time = 1.0f;

        results.push(ExperimentResult {
            .model_name = model,
            .backend_name = backend.name,
            .output = res.text,
            .latency_ms = end_time - start_time,
        });
    }

    return results;
}
