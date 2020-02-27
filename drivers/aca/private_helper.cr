module ACA; end

require "base62"

class ACA::PrivateHelper < ACAEngine::Driver
  def used_for_aca_testing
    logger.debug("this will be propagated to backoffice!")
    "you can delete this file"
  end
end
