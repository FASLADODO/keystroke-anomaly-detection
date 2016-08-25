function [eer,sigma1,labels1,zmfar,sigma2,labels2] = trainpredict(traindata,valdata,vallabels,Nusers,func,randomize)

N = size(traindata,1)/Nusers;
d = size(traindata,2);
M = size(valdata,1)/Nusers;
K = 9;
idxval_orig = [];
for i=1:Nusers
   idxval_orig = [idxval_orig, (i-1)*M + (1:K)]; 
end
% Loop over all users
for j=Nusers:-1:1    
    % Get training and validation sets
    offset = (j-1)*N;
    if (randomize == 1)
        idx = offset + randi(N,N,1);
        idxd = randperm(d,round(sqrt(d)));
    elseif (randomize == 2)
        idx = offset + (1:N);
        idxd = randperm(d,round(sqrt(d)));
    else
        idx = offset + (1:N);
        idxd = 1:d;
    end
    
    Xtrain = traindata(idx,idxd);
    idxval = [idxval_orig, (j-1)*M + ((K+1):M)];
    Yval = (vallabels(idxval) == (j-1));
    
    tpr = [];
    fpr = [];
    
    % Predict scores
    pred_scores = func(valdata(idxval,idxd),Xtrain);
    
    % Set thresholds
    threshold = linspace(min(pred_scores),max(pred_scores),100);
    
    % Predict labels
    for i=length(threshold):-1:1
        pred_labels = (pred_scores < threshold(i));
        [tpr(i),fpr(i)] = errorrates(pred_labels,Yval);
    end
    
    % Find equal error rate
    [~,idx] = min(abs(1-tpr-fpr));
    eer(j) = (fpr(idx)+1-tpr(idx))/2;
    % Get predictions
    labels1(:,j) = (pred_scores < threshold(idx));
    
    % Find zero-miss false-alarm rate
    [~,idx] = find(tpr == 1,1,'last');
    zmfar(j) = fpr(idx);
    % Get predictions
    labels2(:,j) = (pred_scores < threshold(idx));
    
end

[eer,sigma1,zmfar,sigma2] = errorstats(eer,zmfar);

end