#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <iomanip>
#include <sstream>

using namespace std;

int main() {
    cout << "START CONVERT" << endl;

    ifstream infile("./Compile/raw.mem");
    if (!infile.is_open()) {
        cout << "Cannot open raw.mem" << endl;
        return 1;
    }
    cout << "file oke" << endl;

    vector<unsigned int> bytes_data;
    string token;

    while (infile >> token) {
        if (!token.empty() && token[0] == '@')
            continue;

        unsigned int val = 0;
        stringstream ss(token);
        ss >> hex >> val;
        bytes_data.push_back(val);
    }

    infile.close();
    cout << "Bytes count = " << bytes_data.size() << endl;

    if (bytes_data.size() < 4) {
        cout << "Not enough data" << endl;
        return 1;
    }

    // Build danh sách các 32-bit words
    vector<unsigned int> words;
    for (size_t i = 0; i + 3 < bytes_data.size(); i += 4) {
        unsigned int word = (bytes_data[i + 3] << 24)
                          | (bytes_data[i + 2] << 16)
                          | (bytes_data[i + 1] << 8)
                          |  bytes_data[i];
        words.push_back(word);
    }

    cout << "Word count = " << words.size() << endl;

    ofstream outfile("program.mem");
    if (!outfile.is_open()) {
        cout << "Cannot create program.mem" << endl;
        return 1;
    }

    // In ra: mỗi 3 instruction là 1 nhóm, cách nhau bằng dòng trống
    // Instruction cuối (00000063) không thuộc nhóm nào -> in riêng, không blank line sau
    int total = (int)words.size();

    // Số instruction trừ cái cuối
    int body_count = total - 1;  // bỏ 00000063 ở cuối
    int group_count = body_count / 3;

    for (int g = 0; g < group_count; g++) {
        for (int j = 0; j < 3; j++) {
            int idx = g * 3 + j;
            outfile << hex << setw(8) << setfill('0') << words[idx] << "\n";
        }
        outfile << "\n";  // blank line sau mỗi nhóm 3
    }

    // In phần dư (nếu body_count không chia hết cho 3)
    int remainder_start = group_count * 3;
    for (int i = remainder_start; i < body_count; i++) {
        outfile << hex << setw(8) << setfill('0') << words[i] << "\n";
    }
    if (remainder_start < body_count) {
        outfile << "\n";
    }

    // In instruction cuối cùng (00000063), không có blank line sau
    outfile << hex << setw(8) << setfill('0') << words[total - 1] << "\n";

    outfile.close();
    cout << "DONE -> program.mem generated" << endl;
    return 0;
}