class Worker
  attr :bus

  def initialize(arguments)
  end

  def result(message)
  end

  def on_task(task)
  end
end

class SpecsBus
  def initialize(attrs)
  end
end

class SpecWorker < Worker
  def initialize(bas,options)
    @bas = bas
    @options = options
  end

  def start
    bas.next_task do |task|
      run_spec(task.spec)
    end
  end

  def example_failed(example)
    bus.success(example)
  end

  def example_failed(example)
    bus.failed(example)
  end
end
