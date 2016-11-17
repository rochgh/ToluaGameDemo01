--@author roc_hgh

local Chess = import(".Chess");
local ChessData = import(".ChessData");
local Constant = import(".Constant");
local Utils = import(".Utils");

local ChessBoard = class("ChessBoard");

ChessBoard.TEST_DATA = 
{
-- {2,2,2,2,2,2,2,2},
-- {2,2,2,2,2,2,2,2},
-- {2,2,2,2,2,2,2,2},
-- {2,2,2,2,2,2,2,2},
-- {2,2,2,2,2,2,2,2},
-- {2,2,2,2,2,2,2,2},
-- {2,2,2,2,2,2,2,2},
-- {2,2,2,2,2,2,2,2}

--	{4,4,0,1,4,3,4,3},
--	{2,2,2,0,4,3,4,3},
--	{3,1,2,1,3,4,3,2},
--	{1,0,2,4,2,3,2,3},
--	{1,1,1,0,1,3,1,3},
--	{4,2,4,3,2,3,2,3},
--	{2,4,2,2,4,3,4,3},
--	{4,2,4,1,1,3,1,3}
	
-- {32,32,32,32, 4, 2, 2, 2},
-- {32,32,32,32, 3, 6,12, 5},
-- {32,32,32,32, 4, 5,12, 4},
-- {32,32,32,32, 5, 2, 2, 6},
-- {32,32,32,32,12,10, 9, 4},
-- {32,32,32,32,32,32,32,32},
-- {32,32,32,32,32,32,32,32},
-- {32,32,32,32,32,32,32,32}
	
--	{23, 2, 2, 5, 3, 3, 2, 2},
--	{ 1, 2, 3, 9, 5, 5, 1, 6},
--	{ 1, 1, 6,22, 1, 1, 2, 1},
--	{ 2, 1, 2, 2, 3, 3, 4, 4},
--	{ 5, 5, 6, 6, 1, 1, 2, 2},
--	{ 1, 1, 2, 1, 2, 2, 4, 4},
--	{ 5,88, 6, 6, 1, 3, 2, 3},
--	{ 1, 1, 3, 3, 2, 3, 88, 4}

	{5,5,6,5,1,1,2,2},
	{1,2,3,4,5,6,3,4},
	{5,5,6,6,1,1,2,2},
	{1,1,2,2,3,3,4,4},
	{5,5,6,6,1,1,2,2},
	{1,1,2,2,6,3,4,4},
	{5,5,6,6,1,6,2,2},
	{2,1,2,2,3,2,4,4}
}

function ChessBoard:ctor()
	print("ChessBoard:ctor()")



	self.isTouched = false;
	self.operatorBoard = false;
	self.preRandom = 0;




	-- 创建棋盘ChessBoard对象
	self.board = UnityEngine.GameObject("ChessBoard");
	
	-- 设置为layer8
	self.board.layer = 8;

	-- 添加board用camera
	-- self.camera = UnityEngine.GameObject.Instantiate(UnityEngine.Resources.Load("Prefab/ChessCamera"));

	-- 初始化棋子
	self.chessList = {};-- 棋子

	for col = 1, Constant.GRID_COLS do
		self.chessList[col] = {};
	 	for row = 1, Constant.GRID_ROWS do
	 		local chess = Chess.new();
	 		chess.sprite.transform.parent = self.board.transform;
	 		local tempType = ChessBoard.TEST_DATA[row][col];
	 		chess:reset(ChessData.new(tempType,col,row,nil));
	 		

	 		self.chessList[col][row] = chess;
	 	end
	end

	-- 居中显示
	local centerX = -480 / 2 / 100 + (480-Constant.CHESS_WIDTH*Constant.GRID_COLS)/2/100;
	local centerY = -800 / 2 / 100 + (800-Constant.CHESS_HEIGHT*Constant.GRID_ROWS)/2/100;
	self.board.transform.position = UnityEngine.Vector2(centerX, centerY);

	-- -- 添加遮罩
	-- UnityEngine.GameObject.Instantiate(UnityEngine.Resources.Load("Prefab/ChessMask"));

	-- -- 设置遮罩位置
	-- self.mask = UnityEngine.GameObject.Find("QuadMask");
	-- self.mask.transform.position = Vector3.New(0,(Constant.CHESS_HEIGHT*Constant.GRID_ROWS/2)/100+1.5,-1);

	--============= 触摸 =============
	self.isTouched = false;
	self.lastMousePosition = nil;

	-- 坐标显示文本
	-- self.debugText = UnityEngine.GameObject.Find("debugText"):GetComponent(typeof(UnityEngine.UI.Text));
	-- self.debugText.text = "0,0";

	-- 进入主update
	UpdateBeat:Add(ChessBoard.update, self);

	self.operatorBoard = true;
end

function ChessBoard:update()
	-- print("sssss")
	-- print(UnityEngine.Input)
	-- if UnityEngine.Input.GetButtonDown("Fire1") then
	-- 	print("ssss")
	-- end

	local posX,posY;

	local mousePosition = UnityEngine.Camera.main:ScreenToWorldPoint(UnityEngine.Input.mousePosition);

	posX = string.format("%0.0f", mousePosition.x*100);
	posY = string.format("%0.0f", mousePosition.y*100);

	-- self.debugText.text = posX..","..posY;

	if self.operatorBoard == false then
		return false;
	end

	if UnityEngine.Input.GetMouseButtonDown(0) then
		-- print("MouseDown");
		self.isTouched = true;

		self.startPoint = Vector2.New(mousePosition.x,mousePosition.y);

		self:verificaEdge(self.startPoint.x, self.startPoint.y);

		self.firstGrid = Vector2.New(self.curCol, self.curRow);

		self.curChess = self.chessList[self.curCol][self.curRow];
		self.curChess:showLight(true);
	end

	if UnityEngine.Input.GetMouseButtonUp(0) then
		-- print("MouseUp");
		self.isTouched = false;

		if self.curChess then
			self.curChess:showLight(false);
			self.curChess = nil;
		end

		-- self.lastMousePosition = Vector3.zero;
	end

	-- touchMove
	if self.isTouched then

		local x1 = (mousePosition.x - self.startPoint.x)*100;
		local y1 = (mousePosition.y - self.startPoint.y)*100;

		local col,row = self.curCol,self.curRow;

		if math.abs(x1) >= 10 or math.abs(y1) >= 10 then
			-- 右侧
			if x1 >= 0 and x1 >= math.abs(y1) then
				col = self.curCol + 1;
			-- 上侧
			elseif y1 >= 0 and y1 >= math.abs(x1) then
				row = self.curRow - 1;
			-- 左侧
			elseif x1 < 0 and -x1 > math.abs(y1) then
				col = self.curCol - 1;
			-- 下侧
			elseif y1 < 0 and -y1 > math.abs(x1) then
				row = self.curRow + 1;
			end
			
			if col < 1 then
				col = 1;
			end
			
			if col > Constant.GRID_COLS then
				col = Constant.GRID_COLS;
			end
			
			if row < 1 then
				row = 1;
			end
			
			if row > Constant.GRID_ROWS then
				row = Constant.GRID_ROWS;
			end

			self.secondGrid = Vector2.New(col, row);

			self:moveChess();
		end
	end
end

-- 棋盘边缘检验
function ChessBoard:verificaEdge(x,y)

	local posX, posY;
	posX = math.round((x-self.board.transform.position.x)*100);
	posY = math.round((y-self.board.transform.position.y)*100);

	self.curCol = math.floor(posX / Constant.CHESS_WIDTH) + 1;
	self.curRow = (Constant.GRID_ROWS - 1) - math.floor(posY / Constant.CHESS_HEIGHT) + 1;

	if self.curCol < 1 then
		self.curCol = 1;
	end
	
	if self.curCol > Constant.GRID_COLS then
		self.curCol = Constant.GRID_COLS;
	end
	
	if self.curRow < 1 then
		self.curRow = 1;
	end
	
	if self.curRow > Constant.GRID_ROWS then
		self.curRow = Constant.GRID_ROWS;
	end
end

-- 四个方向的宝石移动
function ChessBoard:moveChess()
	if bit.band(self.chessList[self.firstGrid.x][self.firstGrid.y].type, ChessData.CHESS_CAN_NOT_SWAP) > 0
	or bit.band(self.chessList[self.secondGrid.x][self.secondGrid.y].type, ChessData.CHESS_CAN_NOT_SWAP) > 0 then
		return;
	end
	
	local nextGrid = Vector2.New(0,0);
	
	for i = 1, #Constant.FOUR_GRIDS do
		nextGrid.x = Constant.FOUR_GRIDS[i][1] + self.firstGrid.x;
		nextGrid.y = Constant.FOUR_GRIDS[i][2] + self.firstGrid.y;
		
		-- if self.grids[self.secondGrid.x][self.secondGrid.y] ~= 0 
		if self.secondGrid.x == nextGrid.x
		and self.secondGrid.y == nextGrid.y then
			-- 进行宝石交换
			-- self:dispatchEvent({name = ChessBoard.EVENT_SWAP_START});
			-- self:swapChessExecute(self.chessList[self.firstGrid.x][self.firstGrid.y], self.chessList[self.secondGrid.x][self.secondGrid.y],
			-- 	function()self:swapChessComplete();end);

			self:swapChessExecute(self.chessList[self.firstGrid.x][self.firstGrid.y], self.chessList[self.secondGrid.x][self.secondGrid.y],handler(self,self.swapChessComplete));
			break;
		end
	end
end

-- 交换执行
function ChessBoard:swapChessExecute(chess1,chess2,callback)

	self.operatorBoard = false;

	self.isTouched = false;

	if self.curChess then
		self.curChess:showLight(false);
		self.curChess = nil;
	end
	self.activeChessList = {};
	table.insert(self.activeChessList,chess1);
	table.insert(self.activeChessList,chess2);
	self:swapChess(chess1,chess2);

	-- 播放移动动画
	if callback ~= nil then
		chess1:move(chess1.col, chess1.row);
		chess2:move(chess2.col, chess2.row, callback);
	end

end

-- 两个棋子进行交换
function ChessBoard:swapChess(chess1,chess2)
	local tempCol,tempRow,tempIndex;
	tempCol = chess1.col;
	tempRow = chess1.row;
	self.chessList[tempCol][tempRow] = chess2;
	self.chessList[chess2.col][chess2.row] = chess1;
	chess1.col = chess2.col;
	chess1.row = chess2.row;
	chess2.col = tempCol;
	chess2.row = tempRow;
end

-- 交换结束逻辑判断
function ChessBoard:swapChessComplete()
	local firstChess = self.chessList[self.firstGrid.x][self.firstGrid.y];
	local secondChess = self.chessList[self.secondGrid.x][self.secondGrid.y];
	
	-- self.isChocolateCrush = false;
	-- self.getBomb = false;
	self.explosionChessList = {};
	-- self.scores = {};
	-- -- 炸弹消除判断
	-- local bombFirst,delayToCrush = self:bombCrush(firstChess,secondChess);
	local eliminate = false;
	-- if not bombFirst then
	-- 执行普通宝石的消除
	for key, chess in ipairs(self.activeChessList) do
		if self:eliminateExcute(chess) == true then
			eliminate = true;
		end
	end
	-- end

	-- if bombFirst or eliminate then
	-- 	-- 材料消除
	-- 	self.step = self.step + 1;
	-- 	self:dispatchEvent({name = ChessBoard.EVENT_SWAP_SUCCESS,step = self.step});
	-- 	if BATTLE_MODE == BATTLE_MODE_DROP then self:dropThingEliminate() end;
	-- 	if not delayToCrush then
	-- 		self:startExplosion();
	-- 	end
	-- else
	-- 	-- 位置还原
	-- 	self:swapChessExecute(secondChess, firstChess, function() self:dispatchEvent({name = ChessBoard.EVENT_SWAP_FAILURE});end);
	-- end

	if eliminate then
		self:startExplosion();
	else
		self:swapChessExecute(secondChess, firstChess, function() self.operatorBoard = true;end);
	end	
end

-- 判断激活棋子中是否存在消除，如果为非测试模式，那么执行消除
function ChessBoard:eliminateJudge(justTest)
	-- self.getBomb = false;
	self.explosionChessList = {};
	-- self.scores = {};
	local count = 0;
	
	-- 执行普通宝石的消除
	for key, chess in ipairs(self.activeChessList) do
		if self:eliminateExcute(chess,justTest) == true then
			count = count + 1;
		end
	end

	return count > 0;
end

-- 消除核心算法
function ChessBoard:eliminateExcute(originalChess,justTest)

	self.eliminateChessList = {};
	self:findChess(originalChess);
	originalChess.isChecked = false;
	for key,chess in ipairs(self.eliminateChessList) do
		chess.isChecked = false;
	end
	
	local crushChessList = self:getCrushChessList(originalChess);

	return #crushChessList > 0;
end

-- 递归遍历
function ChessBoard:findChess(chess)
	if chess.isChecked == true then
		return;
	end
	
	chess.isChecked = true;
	
	local checkChessList = {};
	local fruitType = bit.band(chess.type, ChessData.CHESS_FRUIT);
	-- 左
	if chess.col - 1 >= 1 and bit.band(self.chessList[chess.col - 1][chess.row].type, ChessData.CHESS_FRUIT) == fruitType then
		table.insert(checkChessList, self.chessList[chess.col - 1][chess.row]);
	end
	
	-- 右
	if chess.col + 1 <= Constant.GRID_COLS and bit.band(self.chessList[chess.col + 1][chess.row].type, ChessData.CHESS_FRUIT) == fruitType then
		table.insert(checkChessList, self.chessList[chess.col + 1][chess.row]);
	end
	
	-- 上
	if chess.row - 1 >= 1 and bit.band(self.chessList[chess.col][chess.row - 1].type, ChessData.CHESS_FRUIT) == fruitType then
		table.insert(checkChessList, self.chessList[chess.col][chess.row - 1]);
	end
	
	-- 下
	if chess.row + 1 <= Constant.GRID_ROWS and bit.band(self.chessList[chess.col][chess.row + 1].type, ChessData.CHESS_FRUIT) == fruitType then
		table.insert(checkChessList, self.chessList[chess.col][chess.row + 1]);
	end
	
	local nextChess;
	local len = #checkChessList;
	for i = 1, len do
		nextChess = checkChessList[i];
		if nextChess.isChecked == false then
			table.insert(self.eliminateChessList, nextChess);
			self:findChess(nextChess);
		end
	end
end

-- 获得一组消除数组
function ChessBoard:getCrushChessList(originalChess)
	local crushChessList = {};
	
	local function nextChess(col,row,type)
		local chess = nil;
		if col >= 1 and col <= Constant.GRID_COLS and row >= 1 and row <= Constant.GRID_ROWS then
			if bit.band(self.chessList[col][row].type, ChessData.CHESS_FRUIT) == bit.band(type, ChessData.CHESS_FRUIT) then
				chess = self.chessList[col][row];
			end
		end
		return chess;
	end
	
	local function testCol(chess)
		local chess1,chess2;
		chess1 = nextChess(chess.col,chess.row-1,chess.type);
		if chess1 ~= nil then
			chess1 = nextChess(chess.col,chess.row-2,chess.type);
			if chess1 ~= nil then
				return true;
			else
				chess1 = nextChess(chess.col,chess.row+1,chess.type);
				if chess1 ~= nil then
					return true;
				end
			end
		else
			chess1 = nextChess(chess.col,chess.row+1,chess.type);
			if chess1 ~= nil then
				chess1 = nextChess(chess.col,chess.row+2,chess.type);
				if chess1 ~= nil then
					return true;
				end
			end
		end
		return false;
	end
	
	local function testRow(chess)
		local chess1,chess2;
		chess1 = nextChess(chess.col-1,chess.row,chess.type);
		if chess1 ~= nil then
			chess1 = nextChess(chess.col-2,chess.row,chess.type);
			if chess1 ~= nil then
				return true;
			else
				chess1 = nextChess(chess.col+1,chess.row,chess.type);
				if chess1 ~= nil then
					return true;
				end
			end
		else
			chess1 = nextChess(chess.col+1,chess.row,chess.type);
			if chess1 ~= nil then
				chess1 = nextChess(chess.col+2,chess.row,chess.type);
				if chess1 ~= nil then
					return true;
				end
			end
		end
		return false;
	end
	
	if testCol(originalChess) or testRow(originalChess) then
		table.insert(crushChessList, originalChess);
		self:addToExplosion(originalChess);
		-- 遍历联通棋子，获得可消除棋子
		for key,chess in ipairs(self.eliminateChessList) do
			if testCol(chess) or testRow(chess) then
				table.insert(crushChessList, chess);
				self:addToExplosion(chess);
			end
		end
	end
	
	return crushChessList;
end

-- 将消除的宝石添加到爆炸列表
function ChessBoard:addToExplosion(chess)
	
	if chess.type == ChessData.CHESS_TYPE_EMPTY then
		return false;
	end
	
	if #(self.explosionChessList) == 0 then
		table.insert(self.explosionChessList, chess);
		return true;
	else
		-- 剔除掉重复添加的宝石
		local hasChess = false;
		for key,expChess in ipairs(self.explosionChessList) do
			if self:isSameChess(expChess, chess) then
				hasChess = true;
				break;
			end
		end
		
		if hasChess == false then
			table.insert(self.explosionChessList, chess);
			return true;
		end
	end
	return false;
end

-- 是否是同一个宝石
function ChessBoard:isSameChess(chess1,chess2)
	if chess1 == nil or chess2 == nil then
		return false;
	else
		return chess1.col == chess2.col and chess1.row == chess2.row;
	end
end

-- 开始播放宝石爆炸特效
function ChessBoard:startExplosion()

	local chess;
	local i = 1;
	while i <= #self.explosionChessList do
		chess = self.explosionChessList[i];


		chess:setState(Constant.CHESS_STATE_EXPLOSION, function() self:onExplosion() end);

		i = i + 1;
	end

	self.explosionCount = 0;
	self.explosionMax = #self.explosionChessList;

end

-- 爆炸结束
function ChessBoard:onExplosion()

	self.explosionCount = self.explosionCount + 1;
	if self.explosionCount == self.explosionMax then
		self:fallenStart(false);
	end
	-- end
end

-- 宝石掉落
function ChessBoard:fallenStart(justTest)

	-- 空各自数组
	self.emptyChessList = {};

	-- 用来标记已经检查过的列
	local explosionCols = {}
	for i = 1, Constant.GRID_COLS do
		table.insert(explosionCols, 0);
	end
	
	-- 将爆炸的棋子来列表中设置为nil
	for key, chess in ipairs(self.explosionChessList) do
		explosionCols[chess.col] = 1;
		self.chessList[chess.col][chess.row] = nil;
	end

	-- 进行同列掉落计算,得出最终的掉落结果
	local function colFallen(col)
		local fallenChessList = {};
		local emptyChessList = {};
		local colCount = 1;
		local nextChess;
		local k,type,bornRow;
		for row = 1, Constant.GRID_ROWS do
			nextChess = self.chessList[col][row];
			-- 补充新棋子
			if nextChess == nil then
				type,bornRow = self:createGemType(justTest,col);
				nextChess = self:getFromExplosion(type,col,row,justTest);
				if type == ChessData.CHESS_TYPE_EMPTY then
					table.insert(emptyChessList,nextChess);
				else
					if not justTest then
						nextChess:setBornY(colCount + Constant.GRID_ROWS - 1 - bornRow);
					end
				end
				colCount = colCount + 1;
				self:chessFallen(col,row);
			end
			-- 当到最后一行的时候，进行掉落棋子收集
			if row == Constant.GRID_ROWS then
				k = Constant.GRID_ROWS;
				while k >= 1 do
					-- 如果位置改变了，那么一定是掉落棋子
					if self.chessList[col][k]:isOriginePos() == false 
					and self.chessList[col][k].type ~= ChessData.CHESS_TYPE_EMPTY then
						table.insert(fallenChessList, self.chessList[col][k]);
					end		
					k = k -1;
				end
			end
		end
		-- 返回执行掉落棋子的数组
		return fallenChessList,emptyChessList;
	end
	
	self.activeChessList = {};
	self.emptyChessList = {};
	-- 掉落只跟列有关
	local fChessList,eChessList,key,chess;
	for i = 1, Constant.GRID_COLS do
		if explosionCols[i] == 1 then
			fChessList,eChessList = colFallen(i);
			for key,chess in ipairs(fChessList) do
				if not justTest then
					chess:fallen(function() self:onFallen() end);
				end
				table.insert(self.activeChessList, chess);
			end
			
			for key,chess in ipairs(eChessList) do
				table.insert(self.emptyChessList, chess);
			end
		end
	end
	
	self.fallenCount = 0;
	self.fallenMax = #self.activeChessList;
end

-- 限制随机类型，让两次随机结果不一样
function ChessBoard:randomGemType()
	local random = math.random(0,Constant.CHESS_TYPES-1);
	local persent = math.random(1,100);

	-- 在该几率下生成的棋子与上一个棋子相同
	if persent >= Constant.CREATE_SAME_CHESS_PERSENT then
	
		local leftColor = {};
		for i = 0, Constant.CHESS_TYPES-1 do
			if i ~= self.preRandom then
				table.insert(leftColor,i);
			end
		end
		random = leftColor[math.random(1,#leftColor)];
		self.preRandom = random;
	end
	return bit.lshift(1,self.preRandom);
end

-- 新棋子的类型生成
function ChessBoard:createGemType(justTest,col)
	local type;
	local bornRow = 1;

	type = self:randomGemType();

	return type,bornRow; 

end

-- 从已消除的对象池中获取宝石
function ChessBoard:getFromExplosion(type,col,row,justTest)
	local chessData = ChessData.new(type,col,row, nil);
	local poolChess = self.explosionChessList[1];
	poolChess:reset(chessData);
	table.remove(self.explosionChessList,1);
	self.chessList[col][row] = poolChess;
	if not justTest then
		poolChess:setState(Constant.CHESS_STATE_NORMAL);
	end
	return poolChess;
end

-- 同列掉落
function ChessBoard:chessFallen(col,row)
	local u,canSwap;
	-- 棋子下落位置重置
	while row > 1 do
		-- if self.grids[col][row] ~= 0 then
		u = row;
		canSwap = false;
		-- 如果下一个位置是空，那么再查后续的位置
		while( u > 1) do
			if bit.band(self.chessList[col][u - 1].type, ChessData.CHESS_CAN_NOT_SWAP) > 0 then
				return;
			end
			
			if self.isDead == true and bit.band(self.chessList[col][u - 1].type, ChessData.CHESS_TYPE_DROP_THING) > 0 then
				return;
			end
			
			if self.chessList[col][u - 1].type ~= ChessData.CHESS_TYPE_EMPTY then
				canSwap = true;
				break;
			end
			u = u - 1;
		end
		
		if canSwap then
			-- 位置交换
			self:swapChess(self.chessList[col][row],self.chessList[col][u - 1]);
		end
		-- end
		row = row - 1;
	end
end

function ChessBoard:onFallen()
		-- 保证所有的宝石都掉落完毕
	if self.fallenCount == self.fallenMax - 1 then

		if self:eliminateJudge(false) then
			self:startExplosion();
		else
			self:steady();
		end
	else
		self.fallenCount = self.fallenCount + 1;
	end
end

function ChessBoard:steady()
	self.operatorBoard = true
end

return ChessBoard;