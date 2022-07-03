local Request = require("coro-http").request
local BaseUrl = "https://nodejs.org/dist/latest/"

local Names =  {
    ["win32"] = "node-%s-win-%s.zip",
    ["linux"] = "node-%s-linux-%s.tar.gz",
    ["darwin"] = "node-%s-darwin-%s.tar.gz"
}

local function GetVersion()
    local Request, Body = Request(
        "GET",
        BaseUrl .. "SHASUMS256.txt"
    )
    local Version = Body:split("\n")[1]:split("  ")[2]:split("-")[2]
    return Version
end

return function ()
    if Names[TypeWriter.Os] == nil then
        return false
    end
    return BaseUrl .. string.format(
        Names[TypeWriter.Os],
        GetVersion(),
        require("jit").arch
    )
end