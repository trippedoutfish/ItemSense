-- Here we declare the libraries that we use
ItemSense = LibStub("AceAddon-3.0"):NewAddon("ItemSense", "AceConsole-3.0", "AceEvent-3.0")
AceGUI = LibStub("AceGUI-3.0")

-- Keep a count of items we are waiting on to make sure that we don't print items from other addon calls
local itemsWaitedOn = 0

-- Currently Unused Initialization Functions
function ItemSense:OnInitialize()
-- Code that you want to run when the addon is first loaded goes here.
end
function ItemSense:OnEnable()
-- Called when the addon is enabled
end
function ItemSense:OnDisable()
-- Called when the addon is disabled
end

-- This function will return the item link for a given id
-- Use the select function to return just the second argument back which is the item link
-- Returns nil if item not cached
function GetItemLink(id)
    return (select(2,GetItemInfo(id)))
end
    
-- This function will choose a random item and attempt to print it to /s
function RandomItem()
    local choice = math.floor(math.random() * (table.getn(ItemSenseDb) - 2) + 2)
    local haveCached = GetItemLink(ItemSenseDb[choice]["id"])
    if haveCached then
        print(haveCached)
    else
        itemsWaitedOn = itemsWaitedOn + 1
        print("Querying Item info will print to CONSOLE momentarily")
    end
end
        
-- This function returns the first 10 items that match the specified pattern
-- Keep in mind items are stored in a highest id first order (so that newer items are easiest to find)
function Get10MatchingItems(text)
    text = string.lower(text)
    local foundWords = 0
    local returnIndexes = {}
    for idx, word in ipairs(ItemSenseDb) do
        if foundWords == 10 then
            break
        end
        if string.find(string.lower(ItemSenseDb[idx]["value"]), text) then 
            table.insert(returnIndexes, idx)
            foundWords = foundWords + 1
        end
    end
    local itemList = ''
    for n=1, foundWords do
        itemList = itemList..'\n'..ItemSenseDb[returnIndexes[n]]["value"]
    end
    itemList = string.sub(itemList, 2)
    return itemList
end

-- Base UI Frame displayed when using /is
local frame = AceGUI:Create("Frame")
frame:SetTitle("Search for an item in the textbox")
frame:SetHeight(300)
frame:SetWidth(350)
frame:SetCallback("OnClose", function(widget) widget:Hide() end)
frame:SetLayout("Flow")
frame:Hide()

-- Callback function for when we did not have an item cached
function ItemSense:ItemInfoReceived(event, id)
    if itemsWaitedOn > 0 then
        print(GetItemLink(id))
        itemsWaitedOn = itemsWaitedOn - 1
    end
end
ItemSense:RegisterEvent('GET_ITEM_INFO_RECEIVED', 'ItemInfoReceived')

-- Setting up searchable edit field
local editbox = AceGUI:Create("EditBox")
editbox:SetLabel("Insert text:")
editbox:SetWidth(200)
editbox:SetCallback("OnTextChanged", function(widget, event, text) multiEdit:SetText(Get50MatchingItems(text)) end)
frame:AddChild(editbox)

-- Setting up returned top 10 list of matching items
local multiEdit = AceGUI:Create("MultiLineEditBox")
local itemList = ''
for n=1, 10 do
    itemList = itemList..'\n'..ReturnItemName(n)
end
itemList = string.sub(itemList, 2)
multiEdit:SetNumLines(10)
multiEdit:SetDisabled(true)
multiEdit:DisableButton(true)
multiEdit:SetText(itemList)
multiEdit:SetWidth(350)
frame:AddChild(multiEdit)

-- Not sure why this works like this, but this is how I understand slash commands to work
SLASH_ITEMSENSE1 = "/is"
-- This function is called when any of the above slash patterns are entered
SlashCmdList["ITEMSENSE"] = function(msg)
    msg = string.trim(string.lower(msg))
    if( string.match(msg, "[a-z/W]+" ) ) then 
        for idx, word in ipairs(ItemSenseDb) do
            if string.find(string.lower(ItemSenseDb[idx]["value"]), msg) then 
                local haveCached = GetItemLink(ItemSenseDb[idx]["id"])
                if haveCached then
                    print(haveCached)
                else
                    itemsWaitedOn = itemsWaitedOn + 1
                    print("Querying Item info will print to CONSOLE momentarily")
                end
                return
            end
        end
    else
        if( frame:IsVisible() ) then
            frame:Hide()
        else
            frame:Show()
        end
    end
end
    
        

-------------------- Unused/Deprecated Code --------------------

-- Delay time between receiving a chat call and processing
local chatDelay = 0.25
local lastCall = 0
            
            
            


-- Given an index this will return the name of an item
--[[ Currently rather simple, but could be useful if name 
    resolution becomes more difficult
function ReturnItemName(index)
local item = ItemSenseDb[index]["value"]
return item
end
--]]