local Request = require("coro-http").request
local FS = require("fs")
local AppData = TypeWriter.Folder .. "/ApplicationData/Node/"

local function StartsWith(Str, Start)
    return (Str:sub(1, #Start) == Start)
end

return function (Location, NoExtract)
    if Location == nil then
        Location = AppData
    end
    FS.mkdirSync(Location)

    if FS.existsSync(Location .. "node.zip") == false then
        local DownloadUrl = Import("ga.corebyte.get-node.GetDownloadUrl")()
        if DownloadUrl == false then
            return false
        end
        local Request, Body = Request(
            "GET",
            DownloadUrl
        )
        FS.writeFileSync(Location .. "node.zip", Body)
    end
    
    if NoExtract == true then
        return Location
    end

    if FS.existsSync(Location .. "README.md") == false then
        Import("ga.corebyte.get-node.UnZip")(Location .. "node.zip", Location)
        local File
        for Index, FileName in pairs(FS.readdirSync(Location)) do
            if StartsWith(FileName, "node-") then
                File = FileName
            end
        end
        for Index, FileName in pairs(FS.readdirSync(Location .. File)) do
            FS.renameSync(Location .. File .. "/" .. FileName, Location .. FileName)
        end
        FS.rmdirSync(Location .. File)
    end
    return Location
end