clear;
clc;
close all;
loadSaved=false;
img=1;
aa=1;

%%%%load the different index of images which belong to different clusters to extract SURF features for voting procedure%%%

load('TEMP5_1');
%load('TEMP2_1');
% load('TEMP3_1');
% load('TEMP4_1');
% load('TEMP5_1');
% load('TEMP6_1');

peak_thresh = 1;
numOfFeaturesPerImage = 300;

%%%%% Process of Features' Extraction%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(~loadSaved)
    array_vectors=[];
  KOST5=[];  
for i = 1:1:length(TEMP5)
   
    disp('Getting image');
    fileName = [myPath '/' list(TEMP5(i)).name];
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
        
        aa=aa+1;
 
        img = img + 1;
       
    KOST5=[KOST5;features];
end
save('feature1','KOST1','-v7.3');
%save('feature2','KOST2','-v7.3');
%save('feature3','KOST3','-v7.3');
%save('feature4','KOST4','-v7.3');
%save('feature5','KOST5','-v7.3');
end