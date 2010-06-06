require 'active_support/inflector'

module Ruby
  class App < Thor::Group
    include Thor::Actions

    desc "Generates a ruby application"

    # Define arguments and options
    argument :app_name

    class_option :rspec2,     :type => :boolean, :desc => "Use RSpec 2"
    class_option :cucumber,   :type => :boolean, :desc => "Use Cucumber"
    class_option :signatures, :type => :boolean, :desc => "Create signature files"
    class_option :license,    :type => :boolean, :desc => "Create license file"    
    class_option :binaries,   :type => :boolean, :desc => "Create binaries"     

    class_option :test_unit,  :type => :boolean, :desc => "Use Test-unit"
    class_option :shoulda,    :type => :boolean, :desc => "Use Shoulda"

    class_option :mock_lib,   :type => :string,  :desc => "Which Mocking framework to use"
    class_option :autotest,   :type => :boolean, :desc => "Use autotest"
    class_option :heckle,     :type => :boolean, :desc => "Use Heckle"    

    class_option :rake,       :type => :boolean, :desc => "Configure Rakefile for Rake"    
    class_option :jeweler,    :type => :boolean, :desc => "Use Jeweler"    
    class_option :rcov,       :type => :boolean, :desc => "Use RCov"    

    class_option :require_me, :type => :boolean, :desc => "Use require-me gem"    
    
    class_option :bundler,    :type => :boolean, :desc => "Create a Gemfile and configure project to use Bundler"

    class_option :install_gems, :type => :boolean, :desc => "Install all gems as required by project configuration"


    attr_accessor :project_options

    def self.source_root
      # template_path(__FILE__)
      File.join(File.dirname(__FILE__), '..', 'templates')      
    end

    def load_local_settings
      local_settings_file = File.join(ENV['HOME'], '.rubyproject')
      if File.exist? local_settings_file
        str = File.open(local_settings_file).read
        arr = str.split(/\n|,|:/).map{|s| s.strip}.map do |n| 
          case n
          when "true"
            true
          when "false" 
            false
          else 
            n
          end
        end
        local_settings = Hash[*arr]        
        @project_options = local_settings.merge(options)
      end
    end

    def default_settings
      @project_options ||= options.dup 
      [:rspec2, :cucumber, :license, :autotest, :bundler].each{|key| project_options[key] ||= true}      
    end

    def create_root 
      self.destination_root = File.expand_path(app_name, destination_root)    
      empty_directory '.'
      FileUtils.cd(destination_root)
    end

    def install_gems    
      return nil if !project_options[:install_gems] 
      gems << "heckle" if project_options[:heckle]
      gems << "rcov" if project_options[:rcov]
      gems << "cucumber" if project_options[:cucumber]      
      gems << "ZenTest autotest-growl autotest-fsevent" if project_options[:autotest]            
      gems << "#{project_options[:mock_lib]}"
      gems << "require-me" if project_options[:require_me]
      gems << "bundler" if project_options[:bundler]      
      gems << "shoulda" if project_options[:shoulda]      
      gems << "test-unit" if project_options[:test_unit]      
      gems << "rake" if project_options[:rake]      
      gems << "jeweler" if project_options[:jeweler]      

      run "gem install rspec --pre" if project_options[:rspec]
      run "gem install #{gems.join(' ')}"      
    end

    def main_runner            
      if project_options[:jeweler]
        run "jeweler #{appname}" 
      else
        create_app
      end
      create_gemfile if !skip?(:bundler, 'Use Bundler?')
      create_binaries if !skip?(:binaries, 'Create binaries?')
      configure_cucumber if !skip?(:cucumber, 'Use Cucumber?'
      configure_rspec2 if project_options[:rspec2]
      configure_autotest if !skip?(:autotest, 'Use autotest?') 
      configure_shoulda if project_options[:shoulda]  
      configure_test_unit if project_options[:test_unit]
      create_gitignore
      create_readme
      create_signatures if project_options[:signatures] 
      if skip?(:license, 'Use MIT license?')
        say "Shame on you…", :red
        return
      else        
        copy_licence
      end                                                                                                  
      autotest_feature_notice if project_options[:cucumber]       
    end

    protected

    def create_app
      create_lib
    end

    def create_lib
      empty_directory 'lib'
      inside 'lib' do      
        empty_directory "#{app_name}"
        template 'app_name.rb.erb', "#{app_name}/#{app_name}.rb"
        template 'app_entrypoint.erb', "#{app_name}.rb"
      end
    end

    def create_gemfile
      return nil if !
      template 'Gemfile'
    end                               
                         
    def create_binaries    
      empty_directory 'bin'
      inside "bin" do      
        template('binary', "#{app_name}")
        template('binary.bat', "#{app_name}.bat")      
      end
    end

    def configure_cucumber       
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
                                                  
    def configure_rspec2                                
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
      create_file 'autotest.options', '.autotest'     
    end
    
    def configure_shoulda
       empty_directory 'shoulda'       
       inside 'shoulda' do                            
         template('test_app_name.rb.erb', "test_#{app_name}.rb")      
       end
    end
    
    def configure_test_unit
      empty_directory 'test'       
      inside 'test' do                            
        template('test_app_name.rb.erb', "test_#{app_name}.rb")      
      end 
    end
        
    def create_gitignore
      template('gitignore', '.gitignore')      
    end      

    def create_readme
      template('README.markdown', 'README.markdown')      
    end      

    
    def create_signatures   
      empty_directory '_signatures'
      inside '_signatures' do
        template 'APP.RUBY.signature'       
      end
    end
      
    def copy_licence                                                      
      if !ENV['USERNAME']
        say "WARNING: Env. variable USERNAME not set, using USERNAME = '#{ENV['USER']}' in license", :yellow   
       end
      # Make a copy of the MITLICENSE file at the source root
      template "MITLICENSE", "MITLICENSE"
    end   

    def autotest_feature_notice      
      say "---"
      say "autotest notice:"
      say "To avoid cucumber features being run, start autotest like this"
      say "$ AUTOFEATURE=false autotest"
    end
   
   protected 
      def skip?(key, question)
        !project_options[key] || !yes?(question)
      end  
  end
end