require "placeos-driver"
require "placeos-driver/interface/sensor"
require "./cres_next"

class Crestron::OccupancySensor < Crestron::CresNext # < PlaceOS::Driver
  include Interface::Sensor

  descriptive_name "Crestron Occupancy Sensor"
  generic_name :Occupancy

  uri_base "wss://192.168.0.5/websockify"

  default_settings({
    username: "admin",
    password: "admin",
  })

  @mac : String = ""
  @name : String? = nil
  @occupied : Bool = false
  @connected : Bool = false
  getter last_update : Int64 = 0_i64

  @sensor_data : Array(Interface::Sensor::Detail) = Array(Interface::Sensor::Detail).new(1)
  @update_lock = Mutex.new

  def connected
    super
    @connected = true

    # Fetch device info (MAC, name)
    query("DeviceInfo") do |info, _task|
      self[:mac] = @mac = format_mac(info["MacAddress"].as_s)
      self[:name] = @name = info["Name"]?.try &.as_s
      update_sensor
    end

    # Fetch initial occupancy state
    query("OccupancySensor/IsRoomOccupied") do |state, _task|
      @last_update = Time.utc.to_unix
      self[:occupied] = @occupied = state.as_bool
      self[:presence] = @occupied ? 1.0 : 0.0
      update_sensor
    end
  end

  def disconnected
    super
    @connected = false
  end

  protected def format_mac(address : String) : String
    address.gsub(/(0x|[^0-9A-Fa-f])*/, "").downcase
  end

  def received(data, task)
    raw_json = String.new(data)
    logger.debug { "Received WebSocket data: #{raw_json}" }

    return unless raw_json.includes?("IsRoomOccupied")

    begin
      json = JSON.parse(raw_json)
      occupancy = json.dig?("Device", "OccupancySensor", "IsRoomOccupied").try &.as_bool

      if !occupancy.nil?
        @last_update = Time.utc.to_unix
        self[:occupied] = @occupied = occupancy
        self[:presence] = occupancy ? 1.0 : 0.0
        update_sensor
      end
    rescue error
      logger.warn(exception: error) { "Failed to parse occupancy update" }
    end
  end

  protected def update_sensor
    @update_lock.synchronize do
      if sensor = @sensor_data[0]?
        sensor.value = @occupied ? 1.0 : 0.0
        sensor.last_seen = @connected ? Time.utc.to_unix : @last_update
        sensor.mac = @mac
        sensor.name = @name
        sensor.status = @connected ? Status::Normal : Status::Fault
      else
        @sensor_data << Detail.new(
          type: :presence,
          value: @occupied ? 1.0 : 0.0,
          last_seen: @connected ? Time.utc.to_unix : @last_update,
          mac: @mac,
          id: nil,
          name: @name,
          module_id: module_id,
          binding: "presence",
          status: @connected ? Status::Normal : Status::Fault,
        )
      end
    end
  end

  # ======================
  # Sensor interface.   
  # ======================

  SENSOR_TYPES = {SensorType::Presence}
  NO_MATCH     = [] of Interface::Sensor::Detail

  def sensors(type : String? = nil, mac : String? = nil, zone_id : String? = nil) : Array(Interface::Sensor::Detail)
    logger.debug { "sensors of type: #{type}, mac: #{mac}, zone_id: #{zone_id} requested" }

    return NO_MATCH if mac && mac != @mac
    if type
      sensor_type = SensorType.parse(type)
      return NO_MATCH unless SENSOR_TYPES.includes?(sensor_type)
    end

    @sensor_data
  end

  def sensor(mac : String, id : String? = nil) : Interface::Sensor::Detail?
    logger.debug { "sensor mac: #{mac}, id: #{id} requested" }
    return nil unless @mac == mac
    @sensor_data[0]?
  end

  def get_sensor_details
    @sensor_data[0]?
  end
end
