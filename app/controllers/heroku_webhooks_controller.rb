class HerokuWebhooksController < ApplicationController

  def create
    @deployment = HerokuDeployment.create!(heroku_webhook_params)
    ping_slack
    head :ok
  end

  private

  def heroku_webhook_params
    params.permit(:app,
                  :user,
                  :url,
                  :head,
                  :head_long,
                  :git_log,
                  :release)
  end

  def ping_slack
    notifier.ping "#{@deployment.user} deployed revision #{@deployment.head} to #{@deployment.app}.\n```\n#{@deployment.git_log}\n```"
  end

  def notifier
    Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'])
  end
end
