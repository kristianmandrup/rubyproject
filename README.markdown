# Ruby application generator ##

A Thor based generator to rapidly create a Ruby project with all the infrastructure setup for testing, mocking etc.

* Jeweler to create basic gem setup
* Binaries in \bin if --binaries
* Project library files in /lib
* Cucumber features, step definitions and basic configurations
* Rspec2 specs with configurations
* Unit tests 
* Shoulda tests 
* Mock libraries: mocha, flex, rr, rspec
* Autotest with grock and fsevent
* Bundler configuration for gem management
* Require DSL using require-me gem
* RCov for test coverage
* Heckle for test mutations

## Install ##

It can be installed as a thor task:

<code>$ thor install lib/application.thor</code>

Alternatively install it as a gem and use the binary.
<code>$ gem install rubyapp</code>

## Usage ##

To run it as a thor task:
<code>$ thor ruby:app my-ruby-app [options]</code>

Alternatively run it using the binary
<code>$ rubyapp my-ruby-project [options]</code>

## Options ##
             
You can define system wide default options for ruby apps you create (your preferred framework stack) in a <code>~/.rubyapp</code> file.
The <code>~*</code> implies <code>ENV['HOME]</code>, the environment variable "HOME" on any system. 
Any options you call the program with explicitly will override the defaults in this file.

The options <code>--rspec2, --cucumber, --license, --autotest, and --bundler</code> are all set to true unless explicitly disabled either in the <code>.rubyapp</code> file or using the negation option when rubyapp is run (see negating boolean options below).

Boolean options:
To negate a boolean option prefix it with <code>no-</code>, fx <code>--no-rspec2</code> to disable rspec2 from the project infrastructure creation.

Rubyproject currently supports the following boolean options:

<pre><code>--install_gems
--jeweler
--bundler
--rspec2 
--cucumber
--signatures
--license
--binaries
--test_unit
--shoulda
--autotest
--heckle
--rake
--rcov   
--timecop
--fakefs
--require_me
</code></pre>

String options:
<code>--mock-lib</code>
<code>--factory-lib</code>

Mock-lib:
Valid *mock-lib* values: rspec, mocha, flexmock, rr

Example:
<code>$ rubyapp my-ruby-mock-project --mock-lib flexmock</code> 

Factory-lib:
Valid *factory-lib* values: factory_girl, machinist, object_daddy, blueprints

Example:
<code>$ rubyapp my-ruby-mock-project --factory-lib factory_girl</code> 

## Community ##
Please feel free to fork this project or provide suggestions for improvements, bug fixes etc.

*Share and enjoy!*

Copyright (c) 2010, Kristian Mandrup

