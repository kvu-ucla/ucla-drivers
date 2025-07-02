require "placeos-driver/spec"

DriverSpecs.mock_driver "Crestron::OccupancySensor" do
  # Check individual DeviceInfo endpoint
  should_send "/Device/DeviceInfo"
  responds %({
    "Device": {
      "DeviceInfo": {
        "BuildDate": "May 23 2022  (461338)",
        "Category": "Linux Device",
        "DeviceId": "@E-00107fec2d72",
        "DeviceVersion": "3.0000.00002",
        "Devicekey": "No SystemKey Server",
        "MacAddress": "00.10.7f.ec.2d.72",
        "Manufacturer": "Crestron",
        "Model": "CEN-ODT-C-POE",
        "Name": "Room1-Sensor",
        "PufVersion": "3.0000.00002",
        "RebootReason": "poweron",
        "SerialNumber": "2027NEJ00064",
        "Version": "2.1.0"
      }
    }
  })

  # check if room is occupied is false
  should_send "/Device/OccupancySensor/IsRoomOccupied"
  responds %({
      "Device": {
      "OccupancySensor": {
        "ForceOccupied": "GET Not Supported, Write Only Property",
        "ForceVacant": "GET Not Supported, Write Only Property",
        "IsGraceOccupancyDetected": false,
        "IsLedFlashEnabled": true,
        "IsRoomOccupied": false,
        "IsShortTimeoutEnabled": false,
        "IsSingleSensorDeterminingOccupancy": true,
        "IsSingleSensorDeterminingVacancy": true,
        "Pir": {
          "IsSensor1Enabled": true,
          "OccupiedSensitivity": "Low",
          "VacancySensitivity": "Low"
        },
        "RawStates": {
          "IsRawEnabled": false,
          "RawOccupancy": false,
          "RawPir": false,
          "RawUltrasonic": false
        },
        "TimeoutSeconds": 120,
        "Ultrasonic": {
          "IsSensor1Enabled": true,
          "IsSensor2Enabled": true,
          "OccupiedSensitivity": "Medium",
          "VacancySensitivity": "Medium"
        },
        "Version": "1.0.2"
      }
    }
  })

  # check initial pass for occupancy, name, and mac
  sleep 0.5
  status[:occupied].should be_false
  status[:name].should eq "Room1-Sensor"
  status[:mac].should eq "00107fec2d72"

  # check sensor details updated correctly
  resp = exec(:get_sensor_details).get.not_nil!
  resp.should eq({
    "status"    => "normal",
    "type"      => "presence",
    "value"     => 0.0,
    "last_seen" => resp["last_seen"].as_i64,
    "mac"       => "00107fec2d72",
    "name"      => "Room1-Sensor",
    "module_id" => "spec_runner",
    "binding"   => "presence",
    "location"  => "sensor",
  })

  transmit %({
      "Device": {
      "OccupancySensor": {
        "IsRoomOccupied": true
      }
    }
  })

  status[:occupied].should be_true
end
