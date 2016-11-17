-- require("gamelib.framework.init");
-- bit = require("bit");

--主入口函数。从这里开始lua逻辑
function Main()					
	-- print("Main.start()");

	-- print(UnityEngine.Screen.width.."_"..UnityEngine.Screen.height);

	-- -- 棋盘测试
	-- local ChessBoard = require("app.chessboard.ChessBoard");
	-- ChessBoard.new();

	-- UpdateBeat:Add(Main.Update, self) 

-- -- //		// 读取材质, Resources.Load资源读取必须把资源放在Resource目录下
-- -- //		Texture2D texture2d = (Texture2D)Resources.Load ("Image/Fruit/FruitBlue_Normal");
-- -- //
-- -- //		// 创建对象
-- -- //		GameObject gb = new GameObject ();
-- -- //
-- -- //		// 添加渲染组件
-- -- //		SpriteRenderer sr = gb.AddComponent <SpriteRenderer> ();
-- -- //
-- -- //		// 创建Sprite
-- -- //		Sprite sp = Sprite.Create (texture2d, new Rect (0, 0, texture2d.width, texture2d.height), new Vector2 (0.5f, 0.5f));
-- -- //
-- -- //		// 渲染器设置sprite
-- -- //		sr.sprite = sp;
-- -- //
-- -- //		// 对象添加到父容器上
-- -- //		gb.transform.parent = gameObject.transform;

-- 	local texture2d = UnityEngine.Resources.Load ("Image/Fruit/FruitOrange_Normal");

-- 	-- local gb = UnityEngine.GameObject('go');

-- 	-- gb:AddComponent(typeof(UnityEngine.SpriteRenderer));

-- 	local sp = UnityEngine.Sprite.Create(texture2d, UnityEngine.Rect(0,0,texture2d.width,texture2d.height),UnityEngine.Vector2(0.5,0.5));

-- 	print(UnityEngine.Sprite);

-- 	local chessPrefab = UnityEngine.Resources.Load("Prefab/Chess");
-- 	local gb = UnityEngine.GameObject.Instantiate(chessPrefab);

-- 	local spr = gb:GetComponent(typeof(UnityEngine.SpriteRenderer));
-- 	spr.sprite = sp;
end

--场景切换通知
function OnLevelWasLoaded(level)
	Time.timeSinceLevelLoad = 0
end
