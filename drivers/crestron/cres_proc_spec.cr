require "placeos-driver/spec"

DriverSpecs.mock_driver "Crestron::SIMPLInterface" do
transmit(%({"digital-io1": true}\r\n))
status[:state].should eq(true)

transmit(%({"digital-io1": false}\r\n))
status[:state].should eq(false)
end
