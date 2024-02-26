require_dependency 'issue'

module IssuePatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      after_destroy :delete_from_google_calendar

      
    end
  end

  module InstanceMethods
    def delete_from_google_calendar

      issue_id = self.id

      # Rails.logger.info "Issue ID: " + issue_id.to_s
      begin
        curr_issue_event = IssueEvent.find_by(issue_id: issue_id)
        cal = get_acces_to_google_calendar
        event_to_delete = cal.find_event_by_id(curr_issue_event.event_id)
        cal.delete_event(event_to_delete[0])
      rescue => e
        Rails.logger.error "#{e.message}"
      end
    end

    def get_acces_to_google_calendar 

      cal = Google::Calendar.new(:client_id => Setting.plugin_redmine_gc_sync['client_id'].to_s, 
                    :client_secret => Setting.plugin_redmine_gc_sync['client_secret'].to_s, 
                    :calendar => Setting.plugin_redmine_gc_sync['calendar_id'].to_s, 
                    :redirect_url => "urn:ietf:wg:oauth:2.0:oob",  # this is what Google uses for 'applications'
                               :refresh_token => Setting.plugin_redmine_gc_sync['refresh_token'].to_s
                               )
  
      return cal
    end

  end

end