require 'rails_helper'

RSpec.describe 'Receiving Heroku webhooks', type: :request, vcr: true do

  describe 'receiving a POST from Heroku' do
    it 'records a HerokuDeployment and sends a message to Slack' do
      expect_any_instance_of(Slack::Notifier).to receive(:ping).with(<<-EOF.strip_heredoc.strip)
      example@example.com deployed revision 4f20bdd to secure-woodland-9775.
      ```
      * Michael Friis: add bar
      ```
      EOF
      post '/webhooks/heroku',
        params: {
          app: 'secure-woodland-9775',
          user: 'example@example.com',
          url: 'http://secure-woodland-9775.herokuapp.com',
          head: '4f20bdd',
          head_long: '4f20bdd',
          prev_head: nil,
          git_log: '* Michael Friis: add bar',
          release: 'v7'
        }

      expect(response.status).to eq(200)
      expect(HerokuDeployment.count).to eq(1)
      expect(HerokuDeployment.last.head).to eq('4f20bdd')
    end
  end

end
