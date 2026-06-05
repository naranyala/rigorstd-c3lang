module examples::simple_rag;

import std::rag::chunker;
import std::rag::store;
import std::rag::pipeline;
import std::rag::templates;
import std::llm::types;
import std::io;

fn int main(String[] args) {
    // 1. The Knowledge Base
    String document = "C3 is a systems programming language designed to be a better C. It has a strong type system and avoids the pitfalls of C while maintaining performance.";
    
    // 2. Chunking
    String[] separators = { "\n\n", "\n", " " };
    String[] chunks = chunker::recursive_split(document, 50, separators);

    // 3. Storage
    VectorStoreProvider store = store::create_in_memory_store();
    for (int i = 0; i < chunks.len; i++) {
        store.add(&store, Document {
            .id = "doc_" + i,
            .content = chunks[i],
            .embedding = { .values = [1.0f, 0.0f] }, // Mock embedding
        });
    }

    // 4. Pipeline Setup
    LLMConfig config = { .model = "llama3", .base_url = "http://localhost:11434" };
    PromptTemplate tmpl = { .template_text = "Context: {context}\n\nQuestion: {query}\nAnswer:" };
    
    RAGPipeline pipeline = {
        .llm_config = config,
        .vector_store = store,
        .query_template = tmpl,
    };

    // 5. Query
    String answer = pipeline::pipeline_query(&pipeline, "What is C3?", { .values = [1.0f, 0.0f] });
    io::printn("RAG Answer: " + answer);

    return 0;
}
