clc
clear

Pi = [0,0]; %initial pos.
Pf = [20,30]; %final pos.
psii = -50/57.3; %initial psi
psif = 30/57.3; %final psi.
rho = 2;
dt = 5/57.3; 


r0 = 0+0i;
r1 = 1+0i;
dr0 = rho * exp(i*psii);
dr1 = rho * exp(i*psif);

rho = roots([dr1/dr0, 0, -1]);

alpha = [];
a = [];
b = [];
k = [];
for i = 1:2
    alpha = roots([1, -3*(1+rho(i)), 6*rho(i)^2+2*rho(i)+6-30/dr1]);
    for ii = 1:2
        miu = roots([1, -alpha(ii), rho(i)]);
        a = [a;miu(1)/(miu(1)+1)];
        b = [b;miu(2)/(miu(2)+1)];        
    end
end
k = dr0./a.^2./b.^2;

n = 100;
q = kron(ones(1,4), linspace(0,1,n)');
a = kron(ones(n,1), a');
b = kron(ones(n,1), b');
k = kron(ones(n,1), k');

ta = q-a;
tb = q-b;
r = k/30.*ta.^3.*[ta.^2 - 5.*ta.*tb + 10.*tb.^2] + k/30.*a.^3.*[a.^2 - 5.*a.*b + 10.*b.^2];

x = real(r);
y = imag(r);

% [x,y,kai,l,e,r,amin,bmin,k2min] = PHquint([0,0],[1,0],5,50/57.3,5,0/57.3,1000,0);

figure;hold on;
for i = 1:4
    plot(x(:,i), y(:,i))
end


