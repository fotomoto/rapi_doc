require File.dirname(__FILE__) + '/../../lib/rapi_doc.rb'

desc "Generate the API Documentation"
task :rapi_doc do
  api_docs_config_file  = "#{::Rails.root.to_s}/config/documentation.yml"
  usage =<<-EOF
      Please ensure that you have created a documentation.yml file
      in your config directory. e.g:
        layers:
          location: "/api/layers"
          controller_name: "api/layers_controller.rb"
      EOF

  begin
    api_docs_config = YAML.load_file(api_docs_config_file)
  rescue
    puts usage
  end
  
  if api_docs_config
    resources = api_docs_config.keys.collect do |resource_name|
      api_path        = api_docs_config[resource_name]["location"]
      api_controller  = api_docs_config[resource_name]["controller_name"]
      ResourceDoc.new(resource_name, api_path, api_controller)
    end

    # generate the apidoc
    RAPIDoc.new(resources)
  end
end
