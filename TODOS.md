# Development Roadmap: RigorStd LLM & RAG Framework

This document tracks the remaining gaps and planned enhancements to transition the library from a prototype skeleton to a production-ready framework.

## 🔴 High Priority: Core Infrastructure

- [ ] **Replace Mock HTTP**: Implement a real HTTP client using `libcurl` or native sockets in `std.net.http`.
- [ ] **Real JSON Parser**: Replace `std.json` mocks with a robust JSON serialization/deserialization library.
- [ ] **Error Handling**: Implement a comprehensive Error type for API failures, network timeouts, and parsing errors.
- [ ] **Async Runtime**: Introduce async/await or an event-loop mechanism to `std.llm.client` to support high-concurrency streaming.

## 🟠 Medium Priority: RAG & Vector Optimization

- [ ] **ANN Indexing**: Implement HNSW or IVF indices in `std.rag.store` to move from $O(N)$ to $O(\log N)$ search complexity.
- [ ] **External DB Integration**: Create providers for professional vector databases (e.g., Pinecone, Milvus, or ChromaDB).
- [ ] **Hybrid Search**: Implement a BM25 keyword search module and a fusion layer to combine it with vector results.
- [ ] **Cross-Encoder Reranking**: Add a `std.rag.rerank` module that uses a separate model to refine the top-K results.
- [ ] **Semantic Chunking**: Implement a chunker that splits text based on embedding similarity rather than just character counts.

## 🟡 Low Priority: Agentic & Playground Enhancements

- [ ] **Conversation Memory**: Implement a `std.llm.memory` module with strategies for sliding windows and recursive summarization.
- [ ] **Parallel Tool Execution**: Update `std.llm.agent` to execute non-dependent tool calls concurrently.
- [ ] **Tool Argument Validation**: Add JSON-Schema validation for tool inputs before execution.
- [ ] **Performance Metrics**: Implement actual measurement of Tokens Per Second (TPS) and Time to First Token (TTFT) in `std.llm.playground`.
- [ ] **TUI Interface**: Build a terminal-based playground UI for interactive model comparison.

## 📘 Examples & Documentation

- [ ] **Real-world Data Pipeline**: Create an example that parses a directory of Markdown files into a RAG store.
- [ ] **Multi-Agent Collaboration**: Example demonstrating two agents with different toolsets communicating to solve a task.
- [ ] **Chat-with-PDF**: Implement a full pipeline including PDF parsing and local RAG.
- [ ] **Integration Tests**: Expand test coverage to include real-world API responses (via recorded tapes).
