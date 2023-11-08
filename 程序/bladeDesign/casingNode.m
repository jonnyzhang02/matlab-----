function [] = casingNode(id)
circum = 60;
axial = 20;

file = fopen('casing_nodenum.txt','w');
for i=1:circum
    for j =0:axial
            fprintf(file,'%8d', 30000+i+60*j);
    end
    fprintf(file, '\r\n');
end
fclose(file);

movefile('casing_nodenum.txt',['..\test_',num2str(id-1),'\casing']);