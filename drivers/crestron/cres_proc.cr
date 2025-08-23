require "placeos-driver"
require "json"

class Crestron::SIMPLInterface < PlaceOS::Driver
  descriptive_name "Crestron - SIMPL Interface"
  generic_name :CrestronInterface
  tcp_port 9001

  # Example setting (unused here but kept for completeness)
  default_settings({ normally_open: false })

  # Private, authoritative state cache
  @state : Bool? = nil

  def on_load
    queue.delay = 100.milliseconds
    on_update
  end

  def on_update
    publish_state
  end

  def connected
    transport.tokenizer = Tokenizer.new("\r\n")
    do_poll
    schedule.every(50.seconds) do
      logger.debug { "-- Polling Crestron Processor" }
      do_poll
    end
  end

  def do_poll
    query
  end

  def query
    send("query\r\n", name: "query")
  end

  def received(bytes : Bytes, task)
    line = String.new(bytes).rstrip("\r\n")
    data = JSON.parse(line)

    incoming = data["digital-io1"]
    if incoming.nil?
      logger.warn { "unrecognized boolean payload: #{line.inspect}" }
      task.try(&.abort)
      return
    end

    if incoming != @state
      @state = incoming
      publish_state
    end

    task.try(&.success)
  rescue error
    logger.warn(exception: error) { "failed to process inbound state" }
    task.try(&.abort)
  end

  def state : Bool?
    @state
  end

  private def publish_state
    val = @state
    return if val.nil?
    self[:state] = val.not_nil! 
  end

end
