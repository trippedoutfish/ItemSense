ItemSense = LibStub("AceAddon-3.0"):NewAddon("ItemSense", "AceConsole-3.0")
AceGUI = LibStub("AceGUI-3.0")

local itemBank = 1

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

local frame = AceGUI:Create("Frame")
frame:SetTitle("Example Frame")
frame:SetStatusText(itemBank)
frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
frame:SetLayout("Flow")

local editbox = AceGUI:Create("EditBox")
editbox:SetLabel("Insert text:")
editbox:SetWidth(200)
editbox:SetCallback("OnEnterPressed", function(widget, event, text) textStore = text end)
frame:AddChild(editbox)

local button = AceGUI:Create("Button")
button:SetText("Click Me!")
button:SetWidth(200)
button:SetCallback("OnClick", function() print(ItemSenseDb[itemBank]) end)
frame:AddChild(button)