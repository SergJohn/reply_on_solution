# frozen_string_literal: true

# name: reply_on_solution
# about: An sample scratch autom
# version: 0.0.1
# authors: mrosa

enabled_site_setting :reply_on_solution_enabled

after_initialize do
    if defined?(DiscourseAutomation)
        on(:first_accepted_solution) do |topic, user|
            DiscourseAutomation::Automation
                .where(enabled: true, trigger: "first_accepted_solution")
                .find_each do |automation|
                automation.trigger!(
                    "kind" => "first_accepted_solution",
                    "usernames" => [user.username],
                    "topic" => topic,
                    "placeholders" => {
                        "sender_username" => user.username,
                        "word" => "solution",
                    },
                )
            end
        end
    end

    DiscourseAutomation::Scriptable::POST_REPLY = "post_reply"
    add_automation_scriptable(DiscourseAutomation::Scriptable::POST_REPLY) 
    do
    field :topic_id, component: :text
    field :reply_text, component: :text
    triggerables [:first_accepted_solution]

    script do |context, fields, automation|
    if automation.script == "post_reply"
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
