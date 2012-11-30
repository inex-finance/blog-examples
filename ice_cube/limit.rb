# encoding: utf-8
require 'rubygems'
require 'ice_cube'

include IceCube

# Every 2 days 10 times
schedule = Schedule.new(Date.today)  
schedule.add_recurrence_rule Rule.daily(2).count(10)
p schedule

# Every 2 days until November 30, 2012
schedule = Schedule.new(Date.today)  
schedule.add_recurrence_rule Rule.daily(2).until(Date.today.next_month - Date.today.day)
p schedule

