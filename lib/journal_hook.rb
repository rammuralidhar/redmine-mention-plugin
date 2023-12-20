require_dependency 'issue'
require_dependency 'watcher'


  module JournalHook
    def self.included(base)
      base.send(:before_create) do |journal|
        if journal.journalized.is_a?(Issue) && journal.notes.present?
          issue = journal.journalized
          # TODO Should ignore email
          users = self.notified_users | self.notified_watchers
          users.select! do |user|
            self.notes? || self.visible_details(user).any?
          end
          user_login_ids = users.map{|u| u.login}
          
          mentioned_users = journal.notes.scan(/@[\w.]+/)
          mentioned_users.each do |mentioned_user|
            username = mentioned_user[1..-1] # Remove the heading ':'
            if user = User.find_by_login(username)
              Watcher.create(:watchable => issue, :user => user)
              if (!user_login_ids.include?(username))
                MentionMailer.notify_mentioning(issue, self, user).deliver
              end
            end
          end
        end
      end
    end
  end


Journal.send(:include, JournalHook) unless Journal.included_modules.include? JournalHook
