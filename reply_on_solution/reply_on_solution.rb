# frozen_string_literal: true

# name: reply_on_solution
# about: An sample test for reply on solution
# version: 0.0.1
# authors: mrosa

enabled_site_setting :reply_on_solution

after_initialize do
    reloadable_patch do
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
            add_automation_triggerable(DiscourseAutomation::Triggerable::FIRST_ACCEPTED_SOLUTION) do
                field :reply_text, component: :text
            end
        end
