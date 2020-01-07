clear;
clc;
close all;
load('TEMP5_1');
%load('TEMP2_1');
% load('TEMP3_1');
% load('TEMP4_1');
% load('TEMP5_1');
% load('TEMP6_1');
matrix=[0.3];
for i=1:size(matrix,2)
a(i)=matrix(:,i);
t=a(i)*size(temp5,1);
t=round(t);
[ids, C6]=kmeans(temp6,t);
filename=sprintf('C5k%d.mat',i);
save(filename,'C5');
%%%%%%%%%%%%SAVE FOR DIFFERENT SEMANTIC REGIONS%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% filename=sprintf('C4k%d.mat',i);
% save(filename,'C4');

% filename=sprintf('C3k%d.mat',i);
% save(filename,'C3');

% filename=sprintf('C2k%d.mat',i);
% save(filename,'C2');

% filename=sprintf('C1k%d.mat',i);
% save(filename,'C1');
end