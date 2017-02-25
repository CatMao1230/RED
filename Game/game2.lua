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

--********** 宣告各種變數 ***********--
local ScoreScreen
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
local TextNumber = 6
local Text = { "粉" , "桃" , "紅" , "橘" , "黃" , "土" , "綠" , "藍" , "靛" , "紫" , "灰" , "黑"}
local AnswerNumber
local BufferNumber

local BackGround
local Timer
local TimeText
local TimeCounter
local TopBar
local BottomBar
local LeftBar
local RightBar
local Title
local TitleText

local ButtonArray
local ButtonNumber = 3
local Circle
local Lable
local Button
local CorrectButtonSound = audio.loadSound("CorrectSound.wav")
local WrongButtonSound = audio.loadSound("WrongSound.wav")
local nextMove = function()
    transition.to(TimeText,{time=500,xScale = 1,yScale = 1})
end

--********** 定義各種函式 ***********--

--正確按鈕事件
local function CorrectButtonTouch( event )
	if("began" == event.phase) then
		audio.play(CorrectButtonSound)
	end
	if("ended" == event.phase) then
		Score  = Score + 1 
		print("pressed")
		print(Score)
		composer.gotoScene("game")
	end
end

--錯誤按鈕事件
local function WrongButtonTouch( event )
	if("began" == event.phase) then
		audio.play(WrongButtonSound)
	end
	if("ended" == event.phase) then
		print("pressed")
		composer.gotoScene("endpage")
	end
end

--時間事件
local function TimerCounter( event )
	print("gameCounter")
    Timer = Timer - 1
    TimeText.text = Timer
    transition.to(TimeText,{time=500,xScale = 1.2,yScale = 1.2,onComplete = nextMove})
    if Timer == 0 then
    	print("Time out")
    	composer.gotoScene("endpage")
    end
end

--************ Composer *************--
--場景還沒到螢幕上時，負責UI畫面繪製
function scene:create(event)
	print("create")
	local screenGroup = self.view
	
	if(Score > HighScore) then
		HighScore = Score
	end

	--背景
	--BackGround = display.newRect(375,667,750,1334)
	BackGround = display.newImageRect("Background.jpg",750,1334)
	BackGround.x = 375
	BackGround.y = 667

	--積分
	ScoreScreen = display.newText("BestScore: "..HighScore.." Score: "..Score,display.contentWidth/2,display.contentHeight/20,"04B_24_",60)
	ScoreScreen:setTextColor(0,0,0)

	
	if Score >= 25 then
		ButtonNumber = 5
		Timer = 2
	elseif Score >= 20 and Score < 25  then
		ButtonNumber = 4
		Timer = 2
	elseif Score >= 15 and Score < 20 then
		ButtonNumber = 4
		Timer = 3
	elseif Score >= 10 and Score < 15  then
		Timer = 3
	elseif Score < 10 then
		Timer = 5
	end	
	
	--計時器文字
	TimeText = display.newText(Timer,display.contentWidth/2,display.contentHeight/4,"04B_24_",180)
	TimeText:setTextColor(0,0,0)
    transition.to(TimeText,{time=500,xScale = 1.2,yScale = 1.2,onComplete = nextMove})
	TimeCounter = timer.performWithDelay( 1000, TimerCounter,Timer)

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

	AnswerNumber = math.random(TextNumber)

	--題目圖形
	Title = display.newRoundedRect(display.contentWidth/2,display.contentHeight/2,250,250,20)
	Title:setFillColor(unpack(Color[math.random(ColorNumber)]))
	Physics.addBody(Title,"static")

	--題目文字
	TitleText = display.newText(Text[AnswerNumber],display.contentWidth/2,display.contentHeight/2,"DFPHuaZongW5-B5",140)
	TitleText:setFillColor(1,1,1)

	ButtonArray = display.newGroup()
	for i = 1 , ButtonNumber do 

		--圓形
		if i == 1 then
			Circle = display.newCircle(0,0,100)
			Circle:setFillColor(unpack(Color[AnswerNumber]))
			table.remove(Color,AnswerNumber)
			ColorNumber = ColorNumber - 1
		else
			BufferNumber = math.random(ColorNumber)
			Circle = display.newCircle(0,0,100)
			Circle:setFillColor(unpack(Color[BufferNumber]))
			table.remove(Color,BufferNumber)
			ColorNumber = ColorNumber - 1
		end
		

		--文字
		BufferNumber = math.random(TextNumber)
		Lable = display.newText(Text[BufferNumber],0,0,"DFPHuaZongW5-B5",100)
		Lable:setFillColor(1,1,1)
		table.remove(Text,BufferNumber)
		TextNumber = TextNumber - 1

		--按鈕
		Button = display.newGroup()
		Button:insert(Circle)
		Button:insert(Lable)
		Button.x = PositionX[math.random(PositionXNumber)]
		Button.y = PositionY[math.random(PositionYNumber)]
		Physics.addBody(Button,"dynamic",{radius = 100,friction = 0 ,bounce = 1})
		Button.isFixedRotation = true
		Button:setLinearVelocity(VelocityX[math.random(VelocityXNumber)],VelocityY[math.random(VelocityYNumber)])
		if i == 1 then
			Button:addEventListener("touch",CorrectButtonTouch)
		else
			Button:addEventListener("touch",WrongButtonTouch)
		end
		ButtonArray:insert(Button)
	end


end

--移除上個場景、播放音效與動畫，開始計時
function scene:show(event)
	if event.phase =="did" then
		print("show")

	end
end

--停止音樂、釋放音樂記憶體，停止移動的物件
function scene:hide( event )
	if event.phase =="will" then
		print("hide")
		
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

		for i = 1 , TextNumber do
			table.remove(Text,1)
		end

		BackGround:removeSelf()
		ScoreScreen:removeSelf()
		Timer=0
		TimeText:removeSelf()
		timer.cancel(TimeCounter)
		TopBar:removeSelf()
 		BottomBar:removeSelf()
 		LeftBar:removeSelf()
 		RightBar:removeSelf()
 		Title:removeSelf()
 		TitleText:removeSelf()

 		for i = 1 , ButtonNumber do 
 			ButtonArray[1][1]:removeSelf()
 			ButtonArray[1][1]:removeSelf()
 			Physics.removeBody(ButtonArray[1])
 			if i == 1 then
 				ButtonArray[1]:removeEventListener("touch",CorrectButtonTouch)
 			else
 				ButtonArray[1]:removeEventListener("touch",WrongButtonTouch)
 			end
 			ButtonArray[1]:removeSelf()
 		end
 		ButtonArray:removeSelf()
 		
 		Physics.stop()
 		audio.dispose(CorrectButtonSound)
 		audio.dispose(WrongSound)
		composer.removeScene("game2")
		
	end
end

--下個場景推上螢幕後，摧毀場景
function scene:destroy( event )
	if event.phase =="will" then
		print("destroy")
	end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
return scene