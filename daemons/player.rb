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

  Dir.chdir dir

  require "#{dir}/config/environment"

  loop do

    p = Playlist.find_by_sql("SELECT id, link FROM playlists WHERE _ROWID_ >= (abs(random()) % (SELECT max(_ROWID_) FROM playlists)) LIMIT 1;").first

    begin
      RestClient.get("http://10.1.9.38:8080/requests/status.xml?command=in_play&input=#{link}")
    rescue
      puts "Error reaching the music server"
    end

    Playlist.set_playing(p.id)

    sleep 30

  end

end
