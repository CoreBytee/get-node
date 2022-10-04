local Request = require("coro-http").request
local FS = require("fs")
local AppData = TypeWriter.ApplicationData .. "/Node/"

local function StartsWith(Str, Start)
    return (Str:sub(1, #Start) == Start)
end

return function (Location, NoExtract)
    if Location == nil then
        Location = AppData
    end
    FS.mkdirSync(Location)

    if FS.existsSync(Location .. "node.zip") == false then
        local Version = Import("ga.corebyte.get-node.GetTag")().version
        local DownloadUrl = Import("ga.corebyte.get-node.GetDownloadUrl")(Version)
        p(DownloadUrl)
        if DownloadUrl == false then
            return false
        end
        local Request, Body = Request(
            "GET",
            DownloadUrl
        )
        FS.writeFileSync(Location .. "/node.zip", Body)
        FS.writeFileSync(Location .. "/node.version", Version)
        
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
        if ({win32 = true})[TypeWriter.Os] ~= true then
            local Resources = TypeWriter.LoadedPackages["Get-Node"].Resources
            FS.writeFileSync(Location .. "/node", Resources["/scripts/node"])
            FS.writeFileSync(Location .. "/npm", Resources["/scripts/npm"])
            os.execute("chmod +x " .. Location .. "/node")
            os.execute("chmod +x " .. Location .. "/npm")
            p("is linux")
        end
    end
    process.env.PATH = process.env.PATH .. ({win32 = ";", darwin = ":"})[TypeWriter.Os] .. Location
    return Location, FS.readFileSync(Location .. "/node.version")
end