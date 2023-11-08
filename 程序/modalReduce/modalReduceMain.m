function [] = modalReduceMain()
%%%%%%%%%%%%%%%%%%%%%%%
%计算各转速变换矩阵
[t0, k0, m, ~, map, nf] = matrixReduce(0);
[t1, k1, ~, ~] = matrixReduce(3000);
[t2, k2, ~, ~] = matrixReduce(6000);

modal_num = 10;
strict_num = 30;
total_num = modal_num+strict_num;
dof_num = length(m);

rpmmax = 6000;
omegamax = rpmmax*2*pi/60;

k_0 = k0;
k_1 = (16*k1-k2-15*k0)/(3*(omegamax^2));
k_2 = (k2-4*k1+3*k0)*4/(3*(omegamax^4));

%%%%%%%%%%%%%%%%%%%%%%%
%计算整体矩阵的变换矩阵
%这里还要施密特正交化
T = zeros(dof_num,3*total_num);
T(:,1:modal_num)  = t2(:,1:modal_num);
T(:,modal_num+1:2*modal_num) = t1(:,1:modal_num);
T(:,2*modal_num+1:3*modal_num) = t0(:,1:modal_num);
T(:,3*modal_num+1:3*modal_num+strict_num) = t2(:,modal_num+1:end)-t0(:,modal_num+1:end);
T(:,3*modal_num+strict_num+1:3*modal_num+2*strict_num) = t1(:,modal_num+1:end)-t0(:,modal_num+1:end);
T(:,3*modal_num+2*strict_num+1:3*modal_num+3*strict_num) = t0(:,modal_num+1:end);

torth = T(:,1:3*modal_num+2*strict_num);
U = zeros(dof_num, 3*modal_num+2*strict_num);
U(:,1) = torth(:,1)/sqrt(torth(:,1)'*torth(:,1));
for i = 2:size(U,2)
    U(:,i) = torth(:,i);
    for j = 1:i-1
        U(:,i) = U(:,i) - ( U(:,i)'*U(:,j) )/( U(:,j)'*U(:,j) )*U(:,j);
    end
    U(:,i) = U(:,i)/sqrt(U(:,i)'*U(:,i));
end
T(:,1:3*modal_num+2*strict_num) = U;

%%%%%%%%%%%%%%%%%%%%%%%
%计算质量矩阵缩减之后的结果，并保存
M = m;
Mr = T'*M*T;
mass_file = fopen('m_reduce_rpm.txt', 'w');
for  i = 1: total_num*3
    for j = 1: total_num*3
        fprintf(mass_file, '%.8e ', Mr(i,j));
        
    end
    fprintf(mass_file, '\r\n');
end
fclose('all');

%%%%%%%%%%%%%%%%%%%%%%%
%计算刚度矩阵缩减之后的结果，并保存
Kr0=T'*k_0*T;
Kr1=T'*k_1*T;
Kr2=T'*k_2*T;

% rpm=0;
% omega=rpm*2*pi/60;
% Kr_0=Kr0+omega^2*Kr1+omega^4*Kr2;
% rpm=3000;
% omega=rpm*2*pi/60;
% Kr_3000=Kr0+omega^2*Kr1+omega^4*Kr2;
% rpm=6000;
% omega=rpm*2*pi/60;
% Kr_6000=Kr0+omega^2*Kr1+omega^4*Kr2;
% 
% [~,d_0] = eigs(Kr_0,Mr,modal_num,'SM');
% d_0 = diag(d_0);
% d_0 = sqrt(d_0) / (2*pi);
% [~,d_3000] = eigs(Kr_3000,Mr,modal_num,'SM');
% d_3000 = diag(d_3000);
% d_3000 = sqrt(d_3000) / (2*pi);
% [~,d_6000] = eigs(Kr_6000,Mr,modal_num,'SM');
% d_6000 = diag(d_6000);
% d_6000 = sqrt(d_6000) / (2*pi);

stiff_file_0 = fopen('k_reduce_0.txt', 'w');
stiff_file_1 = fopen('k_reduce_1.txt', 'w');
stiff_file_2 = fopen('k_reduce_2.txt', 'w');
for  i = 1: total_num*3
    for j = 1: total_num*3
        fprintf(stiff_file_0,'%.8e ', Kr0(i,j));
        fprintf(stiff_file_1,'%.8e ', Kr1(i,j));
        fprintf(stiff_file_2,'%.8e ', Kr2(i,j));
    end
    fprintf(stiff_file_0, '\r\n');
    fprintf(stiff_file_1, '\r\n');
    fprintf(stiff_file_2, '\r\n');
end
fclose('all');
    
%%%%%%%%%%%%%%%%%%%%%%%
%缩减完之后只有最后十个结点
%依旧记录这十个节点的位置
mapr = map;
mapr(:,1) = map(:,1) - size(map,1) + 3*total_num;
mapr(1:end-strict_num,1)= 0;

nfr = zeros(length(nf),3);
for i = 1: size(mapr,1)
    nfr(mapr(i,2),mapr(i,3)) = mapr(i,1);
end

nf_file = fopen('nf_new.txt','w');
nfr_file = fopen('nf_reduce_rpm.txt','w');
for  i = 1: size(nfr,1)
    for j = 1: size(nfr, 2)
        fprintf(nf_file, '%d ', nf(i,j));
        fprintf(nfr_file, '%d ', nfr(i,j));
    end
    fprintf(nf_file, '\r\n');
    fprintf(nfr_file, '\r\n');
end
fclose('all');

tran_file = fopen('transferMatrix.txt', 'w');
for  i = 1: size(T,1)
    for j = 1: size(T, 2)
        fprintf(tran_file, '%d ', T(i,j));
    end
    fprintf(tran_file, '\r\n');
end
fclose('all');
