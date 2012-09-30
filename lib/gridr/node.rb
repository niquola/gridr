module Gridr
  #Worker process supervisor
  class Node
    attr_accessor :number_of_workers
    attr_accessor :run_info
    attr_accessor :logger
    attr_accessor :working_directory
    attr_accessor :worker_commnad

    def on_run_request
      logger.info("Joining you...")
      logger.info("Prepare environment...")
      prepare
      logger.info("Start workers...")
      start_workers
    rescue Exception => e
      logger.error %(#{e.message}\n\t#{e.backtrace.join("\n\t")})
    end

    def on_complete
      logger.info("Stoping workers...")
      stop_workers
    end

    def workers
      @workers ||= []
    end

    def clear_workers
      @workers = []
    end

    private

    def shell_cmd!(cmd)
      Open3.popen3(cmd) do |_, out, err, thr|
        if thr.value.success?
          return out.read.chomp
        else
          raise "#{cmd} => #{err.read}"
        end
      end
    end

    def prepare
      Dir.chdir(working_directory) do
        out = shell_cmd!("git pull origin #{run_info.commit}")
        logger.info "GIT: #{out}"
        out = shell_cmd!("bundle install")
        logger.info "Bundler: updated!"
      end
    end

    def start_workers
      number_of_workers.times do
        worker = WorkerProcess.new(worker_commnad)
        worker.start
        workers<< worker
      end
    end

    def stop_workers
      workers.each do |worker|
        logger.info("Stoping worker #{worker.pid}")
        worker.stop
      end
      clear_workers
    end
  end
end
