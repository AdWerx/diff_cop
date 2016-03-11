$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'

SimpleCov.start

require 'diff_cop'
require 'pry'

def fixture(name)
  File.read(File.join(File.dirname(__FILE__), 'fixtures', name))
end

def capture2
  stdout, stderr = $stdout, $stderr
  $stdout, $sterr = StringIO.new, StringIO.new
  yield
  [stdout, stderr]
ensure
  $stdout, $stderr = stdout, stderr
end
