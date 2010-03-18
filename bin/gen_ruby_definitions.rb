#!/usr/bin/ruby
# Simple rxsd test utility
#
# Usage rxsd-test.rb uri-to-schema uri-to-xml-instance
#
# Copyright (C) 2010 Mohammed Morsi <movitto@yahoo.com>
# See COPYING for the License of this software

require 'fileutils'
require 'lib/rxsd'

if ARGV.size < 2
  puts "missing required arguments"
  puts "usage: gen_ruby_definitions xsd_uri output_dir"
  exit
end

xsd_uri    = ARGV[0]
output_dir = ARGV[1]

if File.exists?(output_dir) && ! File.directory?(output_dir)
  puts "#{output_dir} is not a dir, exiting"
  exit
end

if !File.exists?(output_dir)
  FileUtils.mkdir(output_dir)
end

schema = RXSD::Parser.parse_xsd :uri => xsd_uri
definitions = schema.to :ruby_definitions

definitions.each { |d|
   d =~ /^.*class\s*([A-Za-z]*).*$/ # XXX Hacky way to get class name
   cl = $1
   File.write(output_dir + "/" + $1 + ".rb", d)
}
