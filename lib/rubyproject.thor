require 'thor/group'
require 'active_support/inflector'

module Ruby
  class Project < Thor::Group
    include Thor::Actions

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
      return nil if skip?[:binaries, 'Create binaries?')                     
        empty_directory 'bin'
        inside "bin" do      
          template('binary', "#{app_name}")
          template('binary.bat', "#{app_name}.bat")      
        end                     
      end
    end

    def create_cucumber_features       
      return nil if options[:skip_cucumber]
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
      return nil if options[:skip_rspec]         
      empty_directory 'spec'       
      inside 'spec' do                            
        empty_directory "#{app_name}"
        template('spec_helper.rb.erb', "#{app_name}/spec_helper.rb")      
        template('app_name/sample_spec.rb.erb', "#{app_name}/#{app_name}_spec.rb")      
      end
    end

    def create_unit_test   
      if options[:shoulda] || yes?("Use shoulda for unit tests?") 
         empty_directory 'shoulda'       
         inside 'shoulda' do                            
           template('test_app_name.rb.erb', "test_#{app_name}.rb")      
         end
      elsif options[:unit_test]         
        empty_directory 'test'       
        inside 'test' do                            
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
      return nil if skip?(:skip_license, 'Use MIT license?')
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