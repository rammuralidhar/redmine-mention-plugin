require 'json'
module AutoCompletesControllerPatch
  def self.included(base) # :nodoc:
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    # Wraps the association to get the Deliverable subject.  Needed for the 
    # Query and filtering
    def autocomplete_mention_user
      if @project
        @users = @project.users.to_a.delete_if{|u| (u.type != 'User' || u.mail.empty?)}
      else
      	@users = User.logged.select("id, login, firstname, lastname") 
      end

      if params[:issue_id].present?
        watcher_user_ids = Issue.find(params[:issue_id]).watcher_user_ids
        
        watcher_user_ids.each do |watcher_user_id|
          unless @users.any? {|user| user.id == watcher_user_id}
            @users << User.find(watcher_user_id);
          end
        end
      end
      render :json => @users
    end

  end
end

AutoCompletesController.send(:include, AutoCompletesControllerPatch)
