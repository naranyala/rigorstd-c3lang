# RigorStd C3 LLM & RAG Framework

RigorStd is a high-performance orchestration layer for Large Language Models (LLMs) and Retrieval-Augmented Generation (RAG) systems, implemented in the C3 programming language. This library provides a modular backbone for building everything from simple chat interfaces to complex, tool-using autonomous agents.

## Architecture Overview

The framework is divided into two primary namespaces: `std.llm` and `std.rag`.

### 1. LLM Orchestration (std.llm)

This layer handles the communication with model runtimes and the high-level logic of agentic behavior.

- **std.llm.runtime**: Provides the `BackendProvider` interface. This allows the library to remain agnostic to the underlying engine, supporting local runtimes like Ollama or llama.cpp as well as remote APIs.
- **std.llm.manager**: Manages model lifecycles, including metadata tracking and dynamic model switching to optimize system resources (VRAM).
- **std.llm.agent**: Implements the agentic loop. It allows the registration of local C3 functions as tools, enabling the LLM to interact with the host system to perform calculations or fetch real-time data.
- **std.llm.client**: Handles the low-level HTTP and JSON communication, supporting both synchronous completions and asynchronous token streaming.
- **std.llm.playground**: An orchestration tool for model benchmarking and A/B testing, enabling comparisons of latency and output quality across different backends.
- **std.llm.types**: Defines the core data structures used across the framework, including Messages, ToolCalls, and Completion objects.

### 2. RAG Infrastructure (std.rag)

This layer provides the machinery for augmenting LLM prompts with external knowledge.

- **std.rag.pipeline**: The primary coordinator that implements the retrieve-rerank-generate workflow.
- **std.rag.store**: Defines the `VectorStoreProvider` abstraction. It includes an `InMemoryStore` implementation for rapid prototyping and is designed to be extended to support professional vector databases.
- **std.rag.chunker**: Implements advanced text splitting, including recursive character splitting to preserve semantic coherence across chunks.
- **std.rag.vector**: Provides the mathematical foundation for similarity search, including Cosine Similarity and L2 Distance.
- **std.rag.templates**: A dynamic prompt engineering system that decouples prompt structures from application logic via variable injection.

## Key Features

- **Backend Agnosticism**: Swap between different LLM engines without changing application code.
- **Agentic Tool Use**: First-class support for function calling and autonomous tool-execution loops.
- **Semantic RAG**: Advanced chunking and reranking capabilities to minimize hallucinations.
- **Model Benchmarking**: Built-in playground utilities to measure latency and compare model performance.
- **Streaming Support**: Native callbacks for real-time token generation.

## Project Structure

```text
packages/
├── lib/
│   └── std/
│       ├── json.c3             # JSON serialization
│       ├── net/
│       │   └── http.c3         # HTTP Client
│       ├── llm/
│       │   ├── agent.c3        # Agentic Loop
│       │   ├── client.c3       # API Client
│       │   ├── manager.c3      # Model Management
│       │   ├── playground.c3   # Benchmarking
│       │   ├── runtime.c3      # Backend Interface
│       │   └── types.c3        # Core Types
│       └── rag/
│           ├── chunker.c3      # Text Splitting
│           ├── pipeline.c3     # RAG Orchestration
│           ├── store.c3        # Vector Storage
│           ├── templates.c3    # Prompt Templates
│           └── vector.c3       # Similarity Math
├── examples/                   # Implementation demonstrations
└── test/                       # Unit and Integration tests
```

## Getting Started

### Prerequisites
- C3 Compiler
- A local LLM provider (e.g., Ollama running at http://localhost:11434)

### Running Examples
Navigate to the examples directory and compile the desired scenario:

```bash
c3c compile packages/examples/comprehensive_agent.c3
./build/comprehensive_agent
```

## Testing

The library employs a tiered testing strategy:
- **Foundation Tests**: Verifies vector mathematics and chunking logic.
- **Integration Tests**: Validates the RAG pipeline and storage interactions.
- **Orchestration Tests**: Uses mock backends to verify agentic loops and runtime switching.

Run tests using:
```bash
c3c test packages/test/
```

## License
Refer to packages/LICENSE for licensing details.
