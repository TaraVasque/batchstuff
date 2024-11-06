@echo off
echo Displaying disk usage...
wmic logicaldisk get size,freespace,caption
pause
