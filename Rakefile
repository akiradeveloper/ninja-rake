# encoding: utf-8

load "git.rake"

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options

  # see https://github.com/technicalpickles/jeweler/blob/master/jeweler.gemspec for example
  # if gem is a instance of Gem::Specification, we can include files by
  # gem.files = [
  # ]

  gem.name = "ninja-rake"
  gem.homepage = "http://github.com/akiradeveloper/ninja-rake"
  gem.license = "MIT"
  gem.summary = %Q{Let your Ninja more powerful with Ruby}
  gem.description = %Q{ninja-rake enables you to play Ninja on the Rake framework}
  gem.email = "ruby.wktk@gmail.com"
  gem.authors = ["Akira Hayakawa"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.rcov_opts << '--exclude "gems/*"'
end

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ninja-rake #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
