function [] = callAnsysMain()
currentpath = cd;
% ansys 版本中的可执行文件,path中有空格要加：""
ansys_path=strcat('"C:\software\Ansys\ANSYS Inc\v182\ansys\bin\winx64\ANSYS182.exe"');
% jobname，不需要后缀
jobname='bladeGen';
% 是命令流文件，也就是用ansys写的apdl语言，matlab调用时，他将以批处理方式运行，需要后缀
skriptFileName= strcat(currentpath,'\bladeGen.mac');
% 输出文件所在位置，输出文件保存了程序运行的相关信息，需要后缀
outputFilename=[currentpath '\result.out'];
% 最终总的调用字符串,其中：32代表空格的字符串ASCII码
sys_char=strcat('SET KMP_STACKSIZE=2048k &',32,ansys_path,32,...
    '-b -p ansys -i',32,skriptFileName,32,...
    '-j',32,jobname,32,...
    '-o',32,outputFilename);
ansys =  system(sys_char);