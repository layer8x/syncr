if RUBY_PLATFORM == "java"
  require 'simplecov'
  SimpleCov.start
else
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'syncr'

gem 'minitest'
require 'minitest/autorun'
require 'minitest/spec'
require 'purdytest'
require 'pry'
require 'fileutils'

TEMP_PATH = File.absolute_path('./tmp')
TEMP_FILE = "syncr.txt" # file name to be synced
TEMP_DATA = "Hello, Syncr!" # file contents to be synced
TEMP_ORIGIN_PATH = "#{TEMP_PATH}/origin/" # local path
TEMP_DESTINATION_PATH = "#{TEMP_PATH}/destination/" # external path
TEMP_ORIGIN_FILE = "#{TEMP_ORIGIN_PATH}#{TEMP_FILE}" # full path to local file
TEMP_DESTINATION_FILE = "#{TEMP_DESTINATION_PATH}#{TEMP_FILE}" # full path to external file

system("rm -rf #{TEMP_PATH}")
Dir.mkdir(TEMP_PATH)
[TEMP_ORIGIN_PATH, TEMP_DESTINATION_PATH].each { |p| Dir.mkdir(p) }

def reset_test_files
  File.open(TEMP_ORIGIN_FILE, 'w') do |f|
    f.write TEMP_DATA
  end

  # FileUtils.rm(TEMP_DESTINATION_PATH) if Dir.exists? TEMP_DESTINATION_PATH
  system("rm -rf #{TEMP_DESTINATION_PATH}") if Dir.exists? TEMP_DESTINATION_PATH
end
reset_test_files
