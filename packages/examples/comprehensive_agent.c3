module examples::comprehensive_agent;

import std::llm::runtime;
import std::llm::manager;
import std::llm::agent;
import std::llm::types;
import std::llm::playground;
import std::rag::chunker;
import std::rag::store;
import std::rag::pipeline;
import std::rag::templates;
import std::io;

// --- 1. Custom Tool Definitions ---

// This tool wraps the RAG Pipeline. 
// The Agent will call this when it needs "Knowledge Base" information.
fn String rag_knowledge_tool(String query) {
    io::printn("[Tool] Searching Knowledge Base for: " + query);
    
    // These would normally be part of a global state or passed in
    // For this example, we'll use a simplified static-like setup
    LLMConfig config = { .model = "llama3", .base_url = "http://localhost:11434" };
    VectorStoreProvider store = store::create_in_memory_store();
    
    // Seed some data
    store.add(&store, Document { 
        .id = "1", .content = "The C3 language is highly performant.", .embedding = { .values = [1.0f] } 
    });

    PromptTemplate tmpl = { .template_text = "Use context: {context} to answer {query}" };
    RAGPipeline pipeline = { .llm_config = config, .vector_store = store, .query_template = tmpl };

    return pipeline::pipeline_query(&pipeline, query, { .values = [1.0f] });
}

// A simple utility tool
fn String calculator_tool(String args) {
    io::printn("[Tool] Calculating: " + args);
    return "The result is 42";
}

fn int main(String[] args) {
    io::printn("=== Initializing Comprehensive LLM Orchestrator ===\n");

    // --- 2. Runtime & Manager Setup ---
    BackendProvider backend = runtime::create_ollama_backend("http://localhost:11434");
    ModelManager manager = {
        .active_backend = &backend,
        .available_models = [
            ModelMetadata { .name = "llama3", .path = "/models/llama3.gguf", .parameter_count = 8.0 },
            ModelMetadata { .name = "mistral", .path = "/models/mistral.gguf", .parameter_count = 7.0 },
        ]
    };
    manager::manager_switch_model(&manager, "llama3");

    // --- 3. Agent Configuration ---
    Agent agent = {
        .config = { .model = manager.active_model_name, .base_url = "http://localhost:11434" },
    };
    
    // Expose RAG and Utils to the Agent
    agent::agent_add_tool(&agent, "search_knowledge_base", rag_knowledge_tool);
    agent::agent_add_tool(&agent, "calculate", calculator_tool);

    // --- 4. Playground Orchestration ---
    Playground pg = {
        .manager = manager,
        .rag_enabled = true,
    };

    // Test Scenario: A query that requires both RAG and Calculation
    String user_query = "What is C3 and what is 20+22?";
    Message[] history;
    history.push(Message { .role = Role.USER, .content = user_query });

    io::printn("User Query: " + user_query);
    io::printn("Agent is orchestrating tools...\n");
    
    String final_answer = agent::agent_chat(&agent, history);
    
    io::printn("\n=== Final Integrated Response ===\n" + final_answer);

    return 0;
}
