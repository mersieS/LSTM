require 'faker'

start_date = Date.today - 1000

1000.times do |i|
  current_date = start_date + i.days

  TrafficDatum.create!(
    traffic_size: Faker::Number.between(from: 10000, to: 100000),
    date: current_date
  )
end
