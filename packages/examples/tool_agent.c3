module examples::tool_agent;

import std::llm::agent;
import std::llm::types;
import std::io;

// A local tool: Calculator
fn String add_numbers(String args) {
    io::printn("[Tool] Calculating sum for: " + args);
    return "The sum is 42"; // Simplified for example
}

// A local tool: System Info
fn String get_sys_info(String args) {
    io::printn("[Tool] Fetching system info...");
    return "OS: Linux, CPU: x86_64, Memory: 32GB";
}

fn int main(String[] args) {
    Agent agent = {
        .config = { .model = "gpt-4-tools", .base_url = "http://localhost:11434" },
    };

    // Register tools
    agent::agent_add_tool(&agent, "calculator", add_numbers);
    agent::agent_add_tool(&agent, "sys_info", get_sys_info);

    Message[] history;
    history.push(Message { .role = Role.USER, .content = "What is the system info and 20+22?" });

    io::printn("Agent is thinking...");
    String final_answer = agent::agent_chat(&agent, history);
    
    io::printn("\nFinal Agent Response: " + final_answer);

    return 0;
}
