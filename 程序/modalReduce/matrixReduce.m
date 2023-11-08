function [ tran, stiff_ex, mass_ex, d3, map_ex, node_dof_ex] = matrixReduce( rpm )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
modal_num = 10;
node_num = 10;
strict_num = 3*node_num;
total_num = modal_num+strict_num;

%%%%%%%%%%%%%%%%%%%%%%%
%读取矩阵，得到右端项力
%刚度矩阵中由于叶根部分已被固定，因此节点对应的行列被划去
stiff = hb2mm(['stiff_',num2str(rpm),'.txt']);
mass = hb2mm('mass.txt');
len = length(mass(:, 1));

%%%%%%%%%%%%%%%%%%%%%%%
%计算固有频率
[~,d] = eigs(stiff,mass,modal_num,'SM');
d1 = diag(d);
d1 = sqrt(d1) / (2*pi);

%%%%%%%%%%%%%%%%%%%%%%%
%得到刚度矩阵和节点的对应关系
%node_dof中第i行j列的值代表，编号i节点的 第j个自由度
%在刚度矩阵中的位置
map = importdata('map.txt');
nlist = importdata('nlist.txt');
node_max = length(nlist);
node_dof = zeros(node_max, 3);
for i = 1: length(map)
    node_dof(map(i,2),map(i,3)) = map(i,1);
end

%%%%%%%%%%%%%%%%%%%%%%%
%根据固定界面矩阵，进行矩阵位置变换
%矩阵位置变换
boundary = importdata('strictnode.txt');
map_ex = map;
node_dof_ex = node_dof;
stiff_ex = stiff;
mass_ex = mass;

for i  = 1:node_num
    for freedom = 1:3
        stiff_ex = matrixChange(stiff_ex, node_dof_ex, boundary(i), freedom);
        mass_ex = matrixChange(mass_ex, node_dof_ex, boundary(i), freedom);
        [map_ex, node_dof_ex] = vectorChange(map_ex, node_dof_ex, boundary(i), freedom);
    end
end

[~,d] = eigs(stiff_ex,mass_ex,modal_num,'SM');
d2 = diag(d);
d2 = sqrt(d2) / (2*pi);

%%%%%%%%%%%%%%%%%%%%%%%
%固定界面法，对非界面部分进行缩减，采用模态坐标
%这部分内容同计算动力学相同
k_ii = stiff_ex(1:end-strict_num, 1:end-strict_num);
k_ib = stiff_ex(1:end-strict_num, end-strict_num+1:end);
i_bb = eye(strict_num);
[phi_k,~] = eigs(stiff_ex(1:end-strict_num,1:end-strict_num),mass_ex(1:end-strict_num,1:end-strict_num),modal_num,'SM');
phi_b = -k_ii\k_ib*i_bb;

tran = zeros(len, modal_num+strict_num);
tran(1:end-strict_num, 1:modal_num) = phi_k;
tran(1:end-strict_num, modal_num+1:end) = phi_b;
tran(end-strict_num+1:end, end-strict_num+1:end) = i_bb;

%%%%%%%%%%%%%%%%%%%%%%%
%将tran矩阵的内容写入txt
% tran_file = fopen(['tran_reduce_',num2str(rpm),'.txt'], 'w');
% for  i = 1: size(tran,1)
%     for j = 1: size(tran, 2)
%         fprintf(tran_file, '%d ', tran(i,j));
%     end
%     fprintf(tran_file, '\r\n');
% end

% %%%%%%%%%%%%%%%%%%%%%%
% 计算缩减之后的刚度质量阵
mass_reduce = tran'*mass_ex*tran;
stiff_reduce = tran'*stiff_ex*tran;

[~,d] = eigs(stiff_reduce, mass_reduce, modal_num,'SM');
d3 = diag(d);
d3 = sqrt(d3) / (2*pi);

%%%%%%%%%%%%%%%%%%%%%%%
%质量矩阵的内容写入txt
% mass_file = fopen(['mass_reduce_',num2str(rpm),'.txt'], 'w');
% stiff_file = fopen(['stiff_reduce_',num2str(rpm),'.txt'], 'w');
% force_file = fopen(['force_reduce_',num2str(rpm),'.txt'],'w');
% for  i = 1: total_num
%     for j = 1: total_num
%         fprintf(mass_file, '%.8e ', mass_reduce(i,j));
%         fprintf(stiff_file,'%.8e ', stiff_reduce(i,j));
%     end
%     fprintf(force_file,'%.8e ', force_reduce(i));
%     fprintf(force_file, '\r\n');
%     fprintf(mass_file, '\r\n');
%     fprintf(stiff_file, '\r\n');
% end
% 
% fclose('all');
% 
% end

