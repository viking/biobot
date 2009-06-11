# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{biobot}
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Stephens"]
  s.date = %q{2009-06-11}
  s.default_executable = %q{biobot}
  s.description = %q{An XMPP bot for Vanderbilt Biostatistics}
  s.email = %q{viking415@gmail.com}
  s.executables = ["biobot"]
  s.extra_rdoc_files = [
    "README",
     "README.daemonize"
  ]
  s.files = [
    ".autotest",
     ".gitignore",
     "README",
     "README.daemonize",
     "Rakefile",
     "VERSION",
     "bin/biobot",
     "biobot.gemspec",
     "config/biobot.yml-example",
     "lib/biobot.rb",
     "lib/biobot/base.rb",
     "lib/biobot/commands.rb",
     "lib/biobot/commands/greeting.rb",
     "lib/biobot/periodicals.rb",
     "lib/biobot/periodicals/notify.rb",
     "lib/daemonize.rb",
     "test/biobot/commands/test_greeting.rb",
     "test/biobot/periodicals/test_notify.rb",
     "test/biobot/test_base.rb",
     "test/biobot/test_commands.rb",
     "test/biobot/test_periodicals.rb",
     "test/helper.rb"
  ]
  s.homepage = %q{http://biostat.mc.vanderbilt.edu}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{An XMPP bot for Vanderbilt Biostatistics}
  s.test_files = [
    "test/biobot/test_commands.rb",
     "test/biobot/test_periodicals.rb",
     "test/biobot/periodicals/test_notify.rb",
     "test/biobot/test_base.rb",
     "test/biobot/commands/test_greeting.rb",
     "test/helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_runtime_dependency(%q<xmpp4r>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<xmpp4r>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<xmpp4r>, [">= 0"])
  end
end
