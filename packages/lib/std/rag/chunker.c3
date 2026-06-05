module std::rag::chunker;

fn String[] chunk_by_size(String text, int size, int overlap) {
    String[] chunks;
    int start = 0;
    int text_len = text.len;

    while (start < text_len) {
        int end = start + size;
        if (end > text_len) end = text_len;

        chunks.push(text.slice(start, end));

        start += (size - overlap);
        if (start >= text_len || size <= overlap) break;
    }

    return chunks;
}

fn String[] recursive_split(String text, int max_chunk_size, String[] separators) {
    if (text.len <= max_chunk_size) {
        return [text];
    }

    for (int i = 0; i < separators.len; i++) {
        String sep = separators[i];
        String[] parts = text.split(sep);

        if (parts.len > 1) {
            String[] final_chunks;
            String current_chunk;

            for (String part : parts) {
                if (current_chunk.len + part.len + sep.len <= max_chunk_size) {
                    current_chunk += (current_chunk.len > 0) ? sep + part : part;
                } else {
                    if (current_chunk.len > 0) final_chunks.push(current_chunk);
                    current_chunk = part;
                    if (current_chunk.len > max_chunk_size) {
                        String[] sub_chunks = recursive_split(current_chunk, max_chunk_size, separators[i+1..]);
                        final_chunks.push_all(sub_chunks);
                        current_chunk = "";
                    }
                }
            }
            if (current_chunk.len > 0) final_chunks.push(current_chunk);
            return final_chunks;
        }
    }

    return chunk_by_size(text, max_chunk_size, 0);
}

fn String[] chunk_by_paragraph(String text) {
    return text.split("\n\n");
}
