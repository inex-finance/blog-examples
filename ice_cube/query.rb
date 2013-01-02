# encoding: utf-8
require 'ice_cube'

include IceCube

# Every second day, 10 times
schedule = Schedule.new(Time.now)  
schedule.add_recurrence_rule Rule.daily(2).count(10)

# All occurrences
p schedule.all_occurrences

# All occurrences until a certain time
p schedule.occurrences((Date.today + 5).to_time)

# Occurs at a certain time
p schedule.occurs_at?(Time.now)

# Occurs on a certain date
p schedule.occurs_on?(Date.today)

# Occurs during a certain time-frame
p schedule.occurs_between?(Time.now, (Date.today + 5).to_time)

# First occurrences
p schedule.first
p schedule.first(3)

# Next occurrence
p schedule.next_occurrence
# Next 3 occurrences
p schedule.next_occurrences(3)
# Remaining occurrences
p schedule.remaining_occurrences

