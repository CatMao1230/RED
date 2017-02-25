--**************************
--**** Composer場景架構 ****
--**************************

--********* 引入各種函式庫 **********--
local widget = require("widget")
local composer = require("composer")
local scene = composer.newScene()

--********** 宣告各種變數 ***********--
local BackGround
local Title
local HighScoreText
local ScoreText
local BackButton
local ButtonPressedSound = audio.loadSound("ButtonPressed.mp3")


--********** 定義各種函式 ***********--
local function SaveRecord (HighScore)
	print ("saverecord")
	local Value = HighScore

	local Path = system.pathForFile("record.data",system.DocumentsDirectory)

	local File = io.open(Path,"w+")
	if File then
		File:write(Value)
		io.close(File)
	end	
end


local function BackButtonPressed( event )

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

	--存檔
	if (HighScore > CurrentHighScore) then
		SaveRecord(HighScore)
	end
	--背景
	--BackGround = display.newRect(375,667,750,1334)
	BackGround = display.newImageRect("Background.jpg",750,1334)
	BackGround.x = 375
	BackGround.y = 667

	--標題
	Title = display.newText("Game Over!",display.contentWidth/2,display.contentHeight/4,"04B_24_",140)
	Title:setFillColor(0,0,0)

	--最高分數
	HighScoreText = display.newText("BestScore: "..HighScore,display.contentWidth/2,display.contentHeight/2-20,"04B_24_",100)
	HighScoreText:setFillColor(0,0,0)

	--分數
	ScoreText = display.newText("Score: "..Score,display.contentWidth/2,display.contentHeight/2+80,"04B_24_",100)
	ScoreText:setFillColor(0,0,0)

	--退出按鈕
	BackButton = widget.newButton
	{
		width = 218,
		height = 230,
		defaultFile = "BackButton.png",
		overFile = "BackButtonPressed.png",
		onEvent = BackButtonPressed
	}
	BackButton.x = display.contentWidth/2
	BackButton.y = display.contentHeight*3/4+100

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
		Title:removeSelf()
		HighScoreText:removeSelf()
		ScoreText:removeSelf()
		BackButton:removeSelf()
		audio.dispose(ButtonPressedSound)
		composer.removeScene("endpage")
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