local util = require("nvim-settings.util")
local Schema = require("nvim-settings.schema")

local M = {}

function M.docs()
  local schemas = require("nvim-settings.build.schemas").index()
  local keys = vim.tbl_keys(schemas)
  table.sort(keys)
  local lines = {}

  for _, name in ipairs(keys) do
    local schema = schemas[name]
    local url = schema.package_url
    if url:find("githubusercontent") then
      url = url
        :gsub("raw%.githubusercontent", "github")
        :gsub("/master/", "/tree/master/", 1)
        :gsub("/main/", "/tree/main/", 1)
    end
    table.insert(lines, ("- [x] [%s](%s)"):format(name, url))
  end
  local str = "<!-- GENERATED -->\n" .. table.concat(lines, "\n")
  local md = util.read_file("README.md")
  md = md:gsub("<!%-%- GENERATED %-%->.*", str) .. "\n"
  util.write_file("README.md", md)
end

function M.build()
  require("nvim-settings.build.schemas").build()
  require("nvim-settings.build.annotations").build()
  M.docs()
end

M.build()

return M
