clear;
close all;

load train;

% Train on individual anomaly detectors
Nusers = 51;
M = 50;
Ntypes = 2;
K=5;
labels1 = zeros(K*(Nusers-1)+length(vallabels)/Nusers,Nusers,M*Ntypes);
labels2 = zeros(K*(Nusers-1)+length(vallabels)/Nusers,Nusers,M*Ntypes);
for i=1:M
    idx = Ntypes*(i-1)+1;
    [eer,sigma1,labels1(:,:,idx),zmfar,sigma2,labels2(:,:,idx)] = ...
        trainpredict(traindata,valdata,vallabels,Nusers,@manhattan,1);
    disp(idx);
    eer,zmfar

    idx = Ntypes*(i-1)+2;
    [eer,sigma1,labels1(:,:,idx),zmfar,sigma2,labels2(:,:,idx)] = ...
        trainpredict(traindata,valdata,vallabels,Nusers,@mahalanobis,1);
    disp(idx);
    eer,zmfar
end

% Ensemble
M = size(valdata,1)/Nusers;
idxval_orig = [];
for i=1:Nusers
   idxval_orig = [idxval_orig, (i-1)*M + (1:K)]; 
end
% Vote
pred_labels1 = mode(labels1,3);
pred_labels2 = mode(labels2,3);
for j=Nusers:-1:1
    idxval = [idxval_orig, (j-1)*M + ((K+1):M)];
    Yval = (vallabels(idxval) == (j-1));
    [tpr1(j),fpr1(j),total1(j)] = errorrates(pred_labels1(:,j),Yval);
    [tpr2(j),fpr2(j),total2(j)] = errorrates(pred_labels2(:,j),Yval);
end
disp(mean(tpr1));
disp(mean(fpr1));
disp(mean(tpr2));
disp(mean(fpr2));