# Rewrites internal links in post/page content to include the /archives baseurl prefix,
# so that rendered HTML links resolve correctly without going through redirections.
#
# Handles:
#   - Root-relative paths:          href="/files/..." → href="/archives/files/..."
#   - Absolute same-domain links:   href="https://domain/path" → href="/archives/path"
#   - Protocol-relative same-domain: href="//domain/path" → href="/archives/path"
#   - All of the above for src= attributes (images, etc.)

Jekyll::Hooks.register [:pages, :posts, :documents], :post_convert do |doc|
  next unless doc.content&.include?('<')

  baseurl  = doc.site.config['baseurl'].to_s  # "/archives"
  site_url = doc.site.config['url'].to_s       # e.g. "https://aix-marseille.afup.org"

  content = doc.content

  # 1. Rewrite absolute same-domain links (http://, https://, and protocol-relative //)
  unless site_url.empty?
    bare_domain = site_url.sub(%r{\Ahttps?://}, '')
    content = content.gsub(%r{(href|src)="(?:https?:)?//#{Regexp.escape(bare_domain)}(/[^"]*)"}) do
      "#{$1}=\"#{baseurl}#{$2}\""
    end
  end

  # 2. Rewrite root-relative links not already starting with baseurl
  content = content.gsub(/(href|src)="(\/[^"]*)"/) do
    attr, path = $1, $2
    path.start_with?(baseurl) ? "#{attr}=\"#{path}\"" : "#{attr}=\"#{baseurl}#{path}\""
  end

  doc.content = content
end
