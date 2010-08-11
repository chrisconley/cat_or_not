require 'gauntlet'

namespace :db do
  desc "Migrate the database"
  task(:migrate) do
    DataMapper.auto_upgrade!
  end
end

namespace :tunnlr do
  desc "Start tunnlr"
  task(:start) do
    puts "You can view your tunneled connection at http://web1.tunnlr.com:10703/"
    `ssh  -nNt -g -R :10703:0.0.0.0:4567 tunnlr1111@ssh1.tunnlr.com`
  end
end

Dir["#{File.dirname(__FILE__)}/lib/tasks/**/*.rake"].sort.each { |ext| load ext }