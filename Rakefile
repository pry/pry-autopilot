$:.unshift 'lib'

dlext = Config::CONFIG['DLEXT']
direc = File.dirname(__FILE__)

require 'rake/clean'
require 'rubygems/package_task'
require "pry-autopilot/version"

CLOBBER.include("**/*~", "**/*#*", "**/*.log")
CLEAN.include("**/*#*", "**/*#*.*", "**/*_flymake*.*", "**/*_flymake",
              "**/*.rbc", "**/.#*.*")

def apply_spec_defaults(s)
  s.name = "pry-autopilot"
  s.summary = "FIX ME"
  s.version = PryAutopilot::VERSION
  s.date = Time.now.strftime '%Y-%m-%d'
  s.author = "John Mair (banisterfiend)"
  s.email = 'jrmair@gmail.com'
  s.description = s.summary
  s.require_path = 'lib'
  s.homepage = "https://github.com/banister/pry-autopilot"
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
end

task :default => :test

desc "run pry with plugin enabled"
task :pry do
  exec("pry -I#{direc}/lib/ -r #{direc}/lib/pry-autopilot")
end

desc "run tests"
task :test do
  sh "bacon -Itest -rubygems -a"
end

desc "reinstall gem"
task :reinstall => :gems do
  sh "gem uninstall pry-autopilot" rescue nil
  sh "gem install #{direc}/pkg/pry-autopilot-#{PryAutopilot::VERSION}.gem"
end

desc "Show version"
task :version do
  puts "PryAutopilot version: #{PryAutopilot::VERSION}"
end

desc "Run example2"
task :example2 do
  sh "ruby -I#{direc}/lib/ #{direc}/examples/example2.rb "
end

desc "Run example3"
task :example3 do
  sh "ruby -I#{direc}/lib/ #{direc}/examples/example3.rb "
end

desc "Run example4"
task :example4 do
  sh "ruby -I#{direc}/lib/ #{direc}/examples/example4.rb "
end

desc  "Generate gemspec file"
task :gemspec => "ruby:gemspec"

namespace :ruby do
  spec = Gem::Specification.new do |s|
    apply_spec_defaults(s)
    s.platform = Gem::Platform::RUBY
  end

  Gem::PackageTask.new(spec) do |pkg|
    pkg.need_zip = false
    pkg.need_tar = false
  end

  desc  "Generate gemspec file"
  task :gemspec do
    File.open("#{spec.name}.gemspec", "w") do |f|
      f << spec.to_ruby
    end
  end
end

desc "shorthand for :gems task"
task :gem => :gems

desc "build all platform gems at once"
task :gems => [:clean, :rmgems, "ruby:gem"]

desc "remove all platform gems"
task :rmgems => ["ruby:clobber_package"]

desc "build and push latest gems"
task :pushgems => :gems do
  chdir("#{File.dirname(__FILE__)}/pkg") do
    Dir["*.gem"].each do |gemfile|
      sh "gem push #{gemfile}"
    end
  end
end


