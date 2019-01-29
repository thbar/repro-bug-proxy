require 'capybara/rspec'
require 'capybara/apparition'
require "capybara/cuprite"
require 'billy/capybara/rspec'

Capybara.register_driver :apparition_with_puffing_billy do |app|
  options = {
    window_size: [1280, 1024],
    headless: true,
    js_errors: true
  }
  driver = Capybara::Apparition::Driver.new(app, options)
  driver.set_proxy(Billy.proxy.host, Billy.proxy.port)
  driver
end

# taken from https://github.com/oesmith/puffing-billy/blob/e8c5be54fd91884c0e3134a2f7e22db45517cf59/lib/billy/browsers/capybara.rb#L25
Capybara.register_driver :poltergeist_with_puffing_billy do |app|
  options = {
    phantomjs_options: [
      '--ignore-ssl-errors=yes',
      "--proxy=#{Billy.proxy.host}:#{Billy.proxy.port}"
    ]
  }
  ::Capybara::Poltergeist::Driver.new(app, options)
end

Capybara.register_driver :cuprite_with_puffing_billy do |app|
  options = {
    window_size: [1280, 1024]
  }
  driver = Capybara::Cuprite::Driver.new(app, options)
  driver.set_proxy(Billy.proxy.host, Billy.proxy.port)
  driver
end

Capybara.server = :webrick
