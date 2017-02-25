--**************************
--**** Composer場景架構 ****
--**************************

--********* 引入各種函式庫 **********--
local widget = require("widget")
local composer = require("composer")
local scene = composer.newScene()

--********** 宣告各種變數 ***********--
local BackGround
local BackButton

--********** 定義各種函式 ***********--
local function TurnBackButtonPressed( event )

	if("began" == event.phase) then
		audio.play(ButtonPressedSound)
	end

	if("ended" == event.phase) then
		composer.gotoScene("mainpage")
	end
end

--************ Composer *************--
--場景還沒到螢幕上時，負責UI畫面繪製
function scene:create(event)
	local screenGroup = self.view

	--背景
	BackGround = display.newImageRect("Teach.png",750,1334)
	BackGround.x = 375
	BackGround.y = 667

	--返回按鈕
	BackButton = widget.newButton
	{
		width = 142,
		height = 150,
		defaultFile = "BackButton.png",
		overFile = "BackButtonPressed.png",
		onEvent = TurnBackButtonPressed
	}
	BackButton.x = display.contentWidth*7/8
	BackButton.y = display.contentHeight*13/14
end

--移除上個場景、播放音效與動畫，開始計時
function scene:show(event)
	if event.phase =="did" then
		
	end
end

--停止音樂、釋放音樂記憶體，停止移動的物件
function scene:hide( event )
	if event.phase =="will" then
		BackGround:removeSelf()
		BackButton:removeSelf()
		composer.removeScene("tutorialpage")
	end
end

--下個場景推上螢幕後，摧毀場景
function scene:destroy( event )
	if event.phase =="will" then

	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
return scene