function []=bladeDesignMain(id)
%

% 初始参数设置
blade = bladeVar(id);
var = mainVar();

% 用以存储中面直角坐标
X=zeros(var.chordnum,var.spannum);
Y=zeros(var.chordnum,var.spannum);
Z=zeros(var.chordnum,var.spannum);

% 生成中面
for j = 1:var.spannum
    theta1 = 0;
    rho1 = (j-1)/(var.spannum-1)*blade.span+blade.radius;
    blade.camber = bladeCamber(blade, rho1);
    for i = 1:var.chordnum
        z1 = (i-1)/(var.chordnum-1)*blade.chord-0.5*blade.chord;
        [theta2, rho2, z2] = bladeModel(theta1, rho1, z1, blade);        
        [nodex, nodey, nodez] = pol2cart(theta2, rho2, z2); %柱坐标系下的节点坐标转换为笛卡尔坐标系
        
        X(i,j)=nodex;
        Y(i,j)=nodey;
        Z(i,j)=nodez;
    end
end


[Nx,Ny,Nz] = surfnorm(X,Y,Z); %计算中面法线方向
node=zeros(var.totalnum,3);
for i =1:var.chordnum
    for j=1:var.spannum
        %计算不同轴向径向的厚度分布
        thick_ratio1 = (blade.thick_tip/blade.thick_root-1)*(j-1)/(var.spannum-1)+1;
        thick_ratio2 = (blade.thick_edge/blade.thick_root-1)/(var.chordnum/2-1/2)^2*...
            (i-(1+var.chordnum)/2)^2+1;
        thick = blade.thick*thick_ratio1*thick_ratio2;
        for k=1:var.thicknum
            num=i+var.chordnum*(j-1)+var.chordnum*var.spannum*(k-1);
            nodex=X(i,j)+thick/2*Nx(i,j)*(k-1);
            nodey=Y(i,j)+thick/2*Ny(i,j)*(k-1);
            nodez=Z(i,j)+thick/2*Nz(i,j)*(k-1);
            node(num,1)=nodex;
            node(num,2)=nodey;
            node(num,3)=nodez;
        end
    end
end

% figure(1)
% scatter3(node(:,1),node(:,2),node(:,3),'*')

file = fopen('node.txt','w');
for i=1:var.totalnum
    fprintf(file,'N,%d,%1.16f,%1.16f,%1.16f\r\n', i, node(i,1), node(i,2), node(i,3));
end
fclose(file);

interpolation = bladeTip(node, var);
coefs = interpolation.coefs;

file = fopen('casing_spline.txt','w');
for i=1:11
    for j=1:4
        fprintf(file,'%24.16f',coefs(i,j));
    end
    fprintf(file, '\r\n');
end
fclose(file);

copyfile('node.txt',['..\test_',num2str(id-1),'\blade']);
movefile('casing_spline.txt',['..\test_',num2str(id-1),'\casing']);