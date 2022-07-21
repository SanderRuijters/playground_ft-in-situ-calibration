%% Initialize
clear
close all


%% lower triangular
Q_full = ones(6,6);
Q = tril(Q_full)
sum(sum(Q))
21+(21-6)+(21-6-5)+(21-6-5-4)+(21-6-5-4-3)+(21-6-5-4-3-2)
return

%% Vectors r
prime_vector = primes(200)';
r1 = prime_vector(1:6);
r2 = prime_vector(7:12);
r3 = prime_vector(13:18);


%% L
L_size = 7;


%% Q
Q = r1*r1';
Q_vector = reshape(Q,[size(Q,1)*size(Q,2),1]);
Q_unique = unique(Q);
Q_size = length(Q_unique)+L_size;


%% C
C = Q_vector*r1';
C_vector = reshape(C,[size(C,1)*size(C,2),1]);
C_unique = unique(C);

