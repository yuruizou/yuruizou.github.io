# Build the configured site and inspect its generated pages offline.
require "jekyll"
require "tmpdir"
require_relative "check_content"

ContentChecks.check
root = ContentChecks::ROOT
Dir.chdir(root) do
  Dir.mktmpdir("yurui-site-check-") do |destination|
    site = Jekyll::Site.new(Jekyll.configuration("source" => root, "destination" => destination, "quiet" => true))
    site.process
    unless system("python3", File.join(root, "scripts/check_rendered_site.py"), destination, "--baseurl", site.config["baseurl"].to_s)
      abort "Rendered site checks failed"
    end
  end
end
puts "Site build and rendered checks passed."
