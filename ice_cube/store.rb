# encoding: utf-8
require 'rubygems'
require 'ice_cube'

include IceCube

# Date/time parameter of schedule beginning
schedule = Schedule.new(Time.now)  
schedule.add_recurrence_rule Rule.daily

# YAML
p yaml = schedule.to_yaml
Schedule.from_yaml(yaml)

# Hash
p hash = schedule.to_hash
Schedule.from_hash(hash)

# iCalendar
p schedule.to_ical

# String
p schedule.to_s