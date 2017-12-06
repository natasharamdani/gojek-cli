require 'bundler/setup'
require 'rdkafka'

config = {
          :"bootstrap.servers" => "velomobile-01.srvs.cloudkafka.com:9094, velomobile-02.srvs.cloudkafka.com:9094, velomobile-03.srvs.cloudkafka.com:9094",
          :"group.id"          => "go-cli",
          :"sasl.username"     => "akz986mn",
          :"sasl.password"     => "_VHudUAXaBKVQiy3_sbRmy6GexAQkRCT",
          :"security.protocol" => "SASL_SSL",
          :"sasl.mechanisms"   => "SCRAM-SHA-256"
}
topic = "akz986mn-go-cli"

rdkafka = Rdkafka::Config.new(config)
consumer = rdkafka.consumer
consumer.subscribe(topic)

last_distance    = 0
current_distance = 0

most_expensive  = 0
least_expensive = 0
most_farthest   = 0
most_active     = ''

begin
  consumer.each do |message|
    est_price = message[:est_price]

    current_distance = est_price / 1500

    most_expensive  = est_price if est_price >= most_expensive
    least_expensive = est_price if est_price <= least_expensive
    most_farthest   = distance if distance >= most_farthest
    most_active     = driver if current_distance >= last_distance

    last_distance = current_distance

    puts "#{message.payload}"
    puts most_expensive
    puts least_expensive
    puts most_farthest
    puts most_active
  end
rescue Rdkafka::RdkafkaError => e
  retry if e.is_partition_eof?
  raise
end
