#!/usr/bin/env ruby
# encoding: UTF-8
#
# - check version info of java jar file
# SEE: http://stackoverflow.com/questions/3313532/what-version-of-javac-built-my-jar
#

require 'optparse'
require 'zip'

################################################################
# module JarChecker

module JarChecker
    # SEE: http://en.wikipedia.org/wiki/Java_class_file
    VER_INFO = {
        52 => "J2SE 8",
        51 => "J2SE 7",
        50 => "J2SE 6.0",
        49 => "J2SE 5.0",
        48 => "JDK 1.4",
        47 => "JDK 1.3",
        46 => "JDK 1.2",
        45 => "JDK 1.1",
    }

    def self.parse_jar(jar_file, verbose = false)
        ver_info                = {}
        details_title_outputted = false

        Zip::File.open(jar_file) do |zip_file|
            zip_file.each do |entry|
                next if !entry.file?

                if entry.name.end_with?('.class')               # get ver info of class file
                    first_8_bytes = entry.get_input_stream.read(8)
                    ver = first_8_bytes.unpack('C*')[-1]

                    ver_info[ver] = ver_info[ver].to_i + 1

                    next if !verbose

                    if !details_title_outputted
                        details_title_outputted = true
                        puts 'Details'
                        puts '--------------------------------'
                    end

                    puts "#{"%-8s" % VER_INFO[ver]} (#{ver}): #{entry.name}"
                elsif entry.name == 'META-INF/MANIFEST.MF'    # get manifest info
                    next if !verbose

                    puts entry.name
                    puts '--------------------------------'
                    puts entry.get_input_stream.read
                    puts
                end
            end
        end

        puts

        puts "Summary"
        puts '--------------------------------'

        ver_info.each { |ver, cnt|
            puts "#{"%-8s" % VER_INFO[ver]} (#{ver}): #{cnt} class files"
        }
    end
end

################################################################
# utilities

def calc_time(&block)
    start_time = Time.now

    begin
        yield if block_given?
    rescue Errno::EPIPE => e        # http://www.jstorimer.com/blogs/workingwithcode/7766125-writing-ruby-scripts-that-respect-pipelines
        exit(74)
    rescue => e
        report_error e
    end

    end_time = Time.now
    diff     = end_time - start_time

    hours   = diff.to_i / 3600
    minutes = diff.to_i / 60 - hours * 60
    seconds = diff % 60

    puts "\nTime Used:\t%i:%i:%.3f" % [hours, minutes, seconds]
end

def report_error(e, info = nil)
    $stderr.puts "Error during processing: #{$!} (#{e.class})"
    $stderr.puts "info = #{info}" if info
    $stderr.puts "Backtrace:\n\t#{e.backtrace.join("\n\t")}"
end

################################################################
# process methods

def parse_args(argv)
    @file    = ''
    @verbose = false

    opts = OptionParser.new { |opts|
        opts.banner =   'Check version info of java jar file' + "\n\n" +
                        'Usage:' + "\n" +
                        '    $ ruby check_jar.rb [options] jar_file'

        opts.separator ''
        opts.separator 'Specific options:'

        opts.on('-v', '--verbose', 'verbose output') {
            @verbose = true
        }

        opts.separator ''
        opts.separator 'Common options:'

        opts.on_tail('-h', '--help', 'Show this message') {
            puts opts
            exit
        }
    }

    @file = opts.parse!(argv)[0]

    if !@file
        puts opts
        exit
    end
end

def do_task()
    JarChecker.parse_jar(@file, @verbose)
end

def main(argv)
        calc_time() {
            parse_args(argv)
            do_task()
        }
end

################################################################
# main entry

main(ARGV)
