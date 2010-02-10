require 'thor/group'

class Rubyproject < Thor::Group
  include Thor::Actions

  # Define arguments and options
  argument :app_name
  class_option :skip_rspec, :type => :boolean, :default => false
  class_option :skip_cucumber, :type => :boolean, :default => false
  class_option :binaries, :type => :boolean, :default => false     
  class_option :unit_test, :type => :boolean, :default => false                                              
  class_option :shoulda, :type => :boolean, :default => false                                                                                                                                         

  def self.source_root
    File.join(File.dirname(__FILE__), 'templates')
  end

  def create_root
    self.destination_root = File.expand_path(app_name, destination_root)
    # valid_app_const?

    empty_directory '.'
    # set_default_accessors!
    FileUtils.cd(destination_root)
  end
                           
  def create_project_file
    # empty_directory "#{app_name}"
  end
                         
  def create_binaries    
    if options[:binaries] || yes?("Create binaries?")                     
      empty_directory 'bin'
      inside "bin" do      
        template('binary', "#{app_name}")
        template('binary.bat', "#{app_name}.bat")      
      end                     
    end
  end

  def create_cucumber_features       
    return if options[:skip_cucumber]
    empty_directory 'features'       
    inside 'features' do
      template('app_name.feature', "#{app_name}.feature")
      empty_directory 'step_definitions'
      empty_directory 'support'
      inside 'support' do                       
          template('env.rb', "env.rb")      
      end
    end
  end
                                                  
  def create_specs                                
    return if options[:skip_rspec]         
    empty_directory 'spec'       
    inside 'spec' do                            
      empty_directory "#{app_name}"
      template('spec_helper.rb', "#{app_name}/spec_helper.rb")      
      template('app_name/sample_spec.rb', "#{app_name}/#{app_name}_spec.rb")      
    end
  end

  def create_unit_test   
    if options[:unit_test]         
      empty_directory 'test'       
      inside 'test' do                            
        template('test_app_name.rb', "test_#{app_name}.rb")      
      end 
    elsif options[:shoulda] || yes?("Use shoulda for unit tests?") 
       empty_directory 'shoulda'       
       inside 'shoulda' do                            
         template('test_app_name.rb', "test_#{app_name}.rb")      
       end
    end
  end

  def create_lib
    empty_directory 'lib'
    inside 'lib' do
      template('app_name.rb', "#{app_name}.rb")
    end
  end
  
  def copy_licence
    if yes?("Use MIT license?")   
                                                                                                  
      if !ENV['USERNAME']
        say "WARNING: Env. variable USERNAME not set, using USERNAME = '#{ENV['USER']}' in license", :yellow   
       end
  
      # Make a copy of the MITLICENSE file at the source root
      template "MITLICENSE", "MITLICENSE"
    else
       say "Shame on you…", :red
    end
  end 
end