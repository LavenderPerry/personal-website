-- Separates the page content from the title,
-- by putting the rest of the content in its own div
-- and putting an hr element between the title and content div.
--
-- Sample configuration (also shows defaults):
-- [widgets.separate-content]
--   widget = "separate-content"
--   selector = "main"
--   title_selector = "h1"
--   content_div_id = "post-content"
--
-- Author: Lavender Perry
-- License: MIT

Plugin.require_version("4.10") -- May work on older versions, but only tested on this

local selector = config["selector"] or "main"
local title_selector = config["title_selector"] or "h1"
local content_div_id = config["content_div_id"] or "post-content"

local selected = HTML.select_one(page, selector)
if not selected then
  Plugin.fail('element with selector "' .. selector .. '" not found.')
end

local title = HTML.select_one(page, title_selector)
if not title then
  Plugin.fail('title with selector "' .. title .. '" not found.')
end

local content_div = HTML.create_element("div")
HTML.set_attribute(content_div, "id", content_div_id)

local selected_elems = HTML.children(selected)
local i = 1
while selected_elems[i] do
  local elem = selected_elems[i]
  if elem ~= title then
    HTML.append_child(content_div, elem)
  end

  i = i + 1
end

HTML.insert_after(title, content_div)
HTML.insert_after(title, HTML.create_element("hr"))
