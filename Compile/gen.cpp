#include <iostream>
#include <fstream>
#include <string>
#include <sstream>

using namespace std;

int main() {

    ifstream infile("../test.txt");

    if (!infile.is_open()) {
        cout << "Cannot open test.txt\n";
        return 1;
    }

    ofstream asmfile("program.s");

    if (!asmfile.is_open()) {
        cout << "Cannot create program.s\n";
        return 1;
    }

    // =========================
    // ASM HEADER
    // =========================
    asmfile << ".section .text\n";
    asmfile << ".globl _start\n\n";
    asmfile << "_start:\n\n";

    string expr;

    // =========================
    // READ EACH LINE = 1 EXPR
    // =========================
    while(getline(infile, expr)) {

        if(expr.empty())
            continue;

        int a, b;
        string op;

        stringstream ss(expr);

        if(!(ss >> a >> op >> b)) {
            cout << "Invalid expression: " << expr << endl;
            continue;
        }

        // =========================
        // LOAD VALUES
        // =========================
        asmfile << "    addi x1, x0, " << a << "\n";
        asmfile << "    addi x2, x0, " << b << "\n";

        // =========================
        // OPERATION
        // =========================
        if(op == "+") {
            asmfile << "    add x3, x1, x2\n";
        }
        else if(op == "-") {
            asmfile << "    sub x3, x1, x2\n";
        }
        else if(op == "&") {
            asmfile << "    and x3, x1, x2\n";
        }
        else if(op == "|") {
            asmfile << "    or x3, x1, x2\n";
        }
        else if(op == "^") {
            asmfile << "    xor x3, x1, x2\n";
        }
        else if(op == "<<") {
            asmfile << "    sll x3, x1, x2\n";
        }
        else if(op == ">>") {
            asmfile << "    srl x3, x1, x2\n";
        }
        else if(op == "<") {
            asmfile << "    slt x3, x1, x2\n";
        }
        else {
            cout << "Unsupported operator: " << op << endl;
            continue;
        }

        asmfile << "\n";
    }

    // =========================
    // INFINITE LOOP
    // =========================
    asmfile << "loop:\n";
    asmfile << "    beq x0, x0, loop\n";

    infile.close();
    asmfile.close();

    cout << "Generated program.s successfully!\n";

    return 0;
}