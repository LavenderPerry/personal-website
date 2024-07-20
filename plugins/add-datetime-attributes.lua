-- Adds datetime attributes to time elements.
-- Assumes time element content has the relevanttime in ISO format
--
-- Sample configuration:
-- [widgets.add-datetime-attributes]
--   widget = "add-datetime-attributes"
--
-- Author: Lavender Perry
-- License: MIT

function add_datetime_attribute(elem)
  HTML.set_attribute(elem, "datetime", Date.reformat(HTML.inner_text(elem),
                                                     { "%F %H:%M:%S %z" },
                                                     "%FT%H:%M:%S%:z"))
end

Table.iter_values(add_datetime_attribute, HTML.select(page, "time"))
