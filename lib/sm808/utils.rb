require 'rbconfig'

module Sm808

  module Utils

    def os
      @os ||= (
        host_os = RbConfig::CONFIG['host_os']
        case host_os
        when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
          :windows
        when /darwin|mac os/
          :macosx
        when /linux/
          :linux
        when /solaris|bsd/
          :unix
        else
          raise "unknown os: #{host_os.inspect}"
        end
      )
    end

    def play_sound(file)
      case os
      when :macosx
        pid = fork{ exec 'afplay', sound_file(file) }
      when :linux
        pid = fork{ exec 'mpg123','-q', sound_file(file) }
      else
        raise "not implemented play sound for your operative system"
      end
      Process.detach(pid) if pid
    end

    def sound_file(name)
      Sm808.lib + "/sounds/#{name}.wav"
    end

    def location
      @location ||= Pathname.new(Dir.pwd)
    end

  end

end

