function pred_scores = euclidean(data,train)

N = size(data,1);
mu = mean(train,1);
pred_scores = zeros(N,1);

normmu = norm(mu);
for i=1:N
    pred_scores(i) = norm(data(i,:)-mu)/norm(data(i,:))/normmu;
end

end