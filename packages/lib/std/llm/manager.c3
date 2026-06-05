module std::llm::manager;

import std::llm::runtime;

struct ModelMetadata {
    String name;
    String path;
    int context_window;
    float parameter_count;
    String quantization;
}

struct ModelManager {
    ModelMetadata[] available_models;
    BackendProvider* active_backend;
    String active_model_name;
}

fn void manager_register_model(ModelManager* mgr, ModelMetadata meta) {
    mgr.available_models.push(meta);
}

fn bool manager_switch_model(ModelManager* mgr, String model_name) {
    for (ModelMetadata meta : mgr.available_models) {
        if (meta.name == model_name) {
            mgr.active_backend.unload_model(mgr.active_backend);
            bool success = mgr.active_backend.load_model(mgr.active_backend, meta.path);
            if (success) {
                mgr.active_model_name = model_name;
                return true;
            }
        }
    }
    return false;
}
