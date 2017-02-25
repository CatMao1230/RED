--**************************
--**** Composer場景架構 ****
--**************************

--********* 引入各種函式庫 **********--
local widget = require("widget")
local composer = require("composer")
local scene = composer.newScene()
local Physics = require ("physics")
Physics.start()
Physics.setGravity(0,0)
--Physics.setDrawMode("hybrid")
math.randomseed(os.time())

--********** 宣告各種變數 ***********--
local PositionXNumber = 7
local PositionX = { 100 , 200 , 300 , 400 , 500 , 600 , 700}
local PositionYNumber = 13
local PositionY = { 100 , 200 , 300 , 400 , 500 , 600 , 700 , 800 , 900 , 1000 , 1100 , 1200 , 1300}
local ColorNumber = 12
local Color = { {250/255,161/255,167/255} , {244/255,6/255,107/255} , {189/255,0,38/255} , {253/255,140/255,60/255} , {233/255,199/255,82/255} , {165/255,111/255,61/255} , {142/255,198/255,51/255} , {129/255,202/255,218/255} , {50/255,78/255,120/255} , {107/255,80/255,114/255} , {136/255,136/255,136/255} , {64/255,59/255,53/255}}
--				粉色						 桃色						 紅 					  橘 						 黃  						土 							綠 						   藍色						  靛色		   				紫色				灰							黑
local VelocityXNumber = 6
local VelocityX = { -300 , -200 , -100 , 100 , 200 , 300}
local VelocityYNumber = 6
local VelocityY = { -300 , -200 , -100 , 100 , 200 , 300}
local BackGround
local TopBar
local BottomBar
local LeftBar
local RightBar
local CircleArray
local CircleNumber
local Circle
local Title
local ScoreScreen
local ScoreBoard
local PlayButton
local TutorialButton
local ButtonPressedSound = audio.loadSound("ButtonPressed.mp3")

CurrentHighScore = 0
HighScore = 0
Score = 0 

--********** 定義各種函式 ***********--
local function LoadRecord()
	local Path = system.pathForFile("record.data",system.DocumentsDirectory)
	local File = io.open(Path,"r")
	if File then
		local highScore = File:read("*a")
		io.close(File)
		return highScore
	else
		local File = io.open(Path,"w+")
		File:write("0")
		io.close(File)
		return "0"
	end
end


local function PlayButtonPressed( event )

	if("began" == event.phase) then
		audio.play(ButtonPressedSound)
	end

	if("ended" == event.phase) then
		composer.gotoScene("game")
	end
end

local function TutorialButtonPressed( event )

	if("began" == event.phase) then
		audio.play(ButtonPressedSound)
	end

	if("ended" == event.phase) then
		composer.gotoScene("tutorialpage")
	end
end

--************ Composer *************--
--場景還沒到螢幕上時，負責UI畫面繪製
function scene:create(event)
	local screenGroup = self.view

	--讀取檔案
	CurrentHighScore = tonumber(LoadRecord())
	HighScore = CurrentHighScore

	--背景
	--BackGround = display.newRect(375,667,750,1334)
	BackGround = display.newImageRect("Background.jpg",750,1334)
	BackGround.x = 375
	BackGround.y = 667

	--上方牆壁
	TopBar = display.newRect(display.contentWidth/2,0,display.contentWidth,1)
	TopBar:setFillColor(1,0,0)
	Physics.addBody(TopBar,"static")

	--下方牆壁
	BottomBar = display.newRect(display.contentWidth/2,display.contentHeight,display.contentWidth,1)
	BottomBar:setFillColor(1,0,0)
	Physics.addBody(BottomBar,"static")

	--左方牆壁
	LeftBar = display.newRect(0,display.contentHeight/2,1,display.contentHeight)
	LeftBar:setFillColor(1,0,0)
	Physics.addBody(LeftBar,"static")

	--右方牆壁
	RightBar = display.newRect(display.contentWidth,display.contentHeight/2,1,display.contentHeight)
	RightBar:setFillColor(1,0,0)
	Physics.addBody(RightBar,"static")
	
	--圓形
	CircleArray = display.newGroup()
	CircleNumber = math.random(3,5)
	for i = 1,CircleNumber do 
		
		Circle = display.newCircle(0,0,100)
		Circle:setFillColor(unpack(Color[math.random(ColorNumber)]))
		Circle.x = PositionX[math.random(PositionXNumber)]
		Circle.y = PositionY[math.random(PositionYNumber)]
		Physics.addBody(Circle,"dynamic",{radius = 100,friction = 0 ,bounce = 1})
		Circle.isFixedRotation = true
		Circle:setLinearVelocity(VelocityX[math.random(VelocityXNumber)],VelocityY[math.random(VelocityYNumber)])
		CircleArray:insert(Circle)
	end

	--標題
	Title = display.newImageRect("Title.png",328,173)
	Title.x = display.contentWidth/2
	Title.y = display.contentHeight / 5 + 20
	--Title = display.newText("RED",display.contentWidth/2,display.contentHeight/4,"DFPHuaZongW5-B5",140)
	--Title:setFillColor(1,0,0)

	--積分
	ScoreBoard = display.newImageRect("ScoreBoard.png",550,230)
	ScoreBoard.x = display.contentWidth/2
	ScoreBoard.y = display.contentHeight/2
	ScoreScreen = display.newText(HighScore,ScoreBoard.x+40,ScoreBoard.y,"04B_24_",100)
	ScoreScreen:setTextColor(1,1,1)

	--開始按鈕
	PlayButton = widget.newButton
	{
		width = 218,
		height = 230,
		defaultFile = "PlayButton.png",
		overFile = "PlayButtonPressed.png",
		onEvent = PlayButtonPressed
	}
	PlayButton.x = display.contentWidth/2 - 160
	PlayButton.y = display.contentHeight*3 / 4

	--教學按鈕
	TutorialButton = widget.newButton
	{
		width = 218,
		height = 230,
		defaultFile = "TeachButton.png",
		overFile = "TeachButtonPressed.png",
		onEvent = TutorialButtonPressed
	}
	TutorialButton.x = display.contentWidth/2 + 160
	TutorialButton.y = display.contentHeight*3 / 4

end

--移除上個場景、播放音效與動畫，開始計時
function scene:show(event)
	if event.phase =="did" then

	end
end

--停止音樂、釋放音樂記憶體，停止移動的物件
function scene:hide( event )
	if event.phase =="will" then

		for i = 1 , PositionXNumber do
			table.remove(PositionX,1)
		end

		for i = 1 , PositionYNumber do
			table.remove(PositionY,1)
		end

		for i = 1 , ColorNumber do
			table.remove(Color,1)
		end

		for i = 1 , VelocityXNumber do
			table.remove(VelocityX,1)
		end

		for i = 1 , VelocityYNumber do
			table.remove(VelocityY,1)
		end

		BackGround:removeSelf()
		TopBar:removeSelf()
 		BottomBar:removeSelf()
 		LeftBar:removeSelf()
 		RightBar:removeSelf()

 		for i = 1 , CircleNumber do 
 			Physics.removeBody(CircleArray[1])
 			CircleArray[1]:removeSelf()
 		end
 		CircleArray:removeSelf()

		Title:removeSelf()
		ScoreScreen:removeSelf()
		PlayButton:removeSelf()
		TutorialButton:removeSelf()
		audio.dispose(ButtonPressedSound)

		composer.removeScene("mainpage")
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