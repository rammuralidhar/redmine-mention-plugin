require 'redmine'

Rails.configuration.after_initialize do
  require File.dirname(__FILE__) + '/lib/journal_hook'
  require File.dirname(__FILE__) + '/lib/issue_hook'
  require File.dirname(__FILE__) + '/lib/auto_completes_controller_patch'
  unless Redmine::WikiFormatting::Textile::Formatter.included_modules.include? MentionedNameFormatter
    Redmine::WikiFormatting::Textile::Formatter.send(:include, MentionedNameFormatter)
  end
end

Redmine::Plugin.register :redmine_mention_plugin do
  name 'Redmine Mention Plugin'
  author 'Steply'
  description 'Add user to watcher list after mentioning him/her (e.g. @john or @jhon.who) in issue note'
  version '0.2'
  url 'http://github.com/diegotdai/redmine-mention-plugin'
  requires_redmine :version_or_higher => '2.0.0'
  author_url 'http://steply.com'
end
