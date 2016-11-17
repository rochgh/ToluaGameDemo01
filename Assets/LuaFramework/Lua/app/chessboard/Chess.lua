--@author roc_hgh

local ChessData = import('.ChessData');

local Constant = import(".Constant");

local Chess = class("Chess");

Chess.TEXTURE_LIST = {};
Chess.TEXTURE_LIST[ChessData.CHESS_TYPE_RED] = "Image/Fruit/FruitRed";
Chess.TEXTURE_LIST[ChessData.CHESS_TYPE_ORANGE] = "Image/Fruit/FruitOrange";
Chess.TEXTURE_LIST[ChessData.CHESS_TYPE_YELLOW] = "Image/Fruit/FruitYellow";
Chess.TEXTURE_LIST[ChessData.CHESS_TYPE_BLUE] = "Image/Fruit/FruitBlue";
Chess.TEXTURE_LIST[ChessData.CHESS_TYPE_GREEN] = "Image/Fruit/FruitGreen";
Chess.TEXTURE_LIST[ChessData.CHESS_TYPE_PURPLE] = "Image/Fruit/FruitPurple";

-- 构造函数
function Chess:ctor()

	-- 棋子状态
	self.state = Constant.CHESS_STATE_NORMAL;

	-- 棋子类型
	self.type = nil
	
	-- 所在列
	self.col = 0;
	-- 所在行
	self.row = 0;

	self.isChecked = false;

	self.position = Vector2.New(0,0);
	self.targetPosition = Vector2.New(0,0);

	-- 创建显示对象
	local __chessPrefab = UnityEngine.Resources.Load("Prefab/Chess");
	self.sprite = UnityEngine.GameObject.Instantiate(__chessPrefab);
	self.sprite.layer = 8;
end

-- 重置棋子数据
function Chess:reset(chessData)

	if self.mySequence then
		DG.Tweening.DOTween.Kill(self.mySequence,true);
		self.mySequence = nil;
	end

	self.col = chessData.col;
	self.row = chessData.row;

	self.sprite.transform.localScale = Vector3.New(1,1,1);

	self:updateFinalPosition();

	if chessData.type == 1 then self.type = ChessData.CHESS_TYPE_RED;
	elseif chessData.type == 2 then self.type = ChessData.CHESS_TYPE_ORANGE;
	elseif chessData.type == 3 then self.type = ChessData.CHESS_TYPE_YELLOW;
	elseif chessData.type == 4 then self.type = ChessData.CHESS_TYPE_BLUE;
	elseif chessData.type == 5 then self.type = ChessData.CHESS_TYPE_GREEN;
	elseif chessData.type == 6 then self.type = ChessData.CHESS_TYPE_PURPLE;
	end

	self:updateView();


end

-- 设置棋子最终位置
function Chess:updateFinalPosition()

	self.position.x = (self.col-1) * Constant.CHESS_WIDTH + Constant.CHESS_WIDTH_HALF;
	self.position.y = ((Constant.GRID_ROWS - 1)-(self.row-1)) * Constant.CHESS_HEIGHT + Constant.CHESS_HEIGHT_HALF;

	local parent = self.sprite.transform.parent;
	self.sprite.transform.position = Vector2.New(self.position.x/100+parent.position.x,self.position.y/100+parent.position.y);
end

-- 更新棋子显示
function Chess:updateView()
	-- 加载贴图
	local texture2d = UnityEngine.Resources.Load (Chess.TEXTURE_LIST[self.type].."_Normal");
	-- 创建u3d sprite对象
	local __sp = UnityEngine.Sprite.Create(texture2d, UnityEngine.Rect(0,0,texture2d.width,texture2d.height),UnityEngine.Vector2(0.5,0.5));
	-- 获取spriteRenderer组建
	local __spr = self.sprite:GetComponent(typeof(UnityEngine.SpriteRenderer));
	-- 设置新的渲染sprite
	__spr.sprite = __sp;
end

-- 高亮
function Chess:showLight(value)

	if value then

		if self.lightSprite == nil then

			-- 加载贴图
			local texture2d = UnityEngine.Resources.Load (Chess.TEXTURE_LIST[self.type].."_Light");
			-- 创建u3d sprite对象
			local __sp = UnityEngine.Sprite.Create(texture2d, UnityEngine.Rect(0,0,texture2d.width,texture2d.height),UnityEngine.Vector2(0.5,0.5));


			self.lightSprite = UnityEngine.GameObject.Instantiate(UnityEngine.Resources.Load("Prefab/Chess"));
			
			self.lightSprite.transform.parent = self.sprite.transform;
			self.lightSprite.transform.position = self.sprite.transform.position;

			-- self.lightSprite

			local render = self.lightSprite:GetComponent(typeof(UnityEngine.SpriteRenderer));  
			render.sprite = __sp;
			render.sortingOrder = 1;

    		-- render.material.shader = UnityEngine.Shader.Find("Custom/ColorGradation_HSV"); 
    		-- render.material.shader = UnityEngine.Shader.Find("Sprites/Default");

    		-- render.material.color = Color.New(0.5,0.5,0.5,1);
    		-- render.material.shader = nil;
		end

	else
		if self.lightSprite then
			UnityEngine.GameObject.Destroy(self.lightSprite);
			self.lightSprite = nil;
		end
	end

end

-- 宝石掉落
function Chess:fallen(onFallen,quick)
	if self.mySequence then
		DG.Tweening.DOTween.Kill(self.mySequence,true);
		self.mySequence = nil;
	end
	
	self.dy = 0.03;
	self.vy = 0;
	local moveSpeed = 0.1;
	if self:isOriginePos() == false then
	
		if quick then
			moveSpeed = 4;
			self.dy = 0;
			self.vy = 0;
		end
	
		if self.position.x >= self.targetPosition.x then
			self.flagX = -moveSpeed;
		elseif self.position.x < self.targetPosition.x then
			self.flagX = moveSpeed;
		end
		
		if self.position.y >= self.targetPosition.y then
			self.flagY = -moveSpeed;
		else
			self.flagY = moveSpeed;
		end
	
		local function scheduleUpdate()
			local moveX = true;
			local moveY = true;
			
			self.position.x = self.position.x + self.flagX;
			self.position.y = self.position.y + self.flagY;
			
			self.flagY = self.flagY - self.vy;
			self.vy = self.vy + self.dy;
			
			if (self.flagX > 0 and self.position.x >= self.targetPosition.x) or (self.flagX < 0 and self.position.x <= self.targetPosition.x) then
				moveX = false;
				self.position.x = self.targetPosition.x;
			end
			
			if (self.flagY > 0 and self.position.y >= self.targetPosition.y) or (self.flagY < 0 and self.position.y <= self.targetPosition.y) then
				moveY = false;
				self.position.y = self.targetPosition.y;
			end

			-- self.sprite:setPosition(self.position.x,self.position.y);

			local parent = self.sprite.transform.parent;
			self.sprite.transform.position = Vector2.New(self.position.x/100+parent.position.x,self.position.y/100+parent.position.y);

			if moveX == false and moveY == false then

				UpdateBeat:Remove(scheduleUpdate, self);
				-- self.sprite:unscheduleUpdate();
				-- if onFallen ~= nil then
				-- self.sprite.transform:DOLocalMove(Vector3.New(self.position.x/100,self.position.y/100,0), 0.2, false):OnComplete(function()
				-- 	-- self:updateFinalPosition();
				-- 	-- if callback ~= nil then
				-- 	-- 	callback(); 
				-- 	-- end
				-- end);

					-- onFallen();

				-- if not quick then
					self:startShock(onFallen);
				-- end

			end
		end

		-- 进入主update
		UpdateBeat:Add(scheduleUpdate, self);
	end
end;

function Chess:startShock(onFallen)
	if self.mySequence == nil then
		self.mySequence = DG.Tweening.DOTween.Sequence();
	end
	
	self.mySequence:Append(self.sprite.transform:DOLocalMove(Vector3.New(self.position.x/100,self.position.y/100+0.02,0), 0.1, false));
	self.mySequence:Append(self.sprite.transform:DOLocalMove(Vector3.New(self.position.x/100,self.position.y/100,0), 0.1, false):OnComplete(function()
			onFallen();
	end));
end

-- 移动
function Chess:move(targetCol, targetRow, callback)

	self.col = targetCol;
	self.row = targetRow;

	self.position.x = (self.col-1) * Constant.CHESS_WIDTH + Constant.CHESS_WIDTH_HALF;
	self.position.y = ((Constant.GRID_ROWS - 1)-(self.row-1)) * Constant.CHESS_HEIGHT + Constant.CHESS_HEIGHT_HALF;

	self.sprite.transform:DOLocalMove(Vector3.New(self.position.x/100,self.position.y/100,0), 0.2, false):OnComplete(function()
		self:updateFinalPosition();
		if callback ~= nil then
			callback(); 
		end
	end);
end

-- 更新棋子显示
function Chess:setState(state, onExplosion)
	self.state = state;
	-- 消除
	if state == Constant.CHESS_STATE_EXPLOSION then
		self.sprite.transform:DOScale(Vector3.New(0,0,1), 0.2):OnComplete(function()
			if onExplosion then
				onExplosion();
			end
		end);
	end
end

function Chess:setBornY(bornY)
	if self.mySequence then
		DG.Tweening.DOTween.Kill(self.mySequence,true);
		self.mySequence = nil;
	end

	self.position.x = (self.col-1) * Constant.CHESS_WIDTH + Constant.CHESS_WIDTH_HALF;
	self.position.y = (bornY + 1) * Constant.CHESS_HEIGHT + Constant.CHESS_HEIGHT_HALF;

	local parent = self.sprite.transform.parent;
	self.sprite.transform.position = Vector2.New(self.position.x/100+parent.position.x,self.position.y/100+parent.position.y);
end

-- 是否已经在自己应该在的位置了
function Chess:isOriginePos()
	self.targetPosition.x = (self.col-1) * Constant.CHESS_WIDTH + Constant.CHESS_WIDTH_HALF;
	self.targetPosition.y = ((Constant.GRID_ROWS - 1)-(self.row-1)) * Constant.CHESS_HEIGHT + Constant.CHESS_HEIGHT_HALF;
	return self.position == self.targetPosition;
end

return Chess;