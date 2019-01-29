require 'rack'
require 'spec_helper'

Billy.configure do |c|
  # you can comment that out to see a log of puffing billy requests
  c.logger = nil
  # helps us assert on the requests received by Billy
  c.record_requests = true
  # to ensure we'll be able to compare the drivers
  c.cache = false
end

class RackApp
  def self.call(env)
    [200, {'Content-Type' => 'text/html'}, [
      <<-HTML
        <html>
          <head>
            <script src="https://js.recurly.com/v4/recurly.js"></script>
          </head>
          <body>
            <h1>Hello!</h1>
          </body>
        </html>
      HTML
    ]]
  end
end

Capybara.app = RackApp

RSpec.describe "Proxying of 3rd party requests", type: :feature do
  drivers = [
    :apparition_with_puffing_billy,
    :poltergeist_with_puffing_billy
  ].each do |driver|
    it "works with #{driver}", driver: driver do
      visit '/'
      expect(page).to have_content("Hello!")

      expect(Billy.proxy.requests.map { |r| r.fetch(:url) }).to include(
        "https://js.recurly.com:443/v4/recurly.js"
      )
    end
  end
end
