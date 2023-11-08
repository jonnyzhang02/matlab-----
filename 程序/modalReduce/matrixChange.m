function  [matrix_ex] = matrixChange(matrix, node_dof, boundary, freedom)
%将node的第freedom移动到matrix最后 形成新的矩阵changedMatrix

n = node_dof(boundary,freedom);

matrix_ex = matrix;
matrix_ex(1:n-1,1:n-1) = matrix(1:n-1,1:n-1);
matrix_ex(n:end-1,1:n-1) = matrix(n+1:end,1:n-1);
matrix_ex(1:n-1,n:end-1) = matrix(1:n-1,n+1:end);
matrix_ex(n:end-1,n:end-1) = matrix(n+1:end,n+1:end);
matrix_ex(end,1:n-1) = matrix(n,1:n-1);
matrix_ex(end,n:end-1) = matrix(n,n+1:end);
matrix_ex(1:n-1,end) = matrix(1:n-1,n);
matrix_ex(n:end-1,end) = matrix(n+1:end,n);
matrix_ex(end,end) = matrix(n,n);

end

