require 'rubygems' unless ENV['NO_RUBYGEMS']
%w[rake rake/clean fileutils newgem rubigen].each { |f| require f }
require File.dirname(__FILE__) + '/lib/csspool'


$hoe = Hoe.new('maca-csspool', CSSPool::VERSION) do |p|
  p.developer('Aaron Patterson', 'aaronp@rubyforge.org')
  p.developer('John Barnette', 'jabarnette@rubyforge.org')
  p.changes = p.paragraphs_of("CHANGELOG.rdoc", 0..1).join("\n"*2)
  p.extra_dev_deps = [
    ['newgem', ">= #{::Newgem::VERSION}"]
  ]
  p.extra_deps = ['ffi']
  p.clean_globs |= %w[**/.DS_Store tmp *.log]
  path = (p.rubyforge_name == p.name) ? p.rubyforge_name : "\#{p.rubyforge_name}/\#{p.name}"
  p.remote_rdoc_dir = File.join(path.gsub(/^#{p.rubyforge_name}\/?/,''), 'rdoc')
  p.rsync_args = '-av --delete --ignore-errors'
end

require 'newgem/tasks' # load /tasks/*.rake
Dir['tasks/**/*.rake'].each { |t| load t }


# require 'rubygems'
# require 'hoe'


# Hoe.spec('csspool') do
#   developer('Aaron Patterson', 'aaronp@rubyforge.org')
#   developer('John Barnette', 'jabarnette@rubyforge.org')
#   self.readme_file   = 'README.rdoc'
#   self.history_file  = 'CHANGELOG.rdoc'
#   self.extra_rdoc_files  = FileList['*.rdoc']
#   self.extra_deps = ['ffi']
# end