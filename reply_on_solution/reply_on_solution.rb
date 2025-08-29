# frozen_string_literal: true

# name: reply-on-solution
# about: Replies to topics when a solution is accepted
# version: 0.1
# authors: mrosa

DiscourseAutomation::Scriptable.add(DiscourseAutomation::Scripts::REPLY_ON_SOLUTION) do
  field :reply_text, component: :text

  version 1

  triggerables [:first_accepted_solution] if defined?(DiscourseSolved)

  script do |context, fields, automation|
    Rails.logger.warn("DEBUG Automation Context: #{context.inspect}") # Debug line
    # post = context["post"]
    # topic = context["accepted_post_id"]
    # unless post
    #   Rails.logger.error("No post found in context!")
    #   return
    # end
    accepted_post_id = context["accepted_post_id"]
    accepted_post = Post.find_by(id: accepted_post_id)

    unless accepted_post
      Rails.logger.error("Accepted post with id #{accepted_post_id} was not found.")
      next
    end

    topic = accepted_post.topic
    Rails.logger.warn("This is the value of the topic id: #{topic.id}")
    # Rails.logger.warn("This is the value of the variable topic: #{topic}")
    # topicid = post.topic.id
    # Rails.logger.warn("Topic ID: #{topic_id}")
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
        topic_id: topic.id,
        raw: reply_text || "A solution has been marked for this topic!",
      )
    rescue => e
      Rails.logger.error("POST CREATION FAILED: #{e.message}\n#{e.backtrace.join("\n")}")
    end
  end
end
