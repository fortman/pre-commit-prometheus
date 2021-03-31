#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'

# example values
# rules_dir = '../chef-cookbooks/cookbooks/pprometheus_v2/files/default/alerts'
# tests_dir = '../chef-cookbooks/cookbooks/pprometheus_v2/files/default/unit-tests'
# accepted = 80
# exclude = ['rabbitmq.yml', 'redis.yml', 'postgresql.yml',
#            'win_systems.yml', 'vmware.yml', 'networking.yml',
#            'stparser-assets.yml']

# relative path, relative path, number (percent), alert sources to ignore
rules_dir, tests_dir, accepted, *exclude = ARGV

def get_yaml_files(dir)
  Dir.entries(dir).select do |f|
    /.*?\.y(?a)ml/ =~ f
  end
end

def load_file(directory, filename)
  path = File.join(directory, filename)
  data = File.open(path).read
  YAML.safe_load(data)
end

# rubocop:disable Metrics/MethodLength
def get_rules(yml)
  out = []
  yml['groups'].each do |group|
    group['rules'].each do |rule|
      begin
        out.push(rule['alert'])
      rescue StandardError
        p 'didnt have rule["alert"] name'
      end
    end
  end
  out
end
# rubocop:enable Metrics/MethodLength

def get_all_rules(dir)
  yaml_files = get_yaml_files(dir)
  out = []
  yaml_files.each do |f|
    # out.push(load_file(dir, f))
    yml = load_file(dir, f)
    rules = get_rules(yml)
    rules.each do |r|
      out.push({ source: f, rule: r }) if r
    end
  end
  out
end

def get_tests(yml)
  out = []
  yml['tests'].each do |test|
    test['alert_rule_test'].each do |rule|
      out.push(rule['alertname'])
    end
  end
  out
end

def get_all_tests(dir)
  yaml_files = get_yaml_files(dir)
  out = []
  yaml_files.each do |f|
    # out.push(load_file(dir, f))
    yml = load_file(dir, f)
    rules = get_tests(yml)
    rules.each do |r|
      out.push({ source: f, rule: r })
    end
  end
  out
end

rules = get_all_rules(rules_dir)
qrules = rules.uniq
tests = get_all_tests(tests_dir)
qtests = tests.uniq

qtests_names = []
qtests.each do |e|
  qtests_names.push(e[:rule])
end

missing_tests = qrules - qtests

skipped = []
final_missing = []
missing_tests.each do |mt|
  if qtests_names.include? mt[:rule]
    skipped.push(mt)
  else
    final_missing.push(mt)
  end
end

missing = []
final_missing.each do |t|
  if exclude.include? t[:source]
    skipped.push(t)
  else
    missing.push(t)
  end
end

coverage = ((rules.length - missing.length) / rules.length.to_f).round(2) * 100

# ----------------------------
p "skiplist: #{exclude}"
p "skipped: #{skipped.length}"
p "coverage: #{coverage}%"
p "accepted: #{accepted}%"
p '---Missing Tests---'

missing.each do |m|
  p "#{m[:source]} - #{m[:rule]}"
end

exit(0) if coverage > accepted.to_f
raise "accepted #{accepted} > actual coverage #{coverage}"
