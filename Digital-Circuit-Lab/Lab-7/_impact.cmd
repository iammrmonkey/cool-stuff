loadProjectFile -file "Z:\Lab07/Lab07.ipf"
setMode -ss
setMode -sm
setMode -hw140
setMode -spi
setMode -acecf
setMode -acempm
setMode -pff
setMode -bs
setMode -bs
setMode -bs
setMode -bs
Program -p 1 
Program -p 1 
Program -p 1 
saveProjectFile -file "Z:/Lab07/Lab07.ipf"
setMode -bs
deleteDevice -position 3
deleteDevice -position 2
deleteDevice -position 1
