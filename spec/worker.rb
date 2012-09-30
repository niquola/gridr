Signal.trap("HUP") { puts "Bay, bay.."; exit }
require 'drb'

class Worker
  def do(message)
    "Result: #{message}"
  end
end

DRb.start_service 'druby://localhost:59427', Worker.new

DRb.thread.join
