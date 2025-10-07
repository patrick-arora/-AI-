clear all;clc;
disp('请输入样本数据x:');
x=load('HDF.txt');%我们输入的矩阵行为样本数n 列为指标数p（包含5组数据集，每次运行程序选择注释即可）
% x=load('PWF.txt');
% x=load('OSF.txt');
% x=load('RNF.txt');
%  x=load('TWF.txt');
[n,p] = size(x);  % n是样本个数，p是指标个数
%% 第一步：对数据x标准化为X
X=zscore(x);   % matlab内置的标准化函数（x-mean(x)）/std(x)
%% 第二步：计算样本协方差矩阵
R = cov(X);
disp('样本相关系数矩阵为：')
disp(R)
%% 第三步：计算R的特征值和特征向量
[V,D] = eig(R);  % V 特征向量矩阵  D 特征值构成的对角矩阵
v=fliplr(V);      %依照D重新排列特征向量
%% 第四步：计算主成分贡献率和累计贡献率
lambda = diag(D);  % diag函数用于得到一个矩阵的主对角线元素值(返回的是列向量)
lambda = lambda(end:-1:1);  % 因为lambda向量是从小大到排序的，我们将其调个头
contribution_rate = lambda / sum(lambda);  % 计算贡献率
cum_contribution_rate = cumsum(lambda)/ sum(lambda);   % 计算累计贡献率  cumsum是求累加值的函数
disp('特征值为：')
disp(lambda')  % 转置为行向量，方便展示
disp('贡献率为：')
disp(contribution_rate')
disp('累计贡献率为：')
disp(cum_contribution_rate')
disp('与特征值对应的特征向量矩阵为：')
% 注意：这里的特征向量要和特征值一一对应，之前特征值相当于颠倒过来了，因此特征向量的各列需要颠倒过来
%  rot90函数可以使一个矩阵逆时针旋转90度，然后再转置，就可以实现将矩阵的列颠倒的效果
V=rot90(V)';
disp(V)
%% 计算我们所需要的主成分的值
disp('请输入需要保存的主成分的个数:  ');
m=input('m=')
F = zeros(n,m);  %初始化保存主成分的矩阵（每一列是一个主成分）
for i = 1:m
    ai = V(:,i)';   % 将第i个特征向量取出，并转置为行向量
    Ai = repmat(ai,n,1);   % 将这个行向量重复n次，构成一个n*p的矩阵
    F(:, i) = sum(Ai .* X, 2);  % 注意，对标准化的数据求了权重后要计算每一行的和
end
dr=sort(diag(D),'descend');
S=0;i=0;
while S/sum(dr)<0.85
    i=i+1;
    S=S+dr(i);
end                         %求出累积贡献率大于85%的主成分
NEW=X*v(:,1:i);              %输出产生的新坐标下的数据
W=100*dr/sum(dr)
figure(1)
pareto(W);                  %画出贡献率的直方图
figure(2)
string_name= {'Ⅰ','Ⅱ','Ⅲ','Ⅳ','Ⅴ','Ⅵ'}; %成分
string_name1= {'x1','x2','x3','x4','x5','x6'}; %指标
xvalues = string_name;
yvalues = string_name1; 
h1 = heatmap(xvalues,yvalues, V, 'FontSize',10, 'FontName','Times New Roman'); 
h1.Title = 'Correlation Coefficient';
map = [1 1 1; 1 1 0; 0.5 1 0.4; 0.2 0.85 0.2; 0.4 0.7 1; 0.2 0.5 0.8]; % 自己定义颜色
colormap(map);