class AddOauthColumnsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :oauth_token, :string
    add_column :users, :oauth_token_secret, :string
  end
end
