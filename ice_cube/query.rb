# encoding: utf-8
require 'rubygems'
require 'ice_cube'

include IceCube

# Every second day, 10 times
schedule = Schedule.new(Time.now)  
schedule.add_recurrence_rule Rule.daily(2).count(10)

# All occurrence instances
p schedule.all_occurrences

# All occurrence instances until certain time
p schedule.occurrences((Date.today + 5).to_time)

# Occurs at a certain time
p schedule.occurs_at?(Time.now)

# Occurs on a certain day
p schedule.occurs_on?(Date.today)

# Occurs during a certain time-frame
p schedule.occurs_between?(Time.now, (Date.today + 5).to_time)

# First occurrence instances
p schedule.first
p schedule.first(3)

# Next occurrence instance
p schedule.next_occurrence
# Next 3 occurrence instances
p schedule.next_occurrences(3)
# Remaining occurrence instances
p schedule.remaining_occurrences

