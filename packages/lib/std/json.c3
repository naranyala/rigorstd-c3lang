module std::json;

fn String serialize(any obj) {
    return "{}";
}

fn bool deserialize(String json, any target) {
    return true;
}
