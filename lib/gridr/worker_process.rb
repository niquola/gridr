class Gridr::WorkerProcess
  attr :pid
  attr :command

  def initialize(command)
    @command = command
  end

  def start(arguments = nil)
    @pid = spawn(command)
  end

  def stop
    Process.kill("HUP", pid)
  end
end
