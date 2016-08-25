function pred_scores = mahalanobis(data,train)

pred_scores = mahal(data,train);

N = size(data,1);
mu = mean(train,1);

normmu = norm(mu);
for i=1:N
    pred_scores(i) = pred_scores(i)/norm(data(i,:))/normmu;
end

end