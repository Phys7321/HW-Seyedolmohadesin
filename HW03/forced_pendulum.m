function [period,sol] = forced_pendulum(R,theta0,thetad0,grph,gamma,freq) 
%Modify: Finds the period of a nonlinear pendulum given the length of the pendulum
% arm and initial conditions. All angles in radians.
% gamma is damping coefficient
%freq is the angular frequency of the external force
%Setting initial conditions
if nargin==0
    error('Must input length and initial conditions')
end
if nargin==1
   theta0 = pi/2;
   thetad0=0;
   grph=0;
end
if nargin==2
    thetad0 = 0;
    grph=1;
end
if nargin==3
    grph=1;
end
g=9.81;
omega = sqrt(g/R);
T= 2*pi/omega;
% number of oscillations to graph
N = 20;




tspan = [0 N*T];
if gamma >= 4
    
    opts = odeset('events',@events,'refine',6); % stops at equilibrium
else 

    opts = odeset('refine',6);
end    
r0 = [theta0 thetad0];
[t,w] = ode45(@(t,w) proj(t,w,g,R,gamma,freq),tspan,r0,opts);
sol = [t,w];
ind= find(w(:,2).*circshift(w(:,2), [-1 0]) <= 0);

period=0;
if gamma < 4 
l=length(ind) ;
l=int16(l/2);% using the second half of the data which represents the steady state    
ind = ind(end-l:end-2); %Truncating spurious indices
k = 1:2:length(ind); % getting every other indice
ind = ind(k);
period= mean(diff(t(ind)));

end
 
    E0 = 0.5 .* R.^2 .* thetad0 .^2 + g .* R .* (1-cos(theta0));  % Initial energy of the pendulum

    KE = 0.5 .* R.^2 .* w(:,2).^2 ; % Kinetic Energy
    U = g .* R .* (1-cos(w(:,1))) ; % Potential Energy
    E=KE+U; % Total Energy in one cycle

    deltaE= (E(:) - E0) ./ E0; % function delta 



if grph % Plot Solutions of exact and small angle
    
  %{
  if length(ind) > 3
        
        f2=figure ('Name', 'energy');
    
        subplot(2,1,1)
        plot(t(ind(1):ind(3)),deltaE,'m:')
        title('\Delta')
        xlabel('t')
        ylabel( '\Delta')
    
        subplot(2,1,2)
        plot(t(ind(1):ind(3)),KE, 'c-', t(ind(1):ind(3)), U, 'm-')
        legend('Kinetic Energy','Potential Energy')
        xlabel('t')
    end
    
    %}
    f3=figure ('Name', 'Velocity and Position');
    
   
    
    subplot(2,1,1)
    plot(t, w(:,1),'m-')
    title('\theta (t) ')
    xlabel('t')
    ylabel( '\theta')
    
     subplot(2,1,2)
    plot(t, w(:,2),'c-')
    title('$\dot{\theta (t)}$ ', 'Interpreter','latex')
    xlabel('t')
    ylabel('$\dot{\theta}$', 'Interpreter','latex')
    
    f4 =figure('Name', 'Phase Space');
    
    plot(w(:,1),w(:,2));
    title('Phase Space ')
    ylabel('$\dot{\theta}$', 'Interpreter','latex')
    xlabel('\theta')
end
end
%-------------------------------------------
%
function rdot = proj(t,r,g,R,gamma,freq)
    rdot = [r(2); (-g/R*sin(r(1)) - (gamma .* r(2))+cos(freq .* t))];
end

%-------------------------------------------
function [value,isterminal,direction] = events(t,w)
% Locate the time when height passes through zero in
% a decreasing direction and stop integration.  
value = (w(1)-0.0001);     % detect height = 0
isterminal = 1;   % stop the integration
direction = -1;   % negative direction
end
