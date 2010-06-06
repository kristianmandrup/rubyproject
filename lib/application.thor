 require 'active_support/inflector'

module Ruby
  class App < Thor::Group
    include Thor::Actions

    desc "Generates a ruby application"

    # Define arguments and options
    argument :app_name

    class_option :rspec2, :type => :boolean, :default => true, :desc => "Use RSpec 2"
    class_option :cucumber, :type => :boolean, :default => true, :desc => "Use Cucumber"
    class_option :signatures, :type => :boolean, :default => true, :desc => "Create signature files"
    class_option :license, :type => :boolean, :default => true, :desc => "Create license file"    
    class_option :binaries, :type => :boolean, :default => false, :desc => "Create binaries"     

    class_option :test_unit, :type => :boolean, :default => false, :desc => "Use Test-unit"
    class_option :shoulda, :type => :boolean, :default => false, :desc => "Use Shoulda"

    class_option :mock_lib, :type => :string, :default => 'mocha', :desc => "Which Mocking framework to use"
    class_option :autotest, :type => :boolean, :default => true, :desc => "Use autotest"
    class_option :heckle, :type => :boolean, :default => false, :desc => "Use Heckle"    

    class_option :rake, :type => :boolean, :default => false, :desc => "Configure Rakefile for Rake"    
    class_option :jeweler, :type => :boolean, :default => false, :desc => "Use Jeweler"    
    class_option :rcov, :type => :boolean, :default => false, :desc => "Use RCov"    

    class_option :require_me, :type => :boolean, :default => false, :desc => "Use require-me gem"    
    
    class_option :bundler, :type => :boolean, :default => true, :desc => "Create a Gemfile and configure project to use Bundler"

    class_option :install_gems, :type => :boolean, :default => false, :desc => "Install all gems as required by project configuration"

    def self.source_root
      # template_path(__FILE__)
      File.join(File.dirname(__FILE__), '..', 'templates')      
    end

    def create_root
      self.destination_root = File.expand_path(app_name, destination_root)
    
      empty_directory '.'
      FileUtils.cd(destination_root)
    end

    def create_gemfile
      return nil if !options[:bundler]
      template 'Gemfile'
    end                               
                         
    def create_binaries    
      return nil if skip?(:binaries, 'Create binaries?')                     
      empty_directory 'bin'
      inside "bin" do      
        template('binary', "#{app_name}")
        template('binary.bat', "#{app_name}.bat")      
      end
    end

    def configure_cucumber       
      return nil if !options[:cucumber]
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
                                                  
    def configure_rspec                                
      return nil if !options[:rspec2]         
      empty_directory 'spec'       
      create_file 'spec/rspec.options', '.rspec'
      directory 'autotest'
      inside 'spec' do                            
        empty_directory "#{app_name}"
        template 'spec_helper.rb.erb', "spec_helper.rb"
        template 'app_name/sample_spec.rb.erb', "#{app_name}/#{app_name}_spec.rb"
      end
    end

    def configure_autotest                                
      return nil if !options[:autotest]         
      create_file 'autotest.options', '.autotest'     
    end

    def install_gems    
      return nil if !options[:install_gems] 
      run "gem install heckle" if options[:heckle]
      run "gem install rcov" if options[:rcov]
      run "gem install cucumber" if options[:cucumber]
      run "gem install rspec --pre" if options[:rspec]
      run "gem install ZenTest autotest-growl autotest-fsevent" if options[:autotest]            
      run "gem install #{options[:mock_lib]}"
      run "gem install require-me" if options[:require_me]
      run "gem install bundler" if options[:bundler]      
      run "gem install shoulda" if options[:shoulda]      
      run "gem install test-unit" if options[:test_unit]      
    end
    
    def configure_shoulda
      return nil if !options[:shoulda]
       empty_directory 'shoulda'       
       inside 'shoulda' do                            
         template('test_app_name.rb.erb', "test_#{app_name}.rb")      
       end
    end
    
    def configure_test_unit
      return nil if !options[:test_unit]         
      empty_directory 'test'       
      inside 'test' do                            
        template('test_app_name.rb.erb', "test_#{app_name}.rb")      
      end 
    end
    
    def create_lib
      empty_directory 'lib'
      inside 'lib' do      
        empty_directory "#{app_name}"
        template 'app_name.rb.erb', "#{app_name}/#{app_name}.rb"
        template 'app_entrypoint.erb', "#{app_name}.rb"
      end
    end
    
    def create_gitignore
      template('gitignore', '.gitignore')      
    end      

    def create_readme
      template('README.markdown', 'README.markdown')      
    end      

    
    def create_signature   
      return nil if skip?(:signatures, 'Create signature files?') 
      empty_directory '_signatures'
      inside '_signatures' do
        template 'APP.RUBY.signature'       
      end
    end
      
    def copy_licence                                                  
      if skip?(:license, 'Use MIT license?')
        say "Shame on you…", :red
        return
      end                                                                                                  
    
      if !ENV['USERNAME']
        say "WARNING: Env. variable USERNAME not set, using USERNAME = '#{ENV['USER']}' in license", :yellow   
       end
      # Make a copy of the MITLICENSE file at the source root
      template "MITLICENSE", "MITLICENSE"
    end   

    def notice
      if options[:cucumber] 
        say "---"
        say "autotest notice:"
        say "To avoid cucumber features being run, start autotest like this"
        say "$ AUTOFEATURE=false autotest"
      end
    end
   
   protected 
      def skip?(key, question)
        !options[key] || !yes?(question)
      end  
  end
end