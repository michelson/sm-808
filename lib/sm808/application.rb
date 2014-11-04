module Sm808
  class Application

    attr_accessor :name, :logger, :base_dir, :pid_file, :socket
    attr_accessor :pids_dir, :log_file, :sockets_dir, :mutex

    MAX_ATTEMPTS = 3
    TIMEOUT      = 30

    def initialize(name, options = {})
      self.name        = name
      @foreground      = options[:foreground]
      self.base_dir    = options[:base_dir] || ENV['SM808_BASE_DIR'] || "/tmp/#{self.name}"
      self.logger      = LOGGER
      self.pid_file    = File.join(self.base_dir, 'pids', self.name + ".pid")
      self.pids_dir    = File.join(self.base_dir, 'pids', self.name)
      self.sockets_dir = File.join(self.base_dir, 'socks')
      @mutex           = Mutex.new
      self.setup_dir_structure
      self.setup_pids_dir
    end

    def start_server
      begin
        ::Process.setpgid(0, 0)
      rescue Errno::EPERM
      end
      puts "STARTING SM-808 SERVER"
      daemonize unless foreground?

      $0 = "Sm808: #{self.name}"

      self.write_pid_file
      self.socket = server(self.base_dir, self.name)
      self.start_listener

      self.run
    end

    def setup_signal_traps
      terminator = Proc.new do
        puts "Terminating..."
        cleanup
        @running = false
      end

      Signal.trap("TERM", &terminator)
      Signal.trap("INT", &terminator)

      Signal.trap("HUP") do
        self.logger.reopen if self.logger
      end
    end

    def cleanup
      begin
        #delete_if_exists(self.socket.path) if self.socket
      rescue IOError
      end
      #delete_if_exists(self.pid_file)
    end

    def foreground?
      !!@foreground
    end

    def mutex(&b)
      @mutex.synchronize(&b)
    end

    def client(&block)
      UNIXSocket.open(socket_path(self.base_dir, self.name), &block)
    end

    def client_command(command)
      res = nil
      MAX_ATTEMPTS.times do |current_attempt|
        begin
          client do |socket|
            Timeout.timeout(TIMEOUT) do
              logger.info "cmd received: #{command}"
              socket.puts command
              res = Marshal.load(socket.read)
              puts res
            end
          end
          break
        rescue EOFError, Timeout::Error
          if current_attempt == MAX_ATTEMPTS - 1
            abort("Socket Timeout: Server may not be responding")
          end
          puts "Retry #{current_attempt + 1} of #{MAX_ATTEMPTS}"
        end
      end
      res
    end

    def start_listener
      @listener_thread.kill if @listener_thread
      @listener_thread = Thread.new do
        loop do
          begin
            client = self.socket.accept
            client.close_on_exec = true  if client.respond_to?(:close_on_exec=)
            command, *args = client.readline.strip.split(":")
            response = begin
              mutex { self.send(command, *args) }
            rescue Exception => e
              e
            end
            client.write(Marshal.dump(response))
          rescue StandardError => e
            logger.err("Got exception in cmd listener: %s `%s`" % [e.class.name, e.message])
            e.backtrace.each {|l| logger.error(l)}
          ensure
            begin
              client.close
            rescue IOError
              # closed stream
            end
          end
        end
      end
    end

    def server(base_dir, name)
      socket_path = self.socket_path(base_dir, name)
      begin
        UNIXServer.open(socket_path)
      rescue Errno::EADDRINUSE
        # if sock file has been created.  test to see if there is a server
        begin
          UNIXSocket.open(socket_path)
        rescue Errno::ECONNREFUSED
          File.delete(socket_path)
          return UNIXServer.open(socket_path)
        else
          logger.err("Server is already running!")
          exit(7)
        end
      end
    end

    def run
      @running = true # set to false by signal trap
      while @running
        mutex do
          logger.info "running"
        end
        sleep 1
      end
    end

    def setup_dir_structure
      [sockets_dir, pids_dir].each do |dir|
        FileUtils.mkdir_p(dir) unless File.exists?(dir)
      end
    end

    def setup_pids_dir
      FileUtils.chmod(0777, self.pids_dir)
    end

    def quit
      pid = get_pid
      if self.pid_alive?(pid)
        Process.kill("TERM", pid)
        puts "QUIT SM808 WHIT PID [#{pid}]"
      else
        puts "SMS808[#{pid}] not running"
      end
    end

    def hello
      "HELLO WORLD"
    end

    def create_song(title, bpm=120)
      @song = Song.new(title: title, bpm: bpm, logger: logger)
      @song.title
    end

    def add_tracks(name, grid)
      grid = JSON.parse(grid).is_a?(Array) ? JSON.parse(grid) : [0]
      @song.add_pattern(grid, name)
    end

    def info
      @song.info
    end

    def play
      @playing_thread = Thread.new do
        @song.play
      end
      "STARTING SONG!"
    end

    def stop
      @song.stop
    end


protected

    def pid_alive?(pid)
      logger.info "Try to quit #{pid}"
      begin
        ::Process.kill(0, pid)
        true
      rescue Errno::EPERM # no permission, but it is definitely alive
        true
      rescue Errno::ESRCH
        false
      end
    end

    def get_pid
      File.exists?(pid_file) && File.read(pid_file).to_i
    end

    def socket_path(base_dir, name)
      File.join(base_dir, 'socks', name + ".sock")
    end

    def write_pid_file
      File.open(self.pid_file, 'w') { |x| x.write(::Process.pid) }
    end

    #http://www.jstorimer.com/blogs/workingwithcode/7766093-daemon-processes-in-ruby
    def daemonize
      if RUBY_VERSION < "1.9"
        exit if fork
        Process.setsid
        exit if fork
        Dir.chdir "/"
        STDIN.reopen "/dev/null"
        STDOUT.reopen "/dev/null", "a"
        STDERR.reopen "/dev/null", "a"
      else
        Process.daemon
      end
    end

    def delete_if_exists(filename)
      tries = 0

      begin
        File.unlink(filename) if filename && File.exists?(filename)
      rescue IOError, Errno::ENOENT
      rescue Errno::EACCES
        retry if (tries += 1) < 3
        $stderr.puts("Warning: permission denied trying to delete #{filename}")
      end
    end

  end
end
