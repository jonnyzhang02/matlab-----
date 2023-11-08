%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Harwell-Boeing的文件格式
% %       (注：?'mhbfile.txt'，'khbfile.txt'是用双精度格式存储的，matlab无法直接读取，需要先打开这两个文件，手动将其中的"D+"、"D-"替换成"e+"、"e-"。）
% %     文章中红色字体部分“手动将D换成E”有了更好的替代方法：matlab中用 "%lf" 代替 "%f" 即可读取这种格式的内容了。
% % ? ? 用HBMAT命令可输出结构刚度矩阵、质量矩阵和阻尼矩阵，其文件记录格式为大型稀疏矩阵的标准交换格式，采用索引存储方法记录矩阵的非零元素。文件基本格式是前面有4或5行描述数据，其后为单列矩阵元素值，说明如下：
% % ? ? 第1行：格式（A72），为文件头的字符型解释，如刚度矩阵或质量矩阵等标题。
% % ? ? 第2行：格式（5I14），分别表示该文件的总行数（不包括文件头）、矩阵列指针的个数、矩阵行索引的个数、矩阵元素数值的个数、右边项个数。
% % ? ? 第3行：格式（A3,11X,4I14），分别为矩阵类型、矩阵行数、矩阵列数、矩阵行索引数（对组装后的矩阵，该值等于矩阵行索引数）、单元元素数（对组装后的矩阵此值为0）。
% % ? ? 第4行：格式（2A16,2A20），分别表示列指针格式、行索引格式、系数矩阵数值格式、右边项数值格式。
% % ? ? 第5行：格式（A3,11X,2I14），A3各列分别表示右边项格式、应用高斯起始矢量、应用eXact求解矢量；两个整数分别表示右边项列数、行索引数。三个字符中的第1个字符可取：F——全部存贮（如节点荷载向量的全部元素）、M——与系数矩阵相同方法。
% % ? ? 第6行后：矩阵元素值（单列）。
% %
% % ? ? 矩阵类型用3个字符表示，
% % ? ? ? ? 第1个字符可取：
% % ? ? ? ? ? ? R——实数矩阵、
% % ? ? ? ? ? ? C——复数矩阵、
% % ? ? ? ? ? ? P——仅矩阵结构（无元素数值）；
% % ? ? ? ? 第2个字符可取：
% % ? ? ? ? ? ? S——对称矩阵、
% % ? ? ? ? ? ? U——不对称矩阵、
% % ? ? ? ? ? ? H——Hermitian矩阵、
% % ? ? ? ? ? ? Z——病态对称矩阵；
% % ? ? ? ? ? ? R——带状矩阵；
% % ? ? ? ? 第3个字符可取：
% % ? ? ? ? ? ? A——组装的矩阵、
% % ? ? ? ? ? ? E——单元矩阵（未组装）。
% %
% % ? ? ? ? 对称矩阵只存储下三角元素，如结构刚度矩阵为对称矩阵，Harwell-Boeing格式则仅记录下三角元素。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SparseMatrix=hb2mm(hbfile)
% 将Ansys导出的HB格式的稀疏矩阵转成matlab的稀疏矩阵
% SPARSEMATRIX=hb2mm(hbfile)
% input:
% ? ? hbfile : string,HB文件名
% output
% ? ? SparseMatrix : 下标加元素值的matlab标准sparse matrix

% hbfile='hbfile.txt';

%======= 1. 读取文件
fid=fopen(hbfile,'r');

l1 = fgetl(fid); % FileHeader
l2 = fscanf(fid,'%d',5); % FileSizeInfo
if l2(5)~=0
    error('不能输出右端项，请重新导出Harwell-Boeing矩阵文件');
end
l31 = fscanf(fid,'%s',1); % MatricTypeInfo
l32 = fscanf(fid,'%d',4); % MatricSizeInfo
l4 = fscanf(fid,'%s',4); % FormatInfo

COLPTR= fscanf(fid,'%lf',[1,l2(2)]);
ROWIND= fscanf(fid,'%lf',[1,l2(3)]);
VALUES= fscanf(fid,'%lfD%d',[2,l2(4)]);
RESULT= VALUES(1,:).*10.^VALUES(2,:);

% testend= fgetl(fid);
% if ~isempty(testend)
%     error('读取失败,HB文件指针与值对应出错，请检查Harwell-Boeing矩阵文件');
% end

fclose(fid);

%======= 2. 组成matlab sparse矩阵
% index_row=zeros(length(ROWIND),1);
COLIND=zeros(length(ROWIND),1);

nn= length(COLPTR)-1; % Number_of_column of actual matrix. 
for in=1:nn
    COLIND(COLPTR(in):COLPTR(in+1)-1)=in;
end

SparseMatrix=sparse( ROWIND',COLIND,RESULT' );


%======= 3. 检查矩阵是否为对角阵（若是，则补全上三角部分）
if l31(2)=='S'
    SparseMatrix=SparseMatrix+SparseMatrix'-diag(diag(SparseMatrix));
end

end % End of function hb2mm.m