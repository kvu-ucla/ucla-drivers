require "placeos-driver"
require "./pc300_parser"

class Crestron::PCxxxPwrController < PlaceOS::Driver
  # Discovery Information
  descriptive_name "PC300 Power Controller"
  generic_name :PC300
  tcp_port 22

  default_settings({
    ssh: {
      username: :root,
      password: :password,
    },
  })

  @pdu_status : JSON::Any
  @outlet_states : Hash(Int32, Bool)

  #start monitoring on all outlets, and get current state of them
  def on_load
    get_outlet
    start_monitor
  end

  def run(command : String, wait : Bool = true)
    logger.debug { "PC300 CLI Command:\n#{command}" }
    send "#{command}\n", wait: wait
  end

  ##get current state of all outlets
  def get_outlet
    run("outlet")
  end

  #start monitoring on all outlets
  def start_monitor
    run("monitor all")
  end

  #power on or off specified outlet
  def power_outlet(outlet : Int32, state : Bool)
    state_str = state ? "on" : "off"
    run "outlet #{outlet} #{state_str}"
  end

  #power on or off specified outlet
  def power_all_outlet(outlet : Int32, state : Bool)
    state_str = state ? "on" : "off"
    run "outlet all #{state_str}"
  end

  def received(data, task)
    data = String.new(data)
    logger.debug { "PC300 Response:\n#{data}" }

    #check response for outlet structure
    if data.includes?("Outlets:")
      @outlet_states = PC300Parser.parse_outlet_states(data)
    #check response for monitor structure
    elsif data.includes?("# TOTAL:")
      @pdu_status = PC300Parser.parse_monitor_data(data)
    else
    
    end
  end
end
