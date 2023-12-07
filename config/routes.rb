RedmineApp::Application.routes.draw do
  match 'autocomplete/mention/user' => 'auto_completes#autocomplete_mention_user', :via => [:get, :post]
end
