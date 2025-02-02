# frozen_string_literal: true

DiscourseAutomation::Scriptable.add(DiscourseAutomation::Scripts::REPLY_ON_SOLUTION) do
  field :reply_text, component: :text

  version 1

  triggerables [:first_accepted_solution] if defined?(DiscourseSolved)

  script do |context, fields, automation|
    Rails.logger.warn("DEBUG Automation Context: #{context.inspect}") # Debug line
    # post = context["post"]
    topic = context["accepted_post_id"]
    unless topic
      Rails.logger.error("No topic found in context!")
      return
    end
    Rails.logger.warn("This is the value of the variable topic: #{topic}")
    # topic = post.topic
    reply_text = fields.dig("reply_text", "value")

    # Post a reply in the topic where a solution was marked
    # PostCreator.create!(
    #   Discourse.system_user,
    #   topic_id: topic.id,
    #   raw: reply_text || "A solution has been marked for this topic!",

    # )
    begin
      PostCreator.create!(
        Discourse.system_user,
        topic_id: topic,
        raw: reply_text || "A solution has been marked for this topic!",
      )
    rescue => e
      Rails.logger.error("POST CREATION FAILED: #{e.message}\n#{e.backtrace.join("\n")}")
    end
  end
end
