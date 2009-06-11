module Biobot
  module Commands
  end
end

Dir[File.dirname(__FILE__) + "/commands/*.rb"].each do |filename|
  require filename
  klass = File.basename(filename, '.rb').capitalize
  Biobot::Base.send(:include, Biobot::Commands.const_get(klass))
end
