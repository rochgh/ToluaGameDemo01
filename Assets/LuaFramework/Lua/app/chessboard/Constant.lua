--@author roc_hgh
local Constant = {};

Constant.GRID_COLS = 7;
Constant.GRID_ROWS = 7;
Constant.CHESS_TYPES = 6;

-- 生成俩俩相同颜色棋子概率
Constant.CREATE_SAME_CHESS_PERSENT = 10;

Constant.CHESS_WIDTH = 58;
Constant.CHESS_HEIGHT = 58;
Constant.CHESS_WIDTH_HALF = 29;
Constant.CHESS_HEIGHT_HALF = 29;

-- grid type
Constant.GRID_TYPE_EMPTY = 0;-- 空置
Constant.GRID_TYPE_FRUIT = 2;--1 << 1 水果
Constant.GRID_TYPE_ROCK_CANDY_1 = 4;--1 << 2
Constant.GRID_TYPE_ROCK_CANDY_2 = 8;--1 << 3
Constant.GRID_TYPE_BORN = 16;--1 << 4 棋子出生点
Constant.GRID_TYPE_ROCK = 32;--1 << 5 石头1
Constant.GRID_TYPE_LOCK = 64;--1 << 6 锁链
Constant.GRID_TYPE_CHOCOLATE = 128;--1 << 7 巧克力
Constant.GRID_TYPE_ROCK_2 = 256;--1 << 8 石块2

Constant.FOUR_GRIDS = {{0,-1},{-1,0},{1,0},{0,1}};

Constant.CHESS_STATE_NORMAL = 0;
Constant.CHESS_STATE_EXPLOSION = 1;

return Constant;