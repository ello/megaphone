## Megaphone - Broadcast your Heroku deployments in Slack

Heroku's deploy hooks are very handy for notifying your team when something
changes, but they're mildly painful to set up in an ad-hoc way for a alrge
number of apps. Megaphone is a little app designed to sit in the middle and
receive deploy hooks, then rebroadcast them into Slack. It's also got a nice
little rake task for automatically scanning your Heroku account for apps and
provisioning the deploy hooks as needed.

To set it up:

1. Clone down a copy of this repo and create a new Heroku app for it (e.g.
   `heroku create MY_MEGAPHONE`)
2. Create a new [Slack incoming webhook](https://api.slack.com/incoming-webhooks) for the channel into which you'd like to broadcast deploy notifications
3. Copy that webhook URL and set it as the SLACK_WEBHOOK_URL environment
   variable in your Heroku app (e.g. `heroku config:set
   SLACK_WEBHOOK_URL=<http://...>`)
4. Turn on [Dyno Metadata](https://devcenter.heroku.com/articles/dyno-metadata)
   for your  new app (this is so we can figure out its hostname) - e.g. `heroku labs:enable runtime-dyno-metadata`
5. [Obtain an OAuth token for the Heroku Platform API](https://github.com/heroku/platform-api#a-real-world-example) and use it to set the `HEROKU_OAUTH_TOKEN` environment variable on your app (e.g. `heroku config:set HEROKU_OAUTH_TOKEN=<...>`)
6. Set HEROKU_APP_FILTER environment variable on your app (optional) - this
   configures a regex that limits the apps for which the webhooks will be
   maintained. If no regex is supplied, all apps that the token has access to
   will have hooks added to them.
7. Run the `heroku:configure_deploy_hooks` rake task on your app to configure
   webhooks for all available apps to report into megaphone.
8. See the deployment notifications roll in!

