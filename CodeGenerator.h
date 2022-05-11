#ifndef CODEGENERATOR_H
#define CODEGENERATOR_H

#include <iostream>
#include <vector>
#include <map>
#include <string>

#include <llvm/IR/BasicBlock.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/IR/CallingConv.h>
#include <llvm/IR/IRPrintingPasses.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/GlobalVariable.h>
#include <llvm/IRReader/IRReader.h>
#include <llvm/IR/ValueSymbolTable.h>
#include <llvm/ExecutionEngine/MCJIT.h>
#include <llvm/ExecutionEngine/Interpreter.h>
#include <llvm/ExecutionEngine/GenericValue.h>
#include <llvm/ExecutionEngine/SectionMemoryManager.h>
#include <llvm/Support/SourceMgr.h>
#include <llvm/Support/ManagedStatic.h>
#include <llvm/Support/TargetSelect.h>
#include <llvm/Support/MemoryBuffer.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Support/DynamicLibrary.h>
#include <llvm/Target/TargetMachine.h>
#include "ast.h"

static llvm::LLVMContext TheContext;
static llvm::IRBuilder<> TheBuilder(TheContext);

class CodeGenerator 
{
public:
    std::unique_ptr<llvm::Module> TheModule;
    unsigned int TheAddrSpace;
    llvm::Function *mainFunction;
    std::vector<llvm::Function*> funcStack;
    llvm::BasicBlock* labelBlock[10000];
    std::map<std::string, AstArrayType*> arrayMap;
    llvm::Function *printf, *scanf;
    
    CodeGenerator()
    {
        TheModule = std::unique_ptr<llvm::Module>(new llvm::Module("main", TheContext));
        TheAddrSpace = TheModule->getDataLayout().getAllocaAddrSpace();
    }
    
    void generate(Program& astRoot);
    llvm::GenericValue run();
    llvm::ExecutionEngine* genExeEngine();

    llvm::Value* findValue(const std::string & name);
    llvm::Function* createPrintf();
    llvm::Function* createScanf();

    llvm::Function* getCurFunction()
    {
        return funcStack.back();
    }
    void pushFunction(llvm::Function* func)
    {
        funcStack.push_back(func);
    }
    void popFunction()
    {
        funcStack.pop_back();
    }
};

#endif
