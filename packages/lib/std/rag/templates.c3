module std::rag::templates;

import std::string;

struct PromptTemplate {
    String template_text;
}

fn String render(PromptTemplate tmpl, Map(String, String) variables) {
    String result = tmpl.template_text;
    
    for (String key, String val : variables) {
        String placeholder = "{" + key + "}";
        result = result.replace(placeholder, val);
    }
    
    return result;
}
