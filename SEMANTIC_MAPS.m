clear;
clc;
close all;
load('VideoTable.mat');%histogramms descriptors of images
temp=dir('path_images');
temp=temp(3:end);
temp(1).name;

%%%%%%%%%%%%%%extract_odometry%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:1:length(temp)
   
    
        temp(i).name
        c1=strsplit(temp(i).name,'x');
        c2=strsplit(c1{2},'y');
        x_s(i)=str2double(c2{1}(1:end-1));
        x1_s=x_s';
        c3=strsplit(c2{2},'a');
        y_s(i)=str2double(c3{1}(1:end-1));
       y1_s=y_s';
      x1_s(:,2)=y1_s;
      xy =x1_s(:,:);
      xy(1:i,3)=0;
      coordinates=xy(:,:);
end

inputFilesPath = 'path_of_simVectorSeq_out.txt';
%xyz = coordinates;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fid = fopen(inputFilesPath);
    tline = fgets(fid);
    tline = fgets(fid);
    tline = fgets(fid);
    tline = fgets(fid); 
    fclose(fid);
    C = strsplit(tline, ':');
    C = strsplit(C{2});
    if (isempty(C{end}))
       C = C(1:end-1);
    end
    C = str2double(C);
    
    flag = false;
    if(isnan(C)) % if we only have one modularity
        flag = true;
    else
        maxModul = -10000;
        maxModul_id = 0;
        for i = 1:length(C)
            if(C(i)>maxModul)
                maxModul = C(i);
                maxModul_id = i;
            end
        end
    end


    M = dlmread(inputFilesPath, '\t', 4, 0);
    
    if(flag)
        clusteringResult = M;
    else
        firstIdxPerModularity = find(M(:, 1)==0);
        firstIdxPerModularity = [firstIdxPerModularity; size(M, 1)+1]; % one extra as if there where another clustering result.

        clusteringResult = M(firstIdxPerModularity(maxModul_id):firstIdxPerModularity(maxModul_id+1)-1, :);
    end

    ClusterIds = unique(clusteringResult(:,2));
    numOfClusters = length(ClusterIds);

    rng('default');
    colors1 = jet(numOfClusters);
    colors1= colors1(randperm(size(colors1, 1)), :);
    colors2 = jet(19);
    colors2 = colors2(randperm(size(colors2, 1)), :);
    figure(1);hold on; 
%%%%%%%%%%%%%%%%%%%%%%%%%LOUVAIN_SEMANTIC_MAP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   id = 1;
    for i = 1:length(ClusterIds)     
        currentClusterIdxs = find(clusteringResult(:,2) == ClusterIds(i));
        classes1(i).original = currentClusterIdxs;
        clasId = 1;
        counter = 1;

        for j=1:size(classes1(i).original,1)-1
         if j==1
          new_classes(i).subclusters(counter, clasId)=classes1(i).original(1);
          counter = counter+1;
         end
        
            d_k(j,i)=classes1(i).original(j+1)- classes1(i).original(j);
              if j~=1
                  if d_k(j,i)~=1   
                    new_classes(i).subclusters(counter, clasId)=classes1(i).original(j);
                    clasId = clasId + 1;
                    counter = 1;
                  end                             
                  
              end
                new_classes(i).subclusters(counter, clasId)=classes1(i).original(j+1);
                counter = counter+1;
                id=1;
          for p=1:size(new_classes(i).subclusters,2)
            k(i)=id;
            id=id+1;
           
          end
            t_k=k(:);
        
        acc=0;
          for s=1:length(t_k)
            acc= acc+t_k(s);
          end
          for p1=1:size(new_classes(i).subclusters,1)
           for p2=1:size(new_classes(i).subclusters,2)
               final(p1,acc(1,1))=new_classes(i).subclusters(p1,p2);
           end
          end
   
        end
        plot3(xyz(currentClusterIdxs, 1), xyz(currentClusterIdxs, 2), xyz(currentClusterIdxs, 3), '*', 'color', colors1(i,:));
     end     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Title('Old_Clusters');
axis equal;
hold off;
%%%%%%%%%%%%%%%%%%%%%TEMPORAL_CONSISTENCY_SEMANTIC_MAP%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2);hold on;
      for v2=1:size(final,2)
          temp=final(:,v2);
          ids=find(temp~=0);
          temp=temp(ids);
          plot3(xyz(temp, 1), xyz(temp, 2), xyz(temp, 3), '*', 'color', colors2(v2,:));  
      end

axis equal;
hold off;
axis equal;
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   PROCESS OF AGGLOMERATIVE HIERARCHICAL%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xyz=coordinates;
temp1=[];
meanX_all=[];
meanY_all=[];
metr=1;

counterx=1;
      acc1=0;
x1=[];
 for v2=1:size(final,2)
          temp=final(:,v2);
          ids=find(temp~=0);
           temp=temp(ids);
           
            x=xyz(temp, 1);
            y=xyz(temp, 2); 
          acc=0; 
          
      for j=1:length(x)
            acc=acc+x(j);
                        
             
      end
      meanx=acc/length(x);
         meanX_all=[meanX_all;meanx];
          acc1=0;
         for j1=1:length(y)
            acc1=acc1+y(j1);
                       
         end
            meany=acc1/length(y);
          meanY_all=[meanY_all; meany]; 
         
                
         
   end 
    
      MEAN(:,1)=meanX_all;
      MEAN(:,2)=meanY_all;

X = MEAN(:,:);



Y = pdist(X)

squareform(Y)

Z = linkage(Y)
dendrogram(Z)
c = cophenet(Z,Y)

Y = pdist(X,'cityblock');
Z = linkage(Y,'average');
c = cophenet(Z,Y)
Y = pdist(X);
Z = linkage(Y);


I = inconsistent(Z)

T = cluster(Z,'cutoff', 0.71)
%T = cluster(Z,'maxclust',5)
save('T1','T');

MT=max(T);
temp1(size(T,1),MT)=zeros;
% pause;
% temp1=[];
    for j=1:MT
    temp=find(T==j);
    ids=temp;
    agllomerative(j).clusters=ids
%     temp1=[temp1;ids];
% temp1(:,j)==ids(:,1);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%1_merge_cluster%%%%%%%
    mergeclusters1=final(:,[agllomerative(1).clusters(1,1) agllomerative(1).clusters(2,1)]);
    mergeclusters1=mergeclusters1(:);
    
        temp1_1=mergeclusters1(:,:);
        ids1=find(temp1_1~=0);
        temp1_1=temp1_1(ids1);
        d_k1=VideoTable_fr_300(temp1_1);
        mean1=0;
        for k1=1:length(d_k1)-1
            mean1=mean1+d_k1(k1).histogram;
        end
        mesos1=mean1/size(d_k1,1);
        new_mesos1=mesos1/norm(mesos1);
              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mergeclusters2=final(:,[agllomerative(2).clusters(1,1) agllomerative(2).clusters(2,1)]);
    mergeclusters2=mergeclusters2(:);
    
        temp2_1=mergeclusters2(:,:);
        ids2=find(temp2_1~=0);
        temp2_1=temp2_1(ids2);
        d_k2=VideoTable_fr_300(temp2_1);
        mean2=0;
        for k2=1:length(d_k2)-1
            mean2=mean2+d_k2(k2).histogram;
        end
        mesos2=mean2/size(d_k2,1);
        new_mesos2=mesos2/norm(mesos2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mergeclusters3=final(:,[agllomerative(3).clusters(1,1) ]);
    mergeclusters3=mergeclusters3(:);
    
        temp3_1=mergeclusters3(:,:);
        ids3=find(temp3_1~=0);
        temp3_1=temp3_1(ids3);
        d_k3=VideoTable_fr_300(temp3_1);
        mean3=0;
        for k3=1:length(d_k3)-1
            mean3=mean3+d_k3(k3).histogram;
        end
       mesos3=mean3/size(d_k3,1);
        new_mesos3=mesos3/norm(mesos3);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mergeclusters4=final(:,[agllomerative(4).clusters(1,1)]);
    mergeclusters4=mergeclusters4(:);
    
        temp4_1=mergeclusters4(:,:);
        ids4=find(temp4_1~=0);
        temp4_1=temp4_1(ids4);
        d_k4=VideoTable_fr_300(temp4_1);
        mean4=0;
        for k4=1:length(d_k4)-1
            mean4=mean4+d_k4(k4).histogram;
        end
        mesos4=mean4/size(d_k4,1);
        new_mesos4=mesos4/norm(mesos4);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     mergeclusters5=final(:,[[agllomerative(5).clusters(1,1) agllomerative(5).clusters(2,1)] agllomerative(5).clusters(3,1) agllomerative(5).clusters(4,1)]);
    mergeclusters5=mergeclusters5(:);
    
        temp5_1=mergeclusters5(:,:);
        ids5=find(temp5_1~=0);
        temp5_1=temp5_1(ids5);
        d_k5=VideoTable_fr_300(temp5_1); 
        mean5=0;
        for k5=1:length(d_k5)-1
            mean5=mean5+d_k5(k5).histogram;
        end
        mesos5=mean5/size(d_k5,1);
        new_mesos5=mesos5/norm(mesos5);
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   mergeclusters6=final(:,[agllomerative(6).clusters(1,1) agllomerative(6).clusters(2,1) agllomerative(6).clusters(3,1) ]);
    mergeclusters6=mergeclusters6(:);
    
        temp6_1=mergeclusters6(:,:);
        ids6=find(temp6_1~=0);
        temp6_1=temp6_1(ids6);
        d_k6=VideoTable_fr_300(temp6_1);
        mean6=0;
        for k6=1:length(d_k6)-1
            mean6=mean6+d_k6(k6).histogram;
        end
        mesos6=mean6/size(d_k6,1);
        new_mesos6=mesos6/norm(mesos6);
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        mean(1,:)=new_mesos1;
        mean(2,:)=new_mesos2;
        mean(3,:)=new_mesos3;
        mean(4,:)=new_mesos4;
        mean(5,:)=new_mesos5;
        mean(6,:)=new_mesos6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot3(AGGLOMERATIVE & LOUVAIN)%%%%%%%%%%%%%%%%%%%
figure(3);hold on;
plot3(xyz(temp1_1, 1), xyz(temp1_1, 2), xyz(temp1_1, 3), '*', 'color', colors2(1,:));  
plot3(xyz(temp2_1, 1), xyz(temp2_1, 2), xyz(temp2_1, 3), '*', 'color', colors2(2,:));
plot3(xyz(temp3_1,1), xyz(temp3_1,2), xyz(temp3_1,3), '*', 'color', colors2(2,:));
plot3(xyz(temp4_1, 1), xyz(temp4_1, 2), xyz(temp4_1, 3), '*', 'color', colors2(4,:)); 
plot3(xyz(temp5_1, 1), xyz(temp5_1, 2), xyz(temp5_1, 3), '*', 'color', colors2(5,:));
plot3(xyz(temp6_1, 1), xyz(temp6_1, 2), xyz(temp6_1, 3), '*', 'color', colors2(6,:));
% plot3(xyz(temp7_1, 1), xyz(temp7_1, 2), xyz(temp7_1, 3), '*', 'color', colors2(7,:));  
% plot3(xyz(temp8_1, 1), xyz(temp8_1, 2), xyz(temp8_1, 3), '*', 'color', colors2(8,:));  
% plot3(xyz(temp9_1, 1), xyz(temp9_1, 2), xyz(temp9_1, 3), '*', 'color', colors2(8,:));
% plot3(xyz(temp10_1, 1), xyz(temp10_1, 2), xyz(temp10_1, 3), '*', 'color', colors2(8,:));
axis equal;
hold off;
axis equal;
hold off;
TEMP1=[temp1_1];
TEMP2=[temp2_1;temp3_1];
TEMP3=[temp4_1];
TEMP4=[temp5_1];
TEMP5=[temp6_1];

save('TEMP1_1','TEMP1');%images_cluster1
save('TEMP2_1','TEMP2');%images_cluster2
save('TEMP3_1','TEMP3');%images_cluster3
save('TEMP4_1','TEMP4');%images_cluster4
save('TEMP5_1','TEMP5');%images_cluster5



