return function ()
    local Request, Body = require("coro-http").request(
        "GET",
        "https://nodejs.org/dist/index.json"
    )
    local Versions = require("json").decode(Body)
    local LtsVersions = {}
    for Index, Version in pairs(Versions) do
        if Version.lts then
            table.insert(LtsVersions, Version)
        end
    end
    return LtsVersions[1]
end