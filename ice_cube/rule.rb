# encoding: utf-8
require 'ice_cube'

include IceCube

# Every fourth day
schedule = Schedule.new(Date.today)  
schedule.add_recurrence_rule Rule.daily(4) 
p schedule
 
# Every other week, on Mondays and Fridays
schedule = Schedule.new(Date.today)  
schedule.add_recurrence_rule Rule.weekly(2).day(:monday, :friday)
p schedule

# Every month on the 10th, 20th and last day of the month
schedule = Schedule.new(Date.today)  
schedule.add_recurrence_rule Rule.monthly.day_of_month(10, 20, -1) 
p schedule

# Every month on the first Monday and last Tuesday
schedule = Schedule.new(Date.today)  
schedule.add_recurrence_rule Rule.monthly.day_of_week(
  :monday => [1],
  :tuesday => [-1]
)
p schedule

# Every year on the 50th day and 100th day from the end of the year
schedule = Schedule.new(Date.today)  
schedule.add_recurrence_rule Rule.yearly.day_of_year(50, -100)  
p schedule

# Every fourth day except Mondays and Fridays
schedule = Schedule.new(Date.today)  
schedule.add_recurrence_rule Rule.daily(4)
schedule.add_exception_rule Rule.weekly.day(1, 5) 
p schedule
