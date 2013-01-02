# encoding: utf-8
require 'ice_cube'

include IceCube

# Every other day, 10 times
schedule = Schedule.new(Date.today)  
schedule.add_recurrence_rule Rule.daily(2).count(10)
p schedule

# Every other day until the end of the month
schedule = Schedule.new(Date.today)  
schedule.add_recurrence_rule Rule.daily(2).until((Date.today.next_month - Date.today.day).to_time)
p schedule

