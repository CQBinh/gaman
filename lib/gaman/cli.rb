require 'thor'

module Gaman
  class Foo < Thor
    desc "hello NAME", "This will greet you"
    long_desc <<-HELLO_WORLD

    `hello NAME` will print out a message to the person of your choosing.

    Brian Kernighan actually wrote the first "Hello, World!" program
    as part of the documentation for the BCPL programming language
    developed by Martin Richards. BCPL was used while C was being
    developed at Bell Labs a few years before the publication of
    Kernighan and Ritchie's C book in 1972.

    http://stackoverflow.com/a/12785204
    HELLO_WORLD
    option :upcase
    def bar(name)
      greeting = "Hello, #{name}"
      greeting.upcase! if options[:upcase]
      puts greeting
    end
  end
end
