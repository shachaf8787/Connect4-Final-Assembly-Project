# Connect4-Final-Assembly-Project
Shachaf Chen's Final Assembly Project
-------------------------------------

4 In a Row

For playing, you have to extract all the files and folders to the path:< C:\TASM\BIN >
and then compile&run the file named: "Project.exe"


script for Dosbox-options.txt:
  mount c: c:\
  c:
  cd tasm
  cd bin
  cycles=max
  tasm /zi project.asm
  tlink /v project.obj
  project.exe
  
  
**The Project file calling all the sub files to it, like a main program.

