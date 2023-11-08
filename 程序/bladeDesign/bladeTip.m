function [interpolation] = bladeTip(node, var)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
% 这里用于观察叶尖结点的径向长度
% 每隔六个结点选取固定界面，一共十一个结点
% 1轴向，2径向

strictnode = zeros(var.strictnum,2);
casingnode = zeros(12,2);

for i = 1:var.strictnum
    % 叶片结点的顺序关系是chordnum*spannum*(k-1)+chordnum*(j-1)+i
    % 弦长方向i，叶高方向j，厚度方向k
        temp = 1+6*(i-1)+(var.spannum-1)*var.chordnum+(2-1)*var.chordnum*var.spannum; %取k=2
        % 厚度方向一共三个结点，k=2代表中面上的结点
        strictnode(i, 2) = sqrt(node(temp,1)^2+node(temp,2)^2); %径向距离
        strictnode(i, 1)= node(temp,3); %轴向距离
        
        ratio = 0.5/1000+0.5/1000*(i-1)/10+1; % 机匣/半径比，形成一个渐扩的风扇机匣
        casingnode(i+1, 1)= strictnode(i, 1);
        casingnode(i+1, 2)= strictnode(i, 2)*ratio;
end

for i = 1:10
ratio(i) = 0.5/1000+0.5/1000*(i-1)/10+1;
end
tip.axial.lead=strictnode(1,1);
tip.axial.trail=strictnode(10,1);
tip.radial.lead=strictnode(1,2);
tip.radial.trail=strictnode(10,2);
% 机匣在叶顶这个区域有九个结点
% 机匣一共一定需要二十个结点吗
% 分别先前后延长6.5 4.5个结点，就得到了20个结点
tip.axial.element = (tip.axial.trail-tip.axial.lead)/9;
tip.radial.element = (tip.radial.lead-tip.radial.trail)/9;

casing.axial.start=tip.axial.lead-6.5*tip.axial.element;
% casing.axial.lead=tip.axial.lead-5.5*tip.axial.element/5;
% casing.axial.trail=tip.axial.trail+3.5*tip.axial.element/5;
casing.axial.end=tip.axial.trail+4.5*tip.axial.element;

casing.radial.start=tip.radial.lead+tip.radial.element;
% casing.radial.lead=tip.radial.lead+tip.radial.element;
% casing.radial.trail=tip.radial.trail-tip.radial.element/2;
casing.radial.end=tip.radial.trail-tip.radial.element;

casingnode(1,1)=casing.axial.start;
casingnode(1,2)=casing.radial.start;
% casingnode(2,1)=casing.axial.lead;
% casingnode(2,2)=casing.radial.lead;

% casingnode(13,1)=casing.axial.trail;
% casingnode(13,2)=casing.radial.trail;
casingnode(12,1)=casing.axial.end;
casingnode(12,2)=casing.radial.end;

gap=zeros(10,1);
for i=1:10
    gap(i)=casingnode(i+1,2)-strictnode(i,2);
end



tip.range = linspace(tip.axial.lead, tip.axial.trail);
tip.result = spline(strictnode(:,1),strictnode(:,2),tip.range);
casing.range = linspace(casing.axial.start, casing.axial.end);
casing.result = spline(casingnode(:,1),[0 casingnode(:,2)' 0],casing.range);
interpolation = spline(casingnode(:,1),[0 casingnode(:,2)' 0]);

% figure(2)
% % ylim([0.5 0.75])
% % xlim([-0.15 0.1])
% hold on
% plot(casing.range,casing.result)
% plot(tip.range,tip.result)
% plot(casingnode(:,1),casingnode(:,2),'*')
% hold off

