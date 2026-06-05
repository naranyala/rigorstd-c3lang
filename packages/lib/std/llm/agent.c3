module std::llm::agent;

import std::llm::client;
import std::llm::types;

type ToolFn = fn(String args) -> String;

struct Agent {
    LLMConfig config;
    Map(String, ToolFn) tool_registry;
}

fn void agent_add_tool(Agent* agent, String name, ToolFn fn) {
    agent.tool_registry.set(name, fn);
}

fn String agent_chat(Agent* agent, Message[] history) {
    bool loop = true;
    int max_iterations = 5;
    int iterations = 0;

    while (loop && iterations < max_iterations) {
        iterations++;
        
        Completion res = client::complete(agent.config, history);
        
        if (res.tool_calls.len == 0) {
            return res.text;
        }

        for (ToolCall call : res.tool_calls) {
            ToolFn tool_fn = agent.tool_registry.get(call.tool_name);
            
            String tool_result;
            if (tool_fn != null) {
                tool_result = tool_fn(call.arguments_json);
            } else {
                tool_result = "Error: Tool not found";
            }

            history.push(Message {
                .role = Role.TOOL,
                .content = tool_result,
                .tool_call_id = call.id,
            });
        }
        
        history.push(Message {
            .role = Role.ASSISTANT,
            .content = res.text,
            .tool_calls = res.tool_calls,
        });
    }

    return "Error: Max iterations reached without final answer.";
}
