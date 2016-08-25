function [tpr,fpr,total] = errorrates(pred_labels,val_labels)

% The hit rate is the frequency with which impostors
% are detected (i.e., 1 ? miss rate)

% the false-alarm rate is the frequency with which
% genuine users are mistakenly detected as impostors.

% falsepos = sum((pred_labels == 1) & (val_labels == 0))/sum(val_labels == 0);
% falseneg = sum((pred_labels == 0) & (val_labels == 1))/sum(val_labels == 1);
%
% tpr = 1-falseneg;
% fpr = falsepos;
%
% total = sum(pred_labels ~= val_labels)/numel(val_labels);

if (sum(val_labels == 1) == 0)
    falsepos = 0;
else
    falsepos = sum((pred_labels == 0) & (val_labels == 1))/sum(val_labels == 1);
end

if (sum(val_labels == 0) == 0)
    falseneg = 0;
else
    falseneg = sum((pred_labels == 1) & (val_labels == 0))/sum(val_labels == 0);
end

tpr = 1-falseneg;
fpr = falsepos;

total = sum(pred_labels ~= val_labels)/numel(val_labels);

end