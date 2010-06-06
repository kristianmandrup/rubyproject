# Ruby application generator ##

A Thor based generator to rapidly create a skeleton for a Ruby project as per the example 'Codebreaker' from the book 'The RSpec book'.
By default The project is setup with Cucumber and Rspec. 

 * /bin       : binaries (optional)
 * /lib       : The main ruby project files  
 * /features  : Cucumber features and step definitions
 * /spec      : Rspec specs 
 * /test      : Unit tests
 * /shoulda   : Shoulda Unit tests 

## Install ##

Currently requires my fork of Thor on github. Can also be run without installation

`$ thor install`

or to force 'yes' to all decisions and deploy

`$ thor install --force-all --deploy`

## Usage ##

To run without install, open terminal and stand in the lib dir.

`$ thor ruby:app my-ruby-app`    

To force creation of binaries (executables)

`$ thor ruby:app my-ruby-project --binaries`    

Create shoulda and unit tests

`$ thor ruby:app my-ruby-project --shoulda --unit-test`    

Skip rspec and cucumber and only have unit tests

`$ thor ruby:app my-ruby-project --skip-cucumber --skip-rspec --unit-test`    
 
# TODO ##
   
## Community ##

Suggestions for improvement are welcome!