module std::llm::types;

enum Role {
    SYSTEM,
    USER,
    ASSISTANT,
    TOOL,
}

struct Tool {
    String name;
    String description;
    String parameters_json_schema;
}

struct ToolCall {
    String id;
    String tool_name;
    String arguments_json;
}

struct Message {
    Role role;
    String content;
    ToolCall[] tool_calls;
    String tool_call_id;
}

struct LLMConfig {
    String model;
    float temperature;
    int max_tokens;
    float top_p;
    float frequency_penalty;
    float presence_penalty;
    String api_key;
    String base_url;
}

struct Usage {
    int prompt_tokens;
    int completion_tokens;
    int total_tokens;
}

struct Completion {
    String text;
    Usage usage;
    ToolCall[] tool_calls;
}
