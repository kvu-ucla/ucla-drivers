require "placeos-driver"

class Crestron::NvxSyncDetect < PlaceOS::Driver
  descriptive_name "Sync Detection for NVX Tx and Rx"
  generic_name :SyncDetect
  description %(Automation via sync detection)

  # default_settings({
  # })

  system/Users/khvu91/Documents/placeos-drivers/drivers/crestron/nvx_rx_spec.cr /Users/khvu91/Documents/placeos-drivers/drivers/crestron/nvx_rx.cr

  def on_load
    on_update
  end

  def on_update
    subscriptions.clear
    subscription = system.subscribe(:ZoomCSAPI_1, :BookingsListResult) do |_subscription, new_data|
      zoom_bookings_list = Array(JSON::Any).from_json(new_data)
      logger.debug { "Detected changed in Zoom Bookings List: : #{zoom_bookings_list.inspect}" }
      expose_bookings(zoom_bookings_list)
    end
    # ensure current booking is updated at the start of every minute
    # rand spreads the load placed on redis
    schedule.cron("* * * * *") do
      schedule.in(rand(1000).milliseconds) do
        if list = self[:bookings]?
          determine_current_booking(list.as_a)
          determine_next_booking(list.as_a)
        end
      end
    end
  end

end
