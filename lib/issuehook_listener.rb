class IssuehookListener < Redmine::Hook::Listener
  unloadable

  def controller_issues_new_after_save(context = {})
    issue = context[:issue]
    project = issue.project
    
    # Rails.logger.info "controller_issues_new_after_save " + issue.to_s

    curr_issue_event = IssueEvent.new
    curr_issue_event.issue_id = issue.id
    
    begin
      curr_issue_event.save
    rescue => e
      Rails.logger.error "#{e.message}"
    end

  end

  def controller_issues_edit_after_save(context = {})
    issue = context[:issue]
    project = issue.project

    curr_issue_event = IssueEvent.find_by(issue_id: issue.id)
    begin
      curr_issue_event.send_to_google_calendar
    rescue => e
      Rails.logger.error "#{e.message}"
    end
    # Rails.logger.info "controller_issues_edit_after_save " + curr_issue_event.event_id
    

  end
    
end