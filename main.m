clear
clc
%initialization
%syms x(1) x(2) x(3) x(4) x(5) x(6) x(7);%decision variables
G=[1 1 1 0 0 0
    1 1 0 0 0 0
    1 0 1 1 1 0
    0 0 1 1 0 0
    0 0 1 0 1 1
    0 0 0 0 1 1];%services topology
% netplot(G);
[m,n] = size(G);
Pt = [0.01 0.012 0.016 0.08 0.004 0.011];%first selection prob
VL = [0.326 0.245 0.15 0.331 0.414 0.205];%vulnerability of each service
alph = 0.02;%service investing effect
beta = 0.01;%system investing effect
Q = 2700; %gross amount of investment(ten thousands)
kc = [2000 5000 6000 1000 2000 1000];
%loop = [0.01:-0.001:0.0005];%0.2935
loop = 0.01:0.01:0.5;
R_value = zeros(1,length(loop));
Ivest = zeros(1,length(loop));
count_r = 1;
for tt = loop
    IM = [0.1756 tt  0.0773 tt 0.0142 0.1240];%importance degree of each service
    D = kc.*IM;
    Path = cell(1);
    count = 1;
    for i = 1:m
        for j = 1:n
            if i == j
                continue;
            else
                path = allPaths(G,i,j);
                Path{count} = path;
                count = count + 1;
            end
        end
    end
    R = '';
    for i = 1:length(Path)
        pf_nn = Pt(Path{i}(1));
        %d_sys = IM(Path{i}(1));
        str_R = '';
        d = D((Path{i}(1)));%loss when node was invaded
        for j = 2:length(Path{i})
            p_cho = IM(Path{i}(j))/(sum(IM(find(G(Path{i}(j-1),:))))-IM(Path{i}(j-1)));
            str_p_cho = num2str(p_cho);
            str_vl = num2str(VL(Path{i}(j)));
            d = d + D(Path{i}(j));
            str_p_des = strcat(str_vl, '*exp(-', num2str(alph), '*x(', num2str(Path{i}(j)), ')-x(7)*', num2str(beta),')');
            str_R = strcat(str_p_cho, '*', str_p_des, '*', str_R);
        end
        %   R = strcat(strcat(num2str(pf_nn),'*', str_R, num2str(d), '+', num2str(max(VL)), '*exp(-x(7)*', num2str(beta), ')','*', num2str(d_sys)), '+' ,R);
        R = strcat(strcat(num2str(pf_nn),'*', str_R, num2str(d)), '+' ,R);
    end
    R_str = strcat('@(x)', R(1:end-1));
    R_func = str2func(R_str);
    A = [1 1 1 1 1 1 1];
    b = Q;
    [x,fval] = fmincon(R_func, zeros(7,1), A, b);
    R_value(count_r) = fval;
    Ivest(count_r) = x(2);
    count_r = count_r + 1;
end
figure(1)
yyaxis left;
plot(loop,R_value,'+-b');
xlabel('Importance degree of S2');
ylabel('Risk value of SGIS');
yyaxis right;
plot(loop,Ivest,'*-r');
ylabel('Resource allocation of S2(million yuan)');
legend('Risk value','Investment');
% plot(loop,R_value,'r');
% hold on;
% plot(loop,Ivest,'b');






