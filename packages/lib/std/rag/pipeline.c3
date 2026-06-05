module std::rag::pipeline;

import std::llm::client;
import std::llm::types;
import std::rag::store;
import std::rag::vector;
import std::rag::chunker;
import std::rag::templates;

struct RAGPipeline {
    LLMConfig llm_config;
    VectorStoreProvider vector_store;
    PromptTemplate query_template;
}

fn QueryResult[] rerank(QueryResult[] results, String query) {
    return results; 
}

fn String pipeline_query(RAGPipeline* pipeline, String query, Vector query_embedding) {
    QueryResult[] candidates = pipeline.vector_store.query(&pipeline.vector_store, query_embedding, 10);

    QueryResult[] refined = rerank(candidates, query);
    QueryResult[] top_results = refined.slice(0, 3);

    String context;
    for (int i = 0; i < top_results.len; i++) {
        context += top_results[i].doc.content + "\n";
    }

    Map(String, String) vars;
    vars.set("context", context);
    vars.set("query", query);
    String prompt = templates::render(pipeline.query_template, vars);

    Message[] messages;
    messages.push(Message { .role = Role.USER, .content = prompt });

    Completion completion = client::complete(pipeline.llm_config, messages);

    return completion.text;
}
