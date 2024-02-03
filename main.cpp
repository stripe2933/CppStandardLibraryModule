#include <cerrno>

import std;
import std.compat;

int main() {
    std::ifstream file { std::source_location::current().file_name() };
    if (!file) {
        std::cerr << "Failed to open file: " << strerror(errno) << '\n';
        std::abort();
    }

    // Read file and store into buffer.
    file.seekg(0, std::ios::end);
    const std::size_t fileSize = file.tellg();
    std::string buffer(fileSize, ' ');
    file.seekg(0);
    file.read(buffer.data(), fileSize);

    // Print buffer.
    std::println("{}", buffer);
}
