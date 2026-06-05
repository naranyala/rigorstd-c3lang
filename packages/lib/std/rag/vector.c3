module std::rag::vector;

import std::math;

struct Vector {
    float[] values;
}

fn float dot_product(Vector v1, Vector v2) {
    if (v1.values.len != v2.values.len) {
        return 0.0f;
    }

    float sum = 0.0f;
    for (int i = 0; i < v1.values.len; i++) {
        sum += v1.values[i] * v2.values[i];
    }
    return sum;
}

fn float magnitude(Vector v) {
    float sum = 0.0f;
    for (int i = 0; i < v.values.len; i++) {
        sum += v.values[i] * v.values[i];
    }
    return math::sqrt(sum);
}

fn float cosine_similarity(Vector v1, Vector v2) {
    float dot = dot_product(v1, v2);
    float mag1 = magnitude(v1);
    float mag2 = magnitude(v2);

    if (mag1 == 0 || mag2 == 0) return 0.0f;
    return dot / (mag1 * mag2);
}

fn float l2_distance(Vector v1, Vector v2) {
    float sum = 0.0f;
    for (int i = 0; i < v1.values.len; i++) {
        float diff = v1.values[i] - v2.values[i];
        sum += diff * diff;
    }
    return math::sqrt(sum);
}
