$LOAD_PATH << File.expand_path('../../../lib', __FILE__)
require 'hello'
require 'rspec'
World(RSpec::Matchers)
