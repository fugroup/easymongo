#!/usr/bin/env ruby

require './config/boot'

# Wipe db
$db.client[:users].drop

# Load tests. Comment out the ones you don't want to run.
begin
  start = Time.now
  [
    'query',
    'access',
    'features'
  ].each{|t| require_relative "#{t}_test"}
rescue => x
  puts x.message
  err(x)
ensure
  puts Time.now - start
end
