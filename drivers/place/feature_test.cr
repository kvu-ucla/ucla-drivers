module Place; end

class Place::AcidTest < PlaceOS::Driver
  descriptive_name "PlaceOS Acid Test"
  generic_name :Testing

  default_settings({
    name: "Acid test",
  })

  accessor helper : Helper
  bind :channel_data, :channel_data_changed

  @name : String = "Acid test"
  @ready : Int32 = 0

  def on_load
    subscribe(:timer_count) do |_subscription, new_value|
      # values are always raw JSON strings
      sub_data(new_value)
    end

    monitor(:acid_test_data) do |_subscription, new_value|
      # values are always raw strings
      channel_data(new_value)
    end

    system.load_complete do |_subscription, _new_value|
      @ready = @ready &+ 1
      self[:ready_called] = @ready
      nil
    end

    on_update
  end

  def on_update
    @name = setting?(String, :name) || "Acid test"
    self[:name] = @name
  end

  # Calling remote functions
  def echo(message : String)
    result = helper.echo(message).get
    result
  end

  # Subscription monitoring
  private def sub_data(incoming)
    logger.info "Received on subscription: #{incoming}"
  end

  private def channel_data_changed(subscription, new_value)
    logger.info "Received on channel data subscription: #{new_value}"
  end

  # Channel monitoring
  private def channel_data(incoming)
    logger.info "Received on channel: #{incoming}"
    self[:channel_data] = incoming
  end

  def send_to_channel(data : String)
    publish(:acid_test_data, data)
  end

  # Tests for security
  @[Security(Level::Administrator)]
  def perform_admin_task(name : String | Int32)
    logger.fatal "Admin level function called with #{name}"
  end

  @[Security(Level::Support)]
  def perform_support_task(name : String | Int32)
    logger.error "Support level function called with #{name}"
  end

  # Timer tests
  @timer_count = 0
  @timer_sched : PlaceOS::Driver::Proxy::Scheduler::TaskWrapper? = nil

  def start_timer(period : Int32)
    @timer_sched = schedule.every(period.seconds) { timer_fired! }
  end

  def stop_timer
    @timer_sched.try &.cancel
    @timer_sched = nil
  end

  def timer_fired!
    @timer_count += 1
    logger.warn "Timer fired #{@timer_count}"
    self[:timer_count] = @timer_count
  end
end
