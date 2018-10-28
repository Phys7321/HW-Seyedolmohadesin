function [I] = Romberg(func,a,b,tol,kmax)
%   function [I] = Romberg(func,a,b,tol,kmax)
%   Romberg integrates function "func" of one variable and nonsingular    
%   from "a" to "b" with tolerance "tol" and maximum order of "kmax". 
%   0 < tol < 1 & kmax > 0. Using Romberg integration.
%  	I = Romberg(@func,a,b,tol,kmax)
%   I = Romberg(@func,a,b,tol)	,	default kmax = 15
%   I = Romberg(@func,a,b)	,	default tol = 1e-10	,	default kmax = 15
%   e.g. 
%   I = Romberg(@sin,0,pi)
%   I = 2.000000000000000
format long
switch nargin
    case 3
        tol = 1e-10;
        kmax = 15;
	case 4
        kmax = 15;
end
tol = abs(tol);
kmax = abs(kmax);
if tol >= 1 || tol == 0 || kmax < 1
	error('Wrong parameters')
end
if isinf(abs(a)) || isinf(abs(b)) || a > b || a == b
	error('Improper interval')
end
R  = zeros(1,kmax+1);
err = 1;
Ip = 0;
k = 0;
while (err > tol*Ip)
    if k==0
        R(k+1) = trapm(func,a,b,k+1,0);
    else
        R(k+1) = trapm(func,a,b,k+1,R(k));
    end
    for j = k:-1:1
        p = 4^(k-j+1);
        R(j) = (p*R(j+1) - R(j))/(p - 1);
    end
    I = R(1);
    if k > 1
        err = abs(I-Ip);
    end
    Ip = I;
    k = k + 1;
    if k == kmax
        warning('Maximum trials exceeded with no convergence');
        break;
    end
end
end

