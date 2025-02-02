Create your custom automation script
server.en.yml = add custom automation name; title; and description on scriptables
client.en.yml = ad custom automation name on scriptables; add the 'field' keyword; inside field keyword add 'field_name' followed by 'label' and 'description'
scripts.rb = add the custom automation name in the list of scripts. Sample: FILE_NAME = "file_name"
plugin.rb = inside 'after_initialize do', add the path to the custom automation script. Sample: 'lib/discourse_automation/scripts/file_name'
