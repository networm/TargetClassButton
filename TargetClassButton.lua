-- TargetClassButton by 狂飙@cwdg(zzjbcn@yahoo.com.cn) 20120119
-- 添加到暴雪目标头像上的按钮，左键查看目标装备、右键与目标交易、中键密语、鼠标按键4跟随、鼠标按键5比较成就、到可观察装备距离时职业图标由灰白变彩色。

local targeticon = CreateFrame("Button", "TargetClass", TargetFrame)
targeticon:Hide()
targeticon:SetWidth(32)
targeticon:SetHeight(32)
targeticon:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 119, 3)
targeticon:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
local bg = targeticon:CreateTexture("TargetClassBackground", "BACKGROUND")
bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
bg:SetWidth(20)
bg:SetHeight(20)
bg:SetPoint("CENTER")
bg:SetVertexColor(0, 0, 0, 0.7)
local icon = targeticon:CreateTexture("TargetClassIcon", "ARTWORK")
icon:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
icon:SetWidth(20)
icon:SetHeight(20)
icon:SetPoint("CENTER")
local lay = targeticon:CreateTexture("TargetClassBorder", "OVERLAY")
lay:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
lay:SetWidth(54)
lay:SetHeight(54)
lay:SetPoint("CENTER", 11, -12)
RaiseFrameLevel(targeticon)

targeticon:SetScript("OnUpdate", function(self)
	if (not UnitCanAttack("player","target") and UnitIsPlayer("target")) then
		targeticon:Enable()
	--	TargetClassIcon:SetDesaturated(false)
		SetDesaturation(TargetClassIcon, false)
	else
		targeticon:Disable()
	--	TargetClassIcon:SetDesaturated(true)
		SetDesaturation(TargetClassIcon, true)
	end
end)

local havedown = false

local function TargetClassIconDown()
	local point, relativeTo, relativePoint, offsetX, offsetY = TargetClassIcon:GetPoint()
	TargetClassIcon:SetPoint(point, relativeTo, relativePoint, offsetX+1, offsetY-1)
	return true
end

-- targeticon:RegisterForClicks("AnyDown")
targeticon:SetScript("OnMouseDown", function(self, button)
	if (not UnitCanAttack("player","target") and UnitIsPlayer("target")) then
		if button == "LeftButton" then
				havedown = TargetClassIconDown()
				InspectUnit("target")
		elseif button == "RightButton" then
			if CheckInteractDistance("target",2) then
				havedown = TargetClassIconDown()
				InitiateTrade("target")
			end
		elseif button == "MiddleButton" then

				havedown = TargetClassIconDown()
				local server = nil;
				local name, server = UnitName("target");
				local fullname = name;
				if ( server and (not "target" or not UnitIsSameServer("player", "target")) ) then
					fullname = name.."-"..server;
				end
				ChatFrame_SendTell(fullname)
			--	StartDuel("target")

		elseif button == "Button4" then
			if CheckInteractDistance("target",4) then
				havedown = TargetClassIconDown()
				FollowUnit("target");
			end
		else
			if CheckInteractDistance("target",1) then
				havedown = TargetClassIconDown()
				InspectAchievements("target")
			end
		end
	end
end)

local function TargetClassIconUp()
	local point, relativeTo, relativePoint, offsetX, offsetY = TargetClassIcon:GetPoint()
	TargetClassIcon:SetPoint(point, relativeTo, relativePoint, offsetX-1, offsetY+1)
	return false
end

-- targeticon:RegisterForClicks("AnyUp")
targeticon:SetScript("OnMouseUp", function(self)
	if havedown then
		havedown = TargetClassIconUp()
	end
end)

hooksecurefunc("TargetFrame_Update", function()
	if UnitIsPlayer("target") then
	--	local _, class = UnitClass("target")
	--	local coord = CLASS_BUTTONS[class]
	--	TargetClassIcon:SetTexCoord(coord[1], coord[2], coord[3], coord[4])

		local coord = CLASS_BUTTONS[select(2, UnitClass("target"))]
		TargetClassIcon:SetTexCoord(unpack(coord))
		targeticon:Show()
	else
		targeticon:Hide()
	end
end)

