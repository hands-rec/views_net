require "views_net/version"

require "capybara"
require "capybara/dsl"
require "capybara/poltergeist"
require "net/http"
require "yaml"

Capybara.current_driver = :poltergeist
Capybara.javascript_driver = :poltergeist
Capybara.app_host = 'https://www.jreast.co.jp/card'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(
    app, 
    :js_errors => true, 
    :timeout => 60, 
    :phantomjs_logger => Module.new {
      def self.puts(*)
      end
    },
    :phantomjs_options => [
      '--ignore-ssl-errors=yes', 
      '--ssl-protocol=any',
      '--load-images=no']
  )
end

module ViewsNet
  class Client
    include Capybara::DSL

    def initialize(config)
      @config = YAML.load_file(config)
    end

    def payment_amount
      do_login
    
      click_on('LnkV0300_001Top')
      click_on('LnkClaimYm1')
    
      amount = {}
      within(:css, '#payment') do
          amount[:month] = first('th').text
          amount[:amount] = first('td').text
        end
      amount
    end

    private

    def do_login
      visit('https://viewsnet.jp/default.htm')
      
      fill_in('id', :with => @config['id'])
      fill_in('pass', :with => @config['password'])
      
      click_on('ログイン')
    end
  end
end
