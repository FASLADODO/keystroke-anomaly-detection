function pred_scores = manhattan(data,train)

N = size(data,1);
mu = mean(train,1);
a = mean(abs(train-repmat(mu,size(train,1),1)),1);
a(a==0) = 1;
pred_scores = zeros(N,1);

for i=1:N
    pred_scores(i) = sum(abs(data(i,:)-mu)./a);
end

end