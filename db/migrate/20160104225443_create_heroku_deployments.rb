class CreateHerokuDeployments < ActiveRecord::Migration[5.0]
  def change
    create_table :heroku_deployments do |t|
      t.string :app
      t.string :user
      t.string :url
      t.string :head
      t.string :head_long
      t.text :git_log
      t.string :release

      t.timestamps
    end
  end
end
