-- Generates an atom feed from blog posts.
-- Assumes entry dates are in the correct format.
--
-- Based on the plugin from the Soupault blog blueprint at
-- https://codeberg.org/PataphysicalSociety/soupault-blueprints-blog
-- (in plugins/atom.lua).
--
-- Sample configuration:
-- [widgets.atom]
--   widget = "atom"
--   page = "blog/index.html" # Soupault will run this on every page if omitted
--   feed_file = "atom.xml" # default
--   excerpt_delete_elements = [".footnote-ref"] # default
--   site_url = "https://example.org" # no default, required
--   site_author = "Jane Example" # no default, optional but recommended
--   site_author_email = "jane@example.org" # no default, optional but recommended
--   site_title = "Example Website" # no default, optional but recommended
--   site_logo = "https://example.org/favicon.png # no default, optional but recommended
--   site_subtitle = "An example blog and website." # no default, optional
--
-- This also depends on an indexer being set up for the items you want in the feed.
-- See https://soupault.app/reference-manual/#metadata-extraction-and-rendering
-- for more information on how to do this.
--
-- Author: Lavender Perry
-- License: MIT

Plugin.require_version("4.0.0") -- From the plugin this is based on

local feed_file = config["feed_file"] or "atom.xml"
local site_url = config["site_url"]
if not site_url then
  Plugin.fail("Required configuration field site_url is missing.")
end

local data = {}
data["site_author"] = config["site_author"]
data["site_author_email"] = config["site_author_email"]
data["site_title"] = config["site_title"]
data["site_subtitle"] = config["site_subtitle"]
data["site_logo"] = config["site_logo"]

data["feed_id"] = Sys.join_path(site_url, feed_file)
data["soupault_version"] = Plugin.soupault_version()

if soupault_config["index"]["sort_descending"] or
   not Table.has_key(soupault_config["index"], "sort_descending") then
  data["feed_last_updated"] = site_index[1]["date"]
else
  data["feed_last_updated"] = site_index[size(site_index)]["date"]
end

local i = 1
while site_index[i] do
  local entry = site_index[i]
  local excerpt = HTML.parse(entry["excerpt"])

  Table.iter_values(
    HTML.delete,
    HTML.select_all_of(excerpt, config["excerpt_delete_elements"] or { ".footnote-ref" })
  )
  entry["excerpt"] = tostring(excerpt)

  i = i + 1
end
data["entries"] = site_index

local feed_template = [[
<?xml version='1.0' encoding='UTF-8'?>
<feed xmlns="http://www.w3.org/2005/Atom" xml:lang="en">
  <id>{{feed_id}}</id>
  <updated>{{feed_last_updated}}</updated>
  <title>{{site_title}}</title>
  {% if site_subtitle %}<subtitle>{{site_subtitle}}</subtitle>{% endif %}
  {% if site_logo %}<logo>{{site_logo}}</logo>{% endif %}
  <author>
    <name>{{site_author}}</name>
    {% if site_author_email %}<email>{{site_author_email}}</email>{% endif %}
  </author>
  <generator uri="https://soupault.app" version="{{soupault_version}}">soupault</generator>
  {% for e in entries %}
    <entry>
      <id>{{site_url}}{{e.url}}</id>
      <title>{{e.title}}</title>
      <updated>{{e.date}}</updated>
      <summary type="html">
        {{e.excerpt | escape}}
      </summary>
      <content type="html">
        {{e.content | escape}}
      </content>
      <link href="{{site_url}}{{e.url}}" rel="alternate"/>
    </entry>
  {% endfor %}
</feed>
]]
local feed = String.render_template(feed_template, data)
Sys.write_file(Sys.join_path(build_dir, feed_file), String.trim(feed))
