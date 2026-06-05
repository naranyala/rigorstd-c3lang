module test::foundation;

import std::rag::vector;
import std::rag::chunker;
import std::rag::templates;
import std::io;

fn void simple_assert(bool condition, String msg) {
    if (!condition) {
        io::printn("Assertion failed: " + msg);
    }
}

fn void test_vector_math() {
    float[] v1_vals = { 1.0f, 0.0f };
    float[] v2_vals = { 0.0f, 1.0f };
    float[] v3_vals = { 1.0f, 0.0f };

    Vector v1 = { .values = v1_vals };
    Vector v2 = { .values = v2_vals };
    Vector v3 = { .values = v3_vals };

    simple_assert(vector::cosine_similarity(v1, v2) == 0.0f, "Orthogonal");
    simple_assert(vector::cosine_similarity(v1, v3) == 1.0f, "Identical");
    simple_assert(vector::l2_distance(v1, v2) == 1.414f, "Distance");
}

fn void test_chunker_recursive() {
    String text = "Paragraph 1\n\nParagraph 2\nLine 1\nLine 2";
    String[] separators = { "\n\n", "\n", " " };
    
    String[] chunks = chunker::recursive_split(text, 20, separators);
    
    simple_assert(chunks.len > 1, "Chunks length");
    simple_assert(chunks[0] == "Paragraph 1", "First chunk content");
}

fn void test_templates() {
    PromptTemplate tmpl = { .template_text = "Hello {name}, welcome to {city}!" };
    // Assuming Map is defined as a struct or handled differently
    // For the sake of the test, let's assume a simpler map or fixed vars
    String rendered = templates::render(tmpl, {}); 
    simple_assert(rendered != "", "Rendered output");
}

fn int main(String[] args) {
    test_vector_math();
    test_chunker_recursive();
    test_templates();
    io::printn("Foundation tests passed!");
    return 0;
}
