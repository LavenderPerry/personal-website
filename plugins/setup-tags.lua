-- Transforms a list of tags into links that go to the relevant tag page,
-- places the tag links above the content divider.
--
-- Sample configuration (also shows defaults):
-- [widgets.setup-tags]
--   widget = "setup-tags"
--   title_selector = "h1"
--   content_selector = "#post-content"
--   tags_selector = "ul"
--   tag_page_location = "/blog/tags"
--   tag_container_id = "tags"
--   tag_link_class = "tag-link"
--
-- Author: Lavender Perry
-- License: MIT

Plugin.require_version("4.10") -- May work on older versions, but only tested on this

local content = HTML.select_one(page, config["content_selector"] or "#post-content")
local title_selector = config["title_selector"] or "h1"
local tags_selector = config["tags_selector"] or "ul"
local tag_page_location = config["tag_page_location"] or "/blog/tags"
local tag_container_id = config["tag_container_id"] or "tags"
local tag_link_class = config["tag_link_class"] or "tag-link"

local old_tags_elem = HTML.select_one(content, tags_selector)
if not old_tags_elem then
  Plugin.exit('tags with selector "' .. tags_selector .. '" not found. doing nothing.')
end

if HTML.child_count(old_tags_elem) ~= 0 then
  local title = HTML.select_one(page, title_selector)
  if not title then
    Plugin.fail('title with selector "' .. title_selector .. '" not found.')
  end

  local new_tags_elem = HTML.create_element("div")
  HTML.set_attribute(new_tags_elem, "id", tag_container_id)
  HTML.insert_after(title, new_tags_elem)

  local old_tags_children = HTML.children(old_tags_elem)
  local i = 1
  while old_tags_children[i] do
    local elem = old_tags_children[i]
    local tag = String.trim(HTML.inner_text(elem))
    if tag ~= "" then
      local tag_link = HTML.create_element("a", tag)
      HTML.set_attribute(tag_link, "class", tag_link_class)
      HTML.set_attribute(tag_link, "href", tag_page_location .. "/" .. tag)
      HTML.append_child(new_tags_elem, tag_link)
    end

    i = i + 1
  end
end

HTML.delete_element(old_tags_elem)
