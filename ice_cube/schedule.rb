# encoding: utf-8
require 'rubygems'
require 'ice_cube'

include IceCube

# Parameters:
# - date/time of schedule beginning
# - {
#  :duration => 3600  - duration in seconds
#  :end_time => Time.now + 3600 - end time
# }
schedule = Schedule.new(Date.today)  

# Add recurrence
schedule.add_recurrence_time(Date.today)
# Add exception
schedule.add_exception_time(Date.today + 1)
p schedule
