require 'rubygems'
require 'bundler/setup'

Bundler.require(:default)


task :default do
	require './start.rb'
end

task :console do
	require 'irb'
	require 'irb/completion'
	require './start.rb'
	ARGV.clear
	IRB.start
end

