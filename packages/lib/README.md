# C3 LLM & RAG Stdlib Design

This library provides a set of tools for building LLM-powered applications and RAG (Retrieval-Augmented Generation) systems in C3.

## Modules

### `std.llm`
- `types`: Common types for LLM API interactions.
- `client`: High-level client to send requests to LLM providers.

### `std.rag`
- `vector`: Basic vector operations for calculating similarity between embeddings.
- `chunker`: Utilities for splitting large texts into manageable chunks.
- `store`: Vector storage and retrieval mechanisms.
- `pipeline`: A high-level pipeline that coordinates retrieval and generation.

### Dependencies
- `std.net.http`: Used by `std.llm.client` for API calls.
- `std.json`: Used for parsing LLM requests and responses.

## Example Usage

```c3
import std.llm.types;
import std.llm.client;
import std.rag.pipeline;

fn main() {
    LLMConfig config = {
        .model = "gpt-4",
        .api_key = "your-key",
        .base_url = "https://api.openai.com/v1",
    };

    RAGPipeline pipeline = {
        .llm_config = config,
        .vector_store = { ... },
    };

    String answer = pipeline_query(&pipeline, "What is C3?", query_vec);
    print(answer);
}
```
