# frozen_string_literal: true

# name: reply-on-solution-automation
# about: Custom automation that replies in the topic when the first solution is accepted
# version: 0.1
# authors: mrosa

enabled_site_setting :reply_on_solution_automation_enabled

after_initialize do
  if defined?(DiscourseAutomation) && defined?(DiscourseSolved)
    add_automation_scriptable("reply_on_solution") do

      # Add a configurable text field for the reply message
      field :reply_text, component: :text
      
      version 1

      # Only allow this script for the "first_accepted_solution" trigger
      triggerables %i[first_accepted_solution]
      triggerable! :first_accepted_solution

      script do |context, fields, automation|
        topic = context["topic"]
        reply_text = fields.dig("reply_text", "value") || 
          "A solution has been accepted for this topic!"

        # Ensure the topic context exists and is open for replies
        if topic && topic.archetype == Archetype.default && !topic.closed?
          PostCreator.create!(
            Discourse.system_user,
            topic_id: topic.id,
            raw: reply_text
          )
        end
      end
    end
  end
end
