require "dead_tout/version"
require 'set'

module DeadTout
  DEBUG = false

  class << self
    def exec(limit = 5)
      puts "Running...\n\n"
      ret = outdated_gems
      groups = Hash.new{|h, k| h[k] = []}
      ret.lines.each do |line|
        if /in groups "(?<group>.*?)"/ =~ line
          groups[group] << line.chomp
        end
      end
      groups.each do |group, gems|
        puts group
        gems.each do |gem|
          puts format_gem_line(gem)
        end
        puts
      end
      outdated_count = count_outdated(groups)
      if outdated_count > limit
        msg = "[NG] Limit is #{limit} but #{outdated_count} gems are outdated."
        STDERR.puts msg
        exit(false)
      else
        puts "[OK] #{outdated_count} gems are outdated. (Limit is #{limit}.)"
      end
    end

    def format_gem_line(text)
      text.gsub(/in groups .*/, '')
    end

    def outdated_gems
      unless DEBUG
        ret = `bundle outdated 2>&1`
        if success?(ret)
          return ret
        else
          raise "Error occurred:\n" + ret
        end
      end
      # For debug
      <<-TEXT
Outdated gems included in the bundle:
  * actioncable (newest 5.1.0, installed 5.0.2)
  * actionmailer (newest 5.1.0, installed 5.0.2)
  * actionpack (newest 5.1.0, installed 5.0.2)
  * actionview (newest 5.1.0, installed 5.0.2)
  * activejob (newest 5.1.0, installed 5.0.2)
  * activemodel (newest 5.1.0, installed 5.0.2)
  * activerecord (newest 5.1.0, installed 5.0.2)
  * activesupport (newest 5.1.0, installed 5.0.2)
  * arel (newest 8.0.0, installed 7.1.4)
  * audited (newest 4.4.1, installed 4.3.0, requested ~> 4.3.0) in groups "default"
  * brakeman (newest 3.6.1, installed 3.5.0) in groups "development"
  * bugsnag (newest 5.3.2, installed 5.3.0, requested ~> 5.3.0) in groups "default"
  * capybara (newest 2.13.0, installed 2.12.0, requested ~> 2.12.0) in groups "test"
  * crack (newest 0.4.3, installed 0.4.2)
  * domain_name (newest 0.5.20170404, installed 0.5.20170223)
  * email_spec (newest 2.1.0, installed 1.6.0, requested ~> 1.6.0) in groups "test"
  * enumerize (newest 2.1.0, installed 2.0.1, requested ~> 2.0.1) in groups "default"
  * faker (newest 1.7.3, installed 1.4.3, requested ~> 1.4.3) in groups "test"
  * fog (newest 1.40.0, installed 1.38.0, requested ~> 1.38.0) in groups "default"
  * fog-aws (newest 1.3.0, installed 1.2.1)
  * fog-cloudatcost (newest 0.2.3, installed 0.1.2)
  * fog-dynect (newest 0.2.0, installed 0.0.3)
  * fog-google (newest 0.5.2, installed 0.1.0)
  * fog-rackspace (newest 0.1.5, installed 0.1.4)
  * fog-vsphere (newest 1.9.1, installed 1.7.1)
  * fog-xml (newest 0.1.3, installed 0.1.2)
  * globalid (newest 0.4.0, installed 0.3.7)
  * heroku (newest 3.99.1, installed 3.41.5) in groups "development"
  * inherited_resources (newest 1.7.1, installed 1.7.0, requested ~> 1.7.0) in groups "default"
  * jquery-rails (newest 4.3.1, installed 4.2.2, requested ~> 4.2.1) in groups "default"
  * json (newest 2.1.0, installed 2.0.4)
  * mail (newest 2.6.5, installed 2.6.4)
  * mini_magick (newest 4.7.0, installed 4.6.1, requested ~> 4.6.1) in groups "default"
  * mysql2 (newest 0.4.5, installed 0.3.17)
  * newrelic_rpm (newest 4.1.0.333, installed 3.18.1.330, requested ~> 3.18.1) in groups "default"
  * pg (newest 0.20.0, installed 0.19.0, requested ~> 0.19.0) in groups "default"
  * poltergeist (newest 1.14.0, installed 1.13.0, requested ~> 1.13.0) in groups "test"
  * puma (newest 3.8.2, installed 3.7.1, requested ~> 3.7.1) in groups "default"
  * rails (newest 5.1.0, installed 5.0.2, requested = 5.0.2) in groups "default"
  * rails-observers (newest 0.1.3.alpha 7d3c9c3, installed 0.1.3.alpha cefffa5) in groups "default"
  * railties (newest 5.1.0, installed 5.0.2)
  * rbvmomi (newest 1.11.1, installed 1.9.5)
  * rest-client (newest 2.0.2, installed 2.0.1)
  * simplecov (newest 0.14.1, installed 0.13.0, requested ~> 0.13.0) in groups "test"
  * temple (newest 0.8.0, installed 0.7.7)
  * test-queue (newest 0.4.2, installed 0.4.0) in groups "test"
  * tilt (newest 2.0.7, installed 2.0.6)
  * uglifier (newest 3.2.0, installed 3.0.4) in groups "default"
  * unf_ext (newest 0.0.7.4, installed 0.0.7.2)
  * vcr (newest 3.0.3, installed 2.9.3, requested ~> 2.9.3) in groups "test"
  * webmock (newest 3.0.1, installed 1.20.4, requested = 1.20.4) in groups "test"
      TEXT
    end

    def count_outdated(groups)
      groups.flat_map {|group, gems|
        if !group.include?('development') && !group.include?('test')
          gems
        end
      }.compact.size
    end

    def success?(text)
      text =~ /Outdated gems included in the bundle:/
    end
  end
end
