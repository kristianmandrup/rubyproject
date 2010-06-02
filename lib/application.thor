 require 'active_support/inflector'

module Ruby
  class App < Thor::Group
    include Thor::Actions

    desc "Generates a ruby application"

    # Define arguments and options
    argument :app_name

    class_option :skip_rspec, :type => :boolean, :default => nil
    class_option :skip_cucumber, :type => :boolean, :default => nil
    class_option :skip_signatures, :type => :boolean, :default => nil
    class_option :skip_license, :type => :boolean, :default => nil
    
    class_option :binaries, :type => :boolean, :default => nil     
    class_option :unit_test, :type => :boolean, :default => nil                                              
    class_option :shoulda, :type => :boolean, :default => nil

    def self.source_root
      # template_path(__FILE__)
      File.join(File.dirname(__FILE__), '..', 'templates')      
    end

    def create_root
      self.destination_root = File.expand_path(app_name, destination_root)
    
      empty_directory '.'
      FileUtils.cd(destination_root)
    end
                           
                         
    def create_binaries    
      return nil if skip?(:binaries, 'Create binaries?')                     
      empty_directory 'bin'
      inside "bin" do      
        template('binary', "#{app_name}")
        template('binary.bat', "#{app_name}.bat")      
      end
    end

    def create_cucumber_features       
      return nil if options[:skip_cucumber]
      empty_directory 'features'       
      inside 'features' do
        template('app_name.feature.erb', "#{app_name}.feature")        
        empty_directory 'step_definitions'
        inside 'step_definitions' do
          template('app_name_steps.erb', "#{app_name}_steps.rb")                  
        end
        empty_directory 'support'
        inside 'support' do                       
            template('env.rb.erb', 'env.rb')      
        end
      end
    end
                                                  
    def create_specs                                
      return nil if options[:skip_rspec]         
      empty_directory 'spec'       
      inside 'spec' do                            
        empty_directory "#{app_name}"
        template('spec_helper.rb.erb', "spec_helper.rb")      
        template('app_name/sample_spec.rb.erb', "#{app_name}/#{app_name}_spec.rb")      
      end
    end
    
    def create_unit_test   
      return nil if !options[:shoulda]
       empty_directory 'shoulda'       
       inside 'shoulda' do                            
         template('test_app_name.rb.erb', "test_#{app_name}.rb")      
       end
    end
    
    def create_should_test
      return nil if !options[:unit_test]         
      empty_directory 'test'       
      inside 'test' do                            
        template('test_app_name.rb.erb', "test_#{app_name}.rb")      
      end 
    end
    
    def create_lib
      empty_directory 'lib'
      inside 'lib' do
        template('app_name.rb.erb', "#{app_name}.rb")
      end
    end
    
    def create_gitignore
      template('gitignore', '.gitignore')      
    end      
    
    def create_signature   
      return nil if skip?(:skip_signatures, 'Create signature files?') 
      empty_directory '_signatures'
      inside '_signatures' do
        template 'APP.RUBY.signature'       
      end
    end
      
    def copy_licence                                                  
      if skip?(:skip_license, 'Use MIT license?')
        say "Shame on you…", :red
        return
      end                                                                                                  
    
      if !ENV['USERNAME']
        say "WARNING: Env. variable USERNAME not set, using USERNAME = '#{ENV['USER']}' in license", :yellow   
       end
      # Make a copy of the MITLICENSE file at the source root
      template "MITLICENSE", "MITLICENSE"
    end   
   
   protected 
      def skip?(key, question)
        options[:key] || options[:key] == nil && !yes?(question)             
      end  
  end
end