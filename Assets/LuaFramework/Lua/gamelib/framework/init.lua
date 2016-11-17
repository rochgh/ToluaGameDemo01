print("===========================================================")
print("              LOAD U3D QUICK FRAMEWORK")
print("===========================================================")

local CURRENT_MODULE_NAME = ...;

u3d = u3d or {};

u3d.PACKAGE_NAME = string.sub(CURRENT_MODULE_NAME, 1, -6);

require(u3d.PACKAGE_NAME .. ".functions");
-- require(u3d.PACKAGE_NAME .. ".tolua.event");