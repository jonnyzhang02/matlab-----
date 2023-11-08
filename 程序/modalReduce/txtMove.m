function [] = txtMove(id)
namelist = dir('*.txt');
filename = {namelist.name};
for i=1:length(filename)
    movefile(filename{i},['..\test_',num2str(id-1),'\blade'])
end
