#include "ast.h"
#include "CodeGenerator.h"

using namespace std;

void CodeGenerator::generate(Program& astRoot)
{
    cout << "[INFO] IR generation begin..." << endl;
    astRoot.codeGen(*this);
    cout << "[INFO] IR generation finished." << endl;
    TheModule->print(llvm::errs(), nullptr);
}

llvm::GenericValue CodeGenerator::run()
{
    cout << "[INFO] IR running begin..." << endl;
    llvm::ExecutionEngine* exe_engine = genExeEngine();
    vector<llvm::GenericValue> args;
    llvm::GenericValue result = exe_engine->runFunction(mainFunction, args);
    cout << "[INFO] IR running finished." << endl;
    return result;
}

llvm::ExecutionEngine* CodeGenerator::genExeEngine()
{
    std::string errStr;
    auto RTDyldMM = unique_ptr<llvm::SectionMemoryManager>(new llvm::SectionMemoryManager());
    llvm::ExecutionEngine* exe_engine = llvm::EngineBuilder(std::move(TheModule))
        .setEngineKind(llvm::EngineKind::JIT)
        .setErrorStr(&errStr)
        .setVerifyModules(true)
        .setMCJITMemoryManager(move(RTDyldMM))
        .setOptLevel(llvm::CodeGenOpt::Default)
        .create();
    if (exe_engine)
    {
        exe_engine->addModule(std::move(TheModule));
        exe_engine->finalizeObject();
        return exe_engine;
    }
    else
    {
        throw std::logic_error("[ERROR]Create Engine Error: " + errStr);
    }
    
}

llvm::Value* CodeGenerator::findValue(const std::string & name)
{
    llvm::Value * result = nullptr;
    std::vector<llvm::Function*>::iterator iter = funcStack.rbegin();
    while(iter != funcStack.rend())
    {
        if ((result = (*iter)->getValueSymbolTable()->lookup(name)) != nullptr)
        {
            std::cout << "Find " << name << " in " << std::string((*iter)->getName()) << std::endl;
            return result;
        }
        else
        {
            std::cout << "Not Find " << name << " in " << std::string((*iter)->getName()) << std::endl;
        }
        iter++;
    }
    if ((result = TheModule->getGlobalVariable(name)) != nullptr)
    {
        std::cout << "Find " << name << " in global" << std::endl;
        return result;
    }
    else
    {
        throw std::logic_error("[ERROR]Undeclared variable: " + name);
    }
}

llvm::Function* CodeGenerator::createPrintf()
{
    std::vector<llvm::Type*> arg_types;
    arg_types.push_back(TheBuilder.getInt8PtrTy());
    auto printf_type = llvm::FunctionType::get(TheBuilder.getInt32Ty(), llvm::makeArrayRef(arg_types), true);
    auto func = llvm::Function::Create(printf_type, llvm::Function::ExternalLinkage, llvm::Twine("printf"), TheModule.get());
    func->setCallingConv(llvm::CallingConv::C);
    return func;
}
    
llvm::Function* CodeGenerator::createScanf()
{
    auto scanf_type = llvm::FunctionType::get(TheBuilder.getInt32Ty(), true);
    auto func = llvm::Function::Create(scanf_type, llvm::Function::ExternalLinkage, llvm::Twine("scanf"), TheModule.get());
    func->setCallingConv(llvm::CallingConv::C);
    return func;
}