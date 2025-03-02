#ifndef MODELEXECUTOR_H
#define MODELEXECUTOR_H

#include <string>

class QPixmap;

#undef slots
#include <tvm/runtime/module.h>
#define slots Q_SLOTS

enum class DeviceType {
    CPU,
    OpenCL,
    Metal
};

class ModelExecutor
{
public:
    ModelExecutor();
    void loadModel(std::string modelName);
    void run(const tvm::runtime::NDArray& input, tvm::runtime::NDArray& output, DeviceType devType = DeviceType::CPU);
private:
    tvm::runtime::Module m_module;
    bool m_modelLoaded = false;
};

#endif // MODELEXECUTOR_H
