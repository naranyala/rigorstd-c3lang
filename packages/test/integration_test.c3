module test::integration;

import std::rag::store;
import std::rag::vector;
import std::rag::pipeline;
import std::llm::types;
import std::assert;
import std::io;

fn void test_rag_flow() {
    VectorStoreProvider store = store::create_in_memory_store();
    
    Document doc1 = { 
        .id = "1", 
        .content = "C3 is a systems programming language.", 
        .embedding = { .values = [1.0f, 0.0f] } 
    };
    Document doc2 = { 
        .id = "2", 
        .content = "The sky is blue.", 
        .embedding = { .values = [0.0f, 1.0f] } 
    };
    
    store.add(&store, doc1);
    store.add(&store, doc2);

    Vector query_vec = { .values = [1.0f, 0.0f] };
    QueryResult[] results = store.query(&store, query_vec, 1);

    assert(results.len == 1);
    assert(results[0].doc.id == "1");
    assert(results[0].doc.content == "C3 is a systems programming language.");
}

fn int main(String[] args) {
    test_rag_flow();
    io::printn("Integration tests passed!");
    return 0;
}
