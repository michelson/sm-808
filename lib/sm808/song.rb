module Sm808
  class Song

    attr_accessor :patterns, :title, :bpm, :pattern_length

    def initialize(opts={})
      @title = opts[:title]
      @bpm =  opts[:bpm] ||= 60
      @patterns = []
      Clock.tempo = @bpm.to_f
    end

    def add_pattern(grid, name)
      @patterns << Pattern.new(grid: grid , instrument: name)
    end

    def steps_length
      @patterns.map{|o| o.steps.size}.max
    end

    def play
      @current_step = 1
      tick()
    end

    def tick
      return if @stop

      step_data = []

      @lock = Mutex.new

      @patterns.each do |pat|
        Thread.new do
          @lock.synchronize {
          step_data << { instrument: pat.instrument, step: pat.steps[@current_step-1] }
        }
        end.join()
      end

      process_step_data step_data

      sleep Clock.delay
      @current_step == steps_length ? reset_steps : increment_steps
      tick
    end

    def reset_steps
      @current_step = 1
    end

    def increment_steps
      @current_step += 1
    end

    def stop
      @stop = true
    end

    def process_step_data(data)
      arr = data.map{|o| o[:step].on? ? o[:instrument].name : nil }
      arr = arr.uniq.compact
      str = arr.empty? ? "_" : arr.join("+")
      print_and_flush("|#{str}")
    end

    def print_and_flush(str)
      print str
      $stdout.flush
    end

  end
end