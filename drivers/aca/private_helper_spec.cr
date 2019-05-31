# Manual Compile:
# export COMPILE_DRIVER=drivers/aca/private_helper_spec.cr
# crystal build -o exec_name ./src/build.cr
EngineSpec.mock_driver "ACA::PrivateHelper" do
end
