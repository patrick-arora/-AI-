clear all;clc;
disp('��������������x:');
x=load('HDF.txt');%��������ľ�����Ϊ������n ��Ϊָ����p������5�����ݼ���ÿ�����г���ѡ��ע�ͼ��ɣ�
% x=load('PWF.txt');
% x=load('OSF.txt');
% x=load('RNF.txt');
%  x=load('TWF.txt');
[n,p] = size(x);  % n������������p��ָ�����
%% ��һ����������x��׼��ΪX
X=zscore(x);   % matlab���õı�׼��������x-mean(x)��/std(x)
%% �ڶ�������������Э�������
R = cov(X);
disp('�������ϵ������Ϊ��')
disp(R)
%% ������������R������ֵ����������
[V,D] = eig(R);  % V ������������  D ����ֵ���ɵĶԽǾ���
v=fliplr(V);      %����D����������������
%% ���Ĳ����������ɷֹ����ʺ��ۼƹ�����
lambda = diag(D);  % diag�������ڵõ�һ����������Խ���Ԫ��ֵ(���ص���������)
lambda = lambda(end:-1:1);  % ��Ϊlambda�����Ǵ�С������ģ����ǽ������ͷ
contribution_rate = lambda / sum(lambda);  % ���㹱����
cum_contribution_rate = cumsum(lambda)/ sum(lambda);   % �����ۼƹ�����  cumsum�����ۼ�ֵ�ĺ���
disp('����ֵΪ��')
disp(lambda')  % ת��Ϊ������������չʾ
disp('������Ϊ��')
disp(contribution_rate')
disp('�ۼƹ�����Ϊ��')
disp(cum_contribution_rate')
disp('������ֵ��Ӧ��������������Ϊ��')
% ע�⣺�������������Ҫ������ֵһһ��Ӧ��֮ǰ����ֵ�൱�ڵߵ������ˣ�������������ĸ�����Ҫ�ߵ�����
%  rot90��������ʹһ��������ʱ����ת90�ȣ�Ȼ����ת�ã��Ϳ���ʵ�ֽ�������еߵ���Ч��
V=rot90(V)';
disp(V)
%% ������������Ҫ�����ɷֵ�ֵ
disp('��������Ҫ��������ɷֵĸ���:  ');
m=input('m=')
F = zeros(n,m);  %��ʼ���������ɷֵľ���ÿһ����һ�����ɷ֣�
for i = 1:m
    ai = V(:,i)';   % ����i����������ȡ������ת��Ϊ������
    Ai = repmat(ai,n,1);   % ������������ظ�n�Σ�����һ��n*p�ľ���
    F(:, i) = sum(Ai .* X, 2);  % ע�⣬�Ա�׼������������Ȩ�غ�Ҫ����ÿһ�еĺ�
end
dr=sort(diag(D),'descend');
S=0;i=0;
while S/sum(dr)<0.85
    i=i+1;
    S=S+dr(i);
end                         %����ۻ������ʴ���85%�����ɷ�
NEW=X*v(:,1:i);              %����������������µ�����
W=100*dr/sum(dr)
figure(1)
pareto(W);                  %���������ʵ�ֱ��ͼ
figure(2)
string_name= {'��','��','��','��','��','��'}; %�ɷ�
string_name1= {'x1','x2','x3','x4','x5','x6'}; %ָ��
xvalues = string_name;
yvalues = string_name1; 
h1 = heatmap(xvalues,yvalues, V, 'FontSize',10, 'FontName','Times New Roman'); 
h1.Title = 'Correlation Coefficient';
map = [1 1 1; 1 1 0; 0.5 1 0.4; 0.2 0.85 0.2; 0.4 0.7 1; 0.2 0.5 0.8]; % �Լ�������ɫ
colormap(map);