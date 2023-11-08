function [ map_ex, node_dof_ex ] = vectorChange( map, node_dof, boundary, freedom )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
n = node_dof(boundary,freedom);

map_ex = map;
map_ex(1:n-1,:) = map(1:n-1,:);
map_ex(n:end,1) = map(n:end,1);
map_ex(n:end-1,2:3) = map(n+1:end,2:3);
map_ex(end,2:3) = map(n,2:3);

node_dof_ex = node_dof;
for i = 1: length(map)
    node_dof_ex(map_ex(i,2),map_ex(i,3)) = map_ex(i,1);
end

% force_ex = force;
% force_ex(1:n-1) = force(1:n-1);
% force_ex(n:end-1) = force(n+1:end);
% force_ex(end) = force(n);
end

