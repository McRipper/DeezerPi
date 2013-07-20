#!/usr/bin/env ruby
require 'rubygems'
require 'daemons'

dir = File.expand_path(File.join(File.dirname(__FILE__), '..'))

daemon_options = {
  :app_name   => "player",
  :multiple   => false,
  :dir_mode   => :normal,
  :dir        => File.join(dir, 'tmp', 'pids'),
  :backtrace  => true,
  :monitor    => true
}

Daemons.run_proc('player', daemon_options) do

  pid = 1
  first = true

  loop do

    if first == true
      status = false
      first = false
    else
      begin
        status = Process.kill(0, pid)
      rescue
        status = false
      end
    end

    puts status

    if status == false
      pid = fork{ exec 'mpg123','-q', "http://cdn-preview-b.deezer.com/stream/b18965a0efe1a8f312ff415c39397a51-1.mp3" }
    end

    sleep 1

  end

end
