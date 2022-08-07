local Request = require("coro-http").request
local BaseUrl = "https://nodejs.org/dist/"

local Names =  {
    ["win32"] = "node-%s-win-%s.zip",
    ["linux"] = "node-%s-linux-%s.tar.gz",
    ["darwin"] = "node-%s-darwin-%s.tar.gz"
}

return function (Version)
    if Names[TypeWriter.Os] == nil then
        return false
    end
    return BaseUrl .. Version .. "/" .. string.format(
        Names[TypeWriter.Os],
        Version,
        require("jit").arch
    )
end