module Biobot
  module Periodicals
  end
end

Dir[File.dirname(__FILE__) + "/periodicals/*.rb"].each do |filename|
  require filename
  klass = File.basename(filename, '.rb').capitalize
  Biobot::Base.send(:include, Biobot::Periodicals.const_get(klass))
end
