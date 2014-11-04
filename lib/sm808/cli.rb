require "thor"
require "thor/group"
require "pry"

module Sm808
  class CLI < Thor

    no_commands {
      def available_instruments
        ["Kick", "Tom", "Snare", "Hi-Hat", "Bass", "Cymbal", "Clap"]
      end

      def init_application
        @app = Sm808::Application.new("sm808", foreground: false)
      end

      def send_to_daemon(command, *args)
        begin
          command = ([command, *args]).join(":")
          response = @app.client_command(command)
          if response.is_a?(Exception)
            $stderr.puts "Received error from server:"
            $stderr.puts response.inspect
            $stderr.puts response.backtrace.join("\n")
            exit(8)
          else
            response
          end

        rescue Errno::ECONNREFUSED
          abort("Connection Refused: Server is not running")
        end
      end

      def add_song

        title = ask("Tune name:")

        bpm = ask("Set tempo (BPM)").to_i

        send_to_daemon("create_song", title, bpm)

        add_track

      end

      def add_track
        puts available_instruments.each_with_index.map{|name, index| "[#{index}] #{name}"}
        puts ">> Choose instrument <<"
        inst = ask("which instrument you want to use?").to_i
        if available_instruments.each_with_index.map{|o, i| i}.include?(inst)
          instrument = available_instruments.each_with_index.find{|o, i| i == inst }[0]
        end

        pattern = ask("set the pattern, like [1,0,0,1]")

        send_to_daemon("add_tracks", instrument, pattern)

        another = yes?("Would you like to add another instrument (Y/N)?")

        add_track if another
      end
    }

    map %w(s) => 'server'
    desc "start", "run Sm808 app"
    def start
      init_application
      @app.start_server
      #song = yes?("Add a new song?")
      add_song #if song
    end

    map %w(r) => 'quit'
    desc "reset", "reset SM808 server"
    def reset
      init_application
      @app.quit
      sleep 2
      @app.start_server
    end

    map %w(q) => 'quit'
    desc "quit", "stop SM808 server"
    def quit
      init_application
      @app.quit
    end

    map %w(a) => 'add'
    desc "song ", "Create Song interactively"
    def song()
      init_application
      add_song
    end

    desc "hello", "say hello"
    def hello
      init_application
      send_to_daemon("hello")
    end

    desc "info", "song info"
    def info
      init_application
      send_to_daemon("info")
    end

    desc "play", "play"
    def play
      init_application
      send_to_daemon("play")
    end

    desc "stop", "stop"
    def stop
      init_application
      send_to_daemon("stop")
    end

    desc "tempo", "set tempo"
    def tempo(bpm)
      init_application
      send_to_daemon("tempo", bpm)
    end

    desc "add", "add track"
    def add
      init_application
      add_track
    end

  end
end