# Ruby application generator ##

A Thor based generator to rapidly create a skeleton for a Ruby project as per the example 'Codebreaker' from the book 'The RSpec book'.
By default The project is setup with Cucumber and Rspec. 

* Jeweler to create basic gem setup
* binaries in \bin if --binaries
* project library files in /lib
* Cucumber features, step definitions and basic configurations
* Rspec2 specs with configurations
* Unit tests 
* Shoulda tests 
* Mock libraries: mocha, flex, rr, rspec
* Autotest with grock and fsevent
* Bundler configuration for gem management
* require-me gem usage for require DSL
* RCov for test coverage
* Heckle for test mutations

## Install ##

Currently requires my fork of Thor on github. Can also be run without installation

<code>$ thor install</code>

or to force 'yes' to all decisions and deploy

<code>$ thor install --force-all --deploy</code>

## Usage ##

To run without install, open terminal and stand in the lib dir.

`$ thor ruby:app my-ruby-app [options]`    

Boolean options:
To negate a boolean option prefixing it with <code>no-</code>, fx <code>--no-rspec2</code>

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
--mock_lib
--autotest
--heckle
--rake
--rcov
--require_me
</code></pre>

String options:
<code>--mock_lib</code>

Valid values: :rspec, :mocha, :flex, :rr
