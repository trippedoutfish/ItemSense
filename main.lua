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
    --print(choice)
    local i,j = string.find(ItemSenseDb[choice], ',')
    --print(ItemSenseDb[choice]: sub(i+1))
    local haveCached = (select(2,GetItemInfo(ItemSenseDb[choice]: sub(i+1))))
    if haveCached then
        SendChatMessage(haveCached,"PARTY")
    else
        itemsWaitedOn = itemsWaitedOn + 1
        print("Querying Item info will print to PARTY momentarily")
    end
    --itemBank = itemBank + 1
    --itemBank = link
end

local frame = AceGUI:Create("Frame")
frame:SetTitle("Example Frame")
frame:SetStatusText(itemBank)
frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
frame:SetLayout("Flow")

function ItemSense:ItemInfoReceived(event, id)
    if itemsWaitedOn > 0 then
        SendChatMessage((select(2,GetItemInfo(id))), "PARTY")
        itemsWaitedOn = itemsWaitedOn - 1
    end
end
ItemSense:RegisterEvent('GET_ITEM_INFO_RECEIVED', 'ItemInfoReceived')

local editbox = AceGUI:Create("EditBox")
editbox:SetLabel("Insert text:")
editbox:SetWidth(200)
editbox:SetCallback("OnEnterPressed", function(widget, event, text) textStore = text end)
frame:AddChild(editbox)

local button = AceGUI:Create("Button")
button:SetText("Click Me!")
button:SetWidth(200)
button:SetCallback("OnClick", function() RandomItem() end)
frame:AddChild(button)