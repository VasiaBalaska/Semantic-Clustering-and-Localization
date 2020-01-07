clear;
clc;
close all;
myPath = 'path_images';

temp = dir(myPath);
temp=temp(3:end);

img=1;
aa=1;

peak_thresh = 1;
numOfFeaturesPerImage = 300;

load('feature1');
load('feature2');
load('feature3');
load('feature4');
load('feature5');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  OR use the BoW vectors%%%%%%%%%%%%%%%%%

% load('C1k3');
% load('C2k3');
% load('C3k3');
% load('C4k3');
% load('C5k3');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
features_to_sequence_a1 = ones(size(KOST1,1),1) * 1;
features_to_sequence_a2 = ones(size(KOST2,1),1) * 2;
features_to_sequence_a3 = ones(size(KOST3,1),1) * 3;
features_to_sequence_a4 = ones(size(KOST4,1),1) * 4;
features_to_sequence_a5 = ones(size(KOST5,1),1) * 5;

features_to_sequence = [features_to_sequence_a1; features_to_sequence_a2;features_to_sequence_a3;features_to_sequence_a4;
features_to_sequence_a5];

TEMfinal=[KOST1;KOST2;KOST3;KOST4;KOST5];

m=[];
for i = 1:1:length(temp)
     disp('Getting image');
    fileName = [myPath '/' temp(i).name];
    b = imread(fileName);
                
    b=double(b)/255;
       b=single(rgb2gray(b));
        b=single(b);
        disp('detecting features');
        points = detectSURFFeatures(b);
        disp('getting descriptors');
        [features, validPoints] = extractFeatures(b, points);
        
        disp('retaining only numOfFeaturesPerImage');
        if (size(features,1) > numOfFeaturesPerImage )
            features = features(1:numOfFeaturesPerImage,:);
        end
        
Mdl = ExhaustiveSearcher(TEMfinal);
IdxNN = knnsearch( Mdl,features, 'K',1);

edges=[0 3594, 3595 61706, 61707 148081, 148082  153032, 153033 344387]; %edges=[0....length(KOST1),length(KOST1)....length(KOST2),..... ] 
hist2=histogram(IdxNN,edges);

MAX=max(hist2.Values);
m=[m;hist2.Values];

end

MEGA_N=[];
index=[];
N_iMAGES(:,1)=m(:,1);
N_iMAGES(:,2)=m(:,3);
N_iMAGES(:,3)=m(:,5);
N_iMAGES(:,4)=m(:,7);
N_iMAGES(:,5)=m(:,9);

 for i=1:size(N_iMAGES,1)
     meg=max(N_iMAGES(i,:));
     [M I]=max(N_iMAGES(i,:));
     index=[index;I];
     MEGA_N=[MEGA_N;meg];
 end 

