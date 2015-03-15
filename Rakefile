require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)
task default: :spec

# http://erniemiller.org/2014/02/05/7-lines-every-gems-rakefile-should-have/
desc "Run a development console"
task :console do
  require "irb"
  require "irb/completion"
  require "lil_ticker"
  ARGV.clear
  IRB.start
end

