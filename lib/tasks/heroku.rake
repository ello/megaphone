namespace :heroku do
  task :configure_deploy_hooks => :environment do
    require 'platform-api'
    heroku = PlatformAPI.connect_oauth(ENV['HEROKU_OAUTH_TOKEN'])
    app_names = heroku.app.list.map { |a| a['name'] }
    app_names = app_names.select {|n| Regexp.new(ENV['HEROKU_APP_FILTER']).match(n) } if ENV['HEROKU_APP_FILTER']
    webhook_url = "https://#{ENV['HEROKU_APP_NAME']}.herokuapp.com/webhooks/heroku"
    app_names.each do |name|
      unless heroku.addon_attachment.list_by_app(name).find { |a| a['name'] == 'megaphone_deploy_hook' }
        puts "Creating a webhook for #{name} to #{webhook_url}"
        heroku.addon.create(name,
                            plan: 'deployhooks:http',
                            attachment: { name: 'megaphone_deploy_hook' },
                            config: { url: webhook_url })
      end
    end
  end
end
