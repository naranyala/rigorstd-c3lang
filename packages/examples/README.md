# LLM & RAG Stdlib Examples Guide

This directory contains examples demonstrating the capabilities of the C3 LLM/RAG standard library.

## 🗺️ Feature Map

| Feature | Example | Stdlib Modules Used | Description |
| :--- | :--- | :--- | :--- |
| **Basic Chat** | `basic_chat.c3` | `std.llm.client`, `std.llm.types` | Basic sync/async communication with an LLM. |
| **Knowledge RAG** | `simple_rag.c3` | `std.rag.chunker`, `std.rag.store`, `std.rag.pipeline` | Traditional RAG: Chunk $\rightarrow$ Store $\rightarrow$ Retrieve $\rightarrow$ Generate. |
| **Tool Agents** | `tool_agent.c3` | `std.llm.agent`, `std.llm.types` | Building agents that can call local C3 functions as tools. |
| **Runtime Bench** | `playground_bench.c3`| `std.llm.runtime`, `std.llm.manager`, `std.llm.playground`| Comparing different LLM backends and models for latency/quality. |
| **Full Orchestration**| `comprehensive_agent.c3`| **All Modules** | A production-like agent that uses RAG as a tool and manages models via a runtime manager. |

## 🚀 How to Run

1. Ensure a local LLM provider (like Ollama) is running at `http://localhost:11434`.
2. Compile the example:
   ```bash
   c3c compile packages/examples/comprehensive_agent.c3
   ```
3. Run the binary:
   ```bash
   ./build/comprehensive_agent
   ```

## 🛠️ Implementation Details
The `comprehensive_agent.c3` example demonstrates the most advanced pattern:
- **Model Management**: Dynamically switches between models using the `ModelManager`.
- **RAG-as-a-Tool**: Instead of a static pipeline, the RAG system is encapsulated as a tool (`search_knowledge_base`) that the agent invokes only when necessary.
- **Hybrid Intelligence**: Combines external knowledge (RAG) with deterministic logic (Calculator tool) to answer complex queries.
