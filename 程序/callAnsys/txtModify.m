function [] = txtModify()
%%%%%%%修改map文件文件名和进行替换
movefile('mass.mapping','map.txt');
fidr = fopen('map.txt','rt+');
total = 3*120*60*4;
new = cell(total,1);
i=0;
while ~feof(fidr)
    i=i+1;
    str = fgetl(fidr);
    str = strrep(str,'UX','1');
    str = strrep(str,'UY','2');
    str = strrep(str,'UZ','3');
    new{i} = str;
end
fclose(fidr);

fidw = fopen('map.txt','wt+');
for k=2:i
        fprintf(fidw,'%s\t\n',new{k});
end
fclose(fidw);


namelist = dir('*.txt');
filename = {namelist.name};
for i=1:length(filename)
    movefile(filename{i},'..\modalReduce')
end

