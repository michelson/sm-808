# SM-808 Practice exercise

This is part of [Splice](https://github.com/mattetti/sm-808) code challenge to code the sequencer part of  Drum Machine which called SM-808. the idea is to sequence and "play"
the famous [four-on-the-floor](http://en.wikipedia.org/wiki/Four_on_the_floor_(music)) rythm pattern.

## Usage

run as ``` bundle exec rspec spec/lib/song_spec.rb```


Play the rake tasks , patterns 8 steps each

```bundle exec rake sm808:play```


And patterns 8, 16, 2 steps each

```bundle exec rake sm808:play2```


## Commands:

  + start (run Sm808 app)
  + quit  (stop SM808 server)
  + reset (reset SM808 server)
  + song  (Create Song interactively)
  + play  (play)
  + info  (song info)
  + tempo (set tempo)
  + add   (add track)

## Client Application usage (dev)
```
  $ bundle exec ./bin/sm808 reset
  > SMS-808[3821] not running
  > Starting SM-808 server with pid 3821
  $ bundle exec ./bin/sm808 song
  Tune name: Demo
  Set tempo (BPM) 128
  mavri-song
  [0] Kick
  [1] Tom
  [2] Snare
  [3] Hi-Hat
  [4] Bass
  [5] Cymbal
  [6] Clap
  >> Choose instrument <<
  $ which instrument you want to use?
  > 0
  $ set the pattern, like [1,0,0,1]
  > [1,0,1,0]

  Would you like to add another instrument (Y/N)? n

  $ bundle exec ./bin/sm808 play
```

## Logging:

  logs are in the gem path /log/dev.log


## Acknowledgments

sound files from: http://hiphopmakers.com/free-808-drum-kit-227-samples
