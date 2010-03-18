require 'thor/group'
require 'active_support/inflector'

module Ruby
  class Project < Thor::Group
    include Thor::Actions

    # Define arguments and options
    argument :app_name
    class_option :skip_rspec, :type => :boolean, :default => false
    class_option :skip_cucumber, :type => :boolean, :default => false
    class_option :binaries, :type => :boolean, :default => false     
    class_option :unit_test, :type => :boolean, :default => false                                              
    class_option :shoulda, :type => :boolean, :default => false

    def self.source_root
      template_path(__FILE__)
    end

    def initialize(*args, &block)
      super
    end

    def create_root
      self.destination_root = File.expand_path(app_name, destination_root)

      empty_directory '.'
      FileUtils.cd(destination_root)
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
        template('app_name.feature.erb', "#{app_name}.feature")
        empty_directory 'step_definitions'
        empty_directory 'support'
        inside 'support' do                       
            template('env.rb.erb', 'env.rb')      
        end
      end
    end
                                                  
    def create_specs                                
      return if options[:skip_rspec]         
      empty_directory 'spec'       
      inside 'spec' do                            
        empty_directory "#{app_name}"
        template('spec_helper.rb.erb', "#{app_name}/spec_helper.rb")      
        template('app_name/sample_spec.rb.erb', "#{app_name}/#{app_name}_spec.rb")      
      end
    end

    def create_unit_test   
      if options[:unit_test]         
        empty_directory 'test'       
        inside 'test' do                            
          template('test_app_name.rb.erb', "test_#{app_name}.rb")      
        end 
      elsif options[:shoulda] || yes?("Use shoulda for unit tests?") 
         empty_directory 'shoulda'       
         inside 'shoulda' do                            
           template('test_app_name.rb.erb', "test_#{app_name}.rb")      
         end
      end
    end

    def create_lib
      empty_directory 'lib'
      inside 'lib' do
        template('app_name.rb.erb', "#{app_name}.rb")
      end
    end

    def create_signature   
      empty_directory '_signatures'
      inside '_signatures' do
        template 'APP.RUBY.signature'       
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
end