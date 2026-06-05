module std::rag::store;

import std::rag::vector;

struct Document {
    String id;
    Vector embedding;
    String content;
    String metadata;
}

struct QueryResult {
    Document doc;
    float score;
}

struct VectorStoreProvider {
    fn void add(VectorStoreProvider* self, Document doc);
    fn QueryResult[] query(VectorStoreProvider* self, Vector query_vec, int top_k);
}

struct InMemoryStore {
    VectorStoreProvider provider;
    Document[] docs;
}

fn void in_memory_add(VectorStoreProvider* self, Document doc) {
    InMemoryStore* store = (InMemoryStore*)self;
    store.docs.push(doc);
}

fn QueryResult[] in_memory_query(VectorStoreProvider* self, Vector query_vec, int top_k) {
    InMemoryStore* store = (InMemoryStore*)self;
    QueryResult[] results;

    for (int i = 0; i < store.docs.len; i++) {
        float sim = vector::cosine_similarity(query_vec, store.docs[i].embedding);
        results.push(QueryResult {
            .doc = store.docs[i],
            .score = sim,
        });
    }
    return results.slice(0, top_k);
}

fn VectorStoreProvider create_in_memory_store() {
    InMemoryStore* store = alloc(InMemoryStore);
    store.provider = {
        .add = in_memory_add,
        .query = in_memory_query,
    };
    return store.provider;
}
