ItemSense = LibStub("AceAddon-3.0"):NewAddon("ItemSense", "AceConsole-3.0", "AceEvent-3.0")
AceGUI = LibStub("AceGUI-3.0")

local itemBank = 1

local itemsWaitedOn = 0

function ItemSense:OnInitialize()
  -- Code that you want to run when the addon is first loaded goes here.
end

function ItemSense:OnEnable()
    -- Called when the addon is enabled
end

function ItemSense:OnDisable()
    -- Called when the addon is disabled
end

local textStore

function RandomItem()
    local choice = math.floor(math.random() * (table.getn(ItemSenseDb) - 2) + 2)

    local haveCached = (select(2,GetItemInfo(ItemSenseDb[choice]["id"])))
    if haveCached then
        SendChatMessage(haveCached,"PARTY")
    else
        itemsWaitedOn = itemsWaitedOn + 1
        print("Querying Item info will print to PARTY momentarily")
    end
    --itemBank = itemBank + 1
    --itemBank = link
end

function ReturnItemName(index)
    local item = ItemSenseDb[index]["value"]
    --local i,j = string.find(item, ',')
    return item--string.sub(item,1,i-1)
end

function Get50MatchingItems(text)
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
        itemList = itemList..'\n'..ReturnItemName(returnIndexes[n])
    end
    itemList = string.sub(itemList, 2)
    return itemList
end

local frame = AceGUI:Create("Frame")
frame:SetTitle("Search for an item in the textbox")
frame:SetHeight(300)
frame:SetWidth(350)
--frame:SetStatusText(itemBank)
frame:SetCallback("OnClose", function(widget) widget:Hide() end)
frame:SetLayout("Flow")
frame:Hide()

function ItemSense:ItemInfoReceived(event, id)
    if itemsWaitedOn > 0 then
        SendChatMessage((select(2,GetItemInfo(id))), "PARTY")
        itemsWaitedOn = itemsWaitedOn - 1
    end
end
ItemSense:RegisterEvent('GET_ITEM_INFO_RECEIVED', 'ItemInfoReceived')

local editbox = AceGUI:Create("EditBox")
local multiEdit = AceGUI:Create("MultiLineEditBox")

editbox:SetLabel("Insert text:")
editbox:SetWidth(200)
editbox:SetCallback("OnEnterPressed", function(widget, event, text) textStore = text end)
editbox:SetCallback("OnTextChanged", function(widget, event, text) multiEdit:SetText(Get50MatchingItems(text)) end)
frame:AddChild(editbox)



-- local button = AceGUI:Create("Button")
-- button:SetText("Click Me!")
-- button:SetWidth(200)
-- button:SetCallback("OnClick", function() RandomItem() end)
-- frame:AddChild(button)

local itemList = ''
for n=1, 10 do
    itemList = itemList..'\n'..ReturnItemName(n)
end
itemList = string.sub(itemList, 2)
multiEdit:SetNumLines(10)
multiEdit:SetDisabled(true)
multiEdit:DisableButton(true)
multiEdit:SetText(itemList)
multiEdit:SetWidth(500)
frame:AddChild(multiEdit)


SLASH_ITEMSENSE1 = "/is"
SlashCmdList["ITEMSENSE"] = function(msg)
    msg = string.trim(string.lower(msg))
    if( string.match(msg, "[a-z/W]+" ) ) then 
        for idx, word in ipairs(ItemSenseDb) do
            if string.find(string.lower(ItemSenseDb[idx]["value"]), msg) then 
                local haveCached = (select(2,GetItemInfo(ItemSenseDb[idx]["id"])))
                if haveCached then
                    SendChatMessage(haveCached,"PARTY")
                else
                    itemsWaitedOn = itemsWaitedOn + 1
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