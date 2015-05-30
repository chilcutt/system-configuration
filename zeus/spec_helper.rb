# add the following to spec_helper.rb

def zeus_running?
  File.exists? '.zeus.sock'
end

# auto-reload support files
unless zeus_running?
  Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
end

# auto-reload FactoryGirl
FactoryGirl.find_definitions unless zeus_running?
