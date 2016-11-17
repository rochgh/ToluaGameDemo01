-- ChessData类的定义
-- @author roc_hgh
--[[
	 棋子类
  ]]
local ChessData = class("ChessData");

ChessData.CHESS_TYPE_EMPTY = 0;
ChessData.CHESS_TYPE_RED = 1; -- 1
ChessData.CHESS_TYPE_ORANGE = 2; -- 1 << 1
ChessData.CHESS_TYPE_YELLOW = 4; -- 1 << 2
ChessData.CHESS_TYPE_BLUE = 8; -- 1 << 3
ChessData.CHESS_TYPE_GREEN = 16; -- 1 << 4
ChessData.CHESS_TYPE_PURPLE = 32; -- 1 << 5

ChessData.CHESS_STATE_FOUR_BOMB_VER = 64;-- 四星垂直 -- 1 << 6
ChessData.CHESS_STATE_FOUR_BOMB_HOR = 128;-- 四星水平 -- 1 << 7
ChessData.CHESS_STATE_FIVE_33_BOMB = 256;-- 5星炸弹1 -- 1 << 8
ChessData.CHESS_STATE_FIVE_5_BOMB = 512;-- 5星炸弹2 -- 1 << 9

ChessData.CHESS_TYPE_DROP_1 = 1024; -- 1 << 10 -- 掉落物1
ChessData.CHESS_TYPE_DROP_2 = 2048; -- 1 << 11 -- 掉落物2
ChessData.CHESS_TYPE_ROCK = 4096; -- 1 << 12 -- 石块
ChessData.CHESS_STATE_LOCK = 8192; -- 1 << 13 -- 锁链

ChessData.BOMB_COMB_B51 = 16384; -- 1 << 14;-- 5星1炸弹
ChessData.BOMB_COMB_B52 = 32768; -- 1 << 15;-- 5星2炸弹

ChessData.CHESS_TYPE_CHOCOLATE = 65536; -- 1 << 16;-- 巧克力

ChessData.CHESS_TYPE_ROCK_2 = 131072;-- 1 << 17;-- 石块2 需要消除2次


-- 水果
ChessData.CHESS_FRUIT = 63; -- 00111111
-- 四星炸弹
ChessData.CHESS_TYPE_FOUR_BOMB = 192;  -- 0000 1100 0000
-- 炸弹属性
ChessData.CHESS_TYPE_BOMB = 960;       -- 0011 1100 0000
-- 五星炸弹
ChessData.CHESS_TYPE_FLASH_BOMB = 768; -- 0011 0000 0000
-- 掉落物
ChessData.CHESS_TYPE_DROP_THING = 3072; -- 1100 0000 0000
-- 不可交换
ChessData.CHESS_CAN_NOT_SWAP = 208896;   --0011 0011 0000 0000 0000 --巧克力、锁链、石头
-- 不可重置
ChessData.CHESS_CAN_NOT_RESET = 204544; -- 0011 0001 1111 0000 0000 --石块2、巧克力、石头、掉落物2、掉落物1、5星炸弹2、5星炸弹1

--- 组合炸弹

-- 五星炸弹1和四星垂直炸弹组合
ChessData.BOMB_COMB_B4VER_B51 = 320; -- 0001 0100 0000
-- 五星炸弹1和四星水平炸弹组合
ChessData.BOMB_COMB_B4HOR_B51 = 384; -- 0001 1000 0000
-- 五星炸弹2和四星炸弹组合
ChessData.BOMB_COMB_B4VER_B52 = 576; -- 0010 0100 0000
ChessData.BOMB_COMB_B4HOR_B52 = 640; -- 0010 1000 0000


-- 构造函数
function ChessData:ctor(type,col,row,extraData)
	self.type = type;
	self.col = col;
	self.row = row;
	self.extraData = extraData;
end

return ChessData