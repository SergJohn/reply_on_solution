# frozen_string_literal: true

DiscourseAutomation::Scriptable.add(DiscourseAutomation::Scripts::REPLY_ON_SOLUTION) do
    field :reply_text, component: :text
    # field :answering_user, component: :user
    field :once, component: :boolean
  
    version 1
  
    triggerables %i[:first_accepted_solution] if defined?(DiscourseSolved)
  
    placeholder :sender_username
    placeholder :word
  
    script do |context, fields, automation|
      topic = context["topic"]
      # user = context["user"]
      reply_text = fields.dig("reply_text", "value")
  
      # Post a reply in the topic where a solution was marked
      PostCreator.create!(
        Discourse.system_user,
        topic_id: topic.id,
        raw: reply_text || "A solution has been marked for this topic!",
      )
    end
  end
  