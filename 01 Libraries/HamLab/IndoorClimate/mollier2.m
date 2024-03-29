function y=mollier2(time1,temp1,rh1,tit,sn,e);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plots data into a mollier diagram, using data points and weekly averages
% january 19, 2005, TUe, PBE, MM and JvS
% mollier2(time1,temp1,rh1,title,filename,[0;0;0;0;0;0;1;0;0;0])
%                                          ASHRAE A  Thomson1
%                                            ASHRAE B  Thomson2
%                                              ASHRAE C  Deltaplan
%                                                ASHRAE D  Mecklenburg
%                                                  Jutte     Lafontaine        (none, one or more can be '1')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s=conversion(temp1,[],rh1,time1);
global astat seasons sstat months mstat weeks wstat days dstat
statistics(s)                                                   % statistics
    a=1;                                                        % T = T air
    b=8;                                                        % x = x air
starttime=s(1,10);
endtime=s(length(s(:,10)),10);
start=datevec(starttime);
stop=datevec(endtime);
ts=floor(datestr(datenum(start(1),start(2),start(3),0,0,0)));
te=floor(datestr(datenum(stop(1),stop(2),stop(3),0,0,0)));
dates=sprintf('Mollierdiagram, %s to %s',ts,te);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mollierdiagram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=[1:11]                                                    % sets temperature matrix, 1 cell = 1 degree
    for h=[1:81]                                                % -20 up to 60 degrees Celsius
    T(h,j)=(h-21);
    end
end
for i=[1:81];
RV(i,[1:11])=[0:0.1:1];                                         % sets humidity matrix, in steps of 10%
end
for k=[1:11]                                                    % calculates p for each temperature and humidity
    for l=[1:20]
    p(l,k)=611*exp(22.44*T(l,1)./(272.44+T(l,1)))*RV(l,k);
    end
    for l=[21:81]
    p(l,k)=611*exp(17.08*T(l,1)./(234.18+T(l,1)))*RV(l,k);
    end
    for m=[1:81]
    x(m,k)=611*p(m,k)./(101300-p(m,k));                         % calculates moisture content for each p
    end
end
figure                                                          % opens new plot window
contour(x,T,RV,RV(1,:));                                        % plots isoRHlines in plot
axis([0 25 -1 31]);                                             % sets axis xmin, xmax, Tmin, Tmax
NewPosition=[0 0 'PaperSize'];                                  % sets paper margins to zero
orient tall                                                     % stretches figure to A4-size
hold on                                                         % freezes figure (so other plots can be put in without deleting previous plots)
legstr=[];                                                      % creates empty matrix to put legenddata in
plot(seasons(:,b,1),seasons(:,a,1),'.','color',[.6 .6 1])       % plots winter data light blue
legstr=[legstr;'Winter Measurements  '];
plot(seasons(:,b,2),seasons(:,a,2),'.','color',[1 .8 .5])       % plots spring data light orange
legstr=[legstr;'Spring Measurements  '];
plot(seasons(:,b,3),seasons(:,a,3),'.','color',[1 .7 .7])       % plots summer data light red
legstr=[legstr;'Summer Measurements  '];
plot(seasons(:,b,4),seasons(:,a,4),'.','color',[.8 .6 .8])      % plots light purple
legstr=[legstr;'Autumn Measurements  '];
w1([1:14])=wstat(3,b,[52 53 1:12]);
w2([1:14])=wstat(3,a,[52 53 1:12]);
plot(w1,w2,'o','color',[0 0 .8],'LineWidth',[1.5])              % plots weekly winter average blue 
legstr=[legstr;'Winter Weekly Average'];
w3([1:13])=wstat(3,b,[13:25]);
w4([1:13])=wstat(3,a,[13:25]);
plot(w3,w4,'*','color',[1 .5 .1],'LineWidth',[1.5])             % plots weekly spring average orange
legstr=[legstr;'Spring Weekly Average'];
w5([1:13])=wstat(3,b,[26:38]);
w6([1:13])=wstat(3,a,[26:38]);
plot(w5,w6,'>','color',[.8 0 0],'LineWidth',[1.5])              % plots weekly summer average red
legstr=[legstr;'Summer Weekly Average'];
w7([1:13])=wstat(3,b,[39:51]);
w8([1:13])=wstat(3,a,[39:51]);
plot(w7,w8,'+','color',[.6 0 .6],'LineWidth',[1.5])             % plots weekly autumn average purple
legstr=[legstr;'Autumn Weekly Average'];
t1=title(tit);
set(t1,'FontSize',20);
xlabel(['Specific Humidity [g/kg]'])
ylabel('Dry Bulb Temperature [�C]')
undertext=text(12.5,-3.5,dates);
set(undertext,'FontSize',16,'VerticalAlignment','top','HorizontalAlignment','center');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A number of demands based on literature
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if length(e)==8
Teis([1:(e(2)-e(1))*2+3])=[[e(1):1:e(2)] [e(2):-1:e(1)] e(1)];
d3=length(Teis)-1;                                                          % calculates T and x for the given demand
for d=[1:(d3/2)]
peis([d])=6.11*exp(17.08*Teis(d)./(234.18+Teis(d)))*e(5);
peis([d3/2+d])=6.11*exp(17.08*Teis(d3/2+d)./(234.18+Teis(d3/2+d)))*e(6);
end
peis(d3+1)=peis(1);
for d2=[1:(length(Teis))]
xeis(d2)=611*peis(d2)./(101300-peis(d2));
end
legstr=[legstr;'  Other Demand       '];
plot(xeis,Teis,'-','color',[0 0 1],'LineWidth',[2])
else
if e(1)==1;%ashrae A                                                       % museum climate according to ASHRAE A
TaA([1:23])=[[15:1:25] [25:-1:15] 15];                                     % minimum T, T step, maximum T, Tstep, minimum T
for ashA1=[1:11]                                                           % T minimum upto T maximum
paA([ashA1])=6.11*exp(17.08*TaA(ashA1)./(234.18+TaA(ashA1)))*45;           % last number = minimum RH
paA([11+ashA1])=6.11*exp(17.08*TaA(11+ashA1)./(234.18+TaA(11+ashA1)))*55;  % last number = maximum RH
end
paA(23)=paA(1);
for ashA2=[1:23]
xaA(ashA2)=611*paA(ashA2)./(101300-paA(ashA2));
end
plot(xaA,TaA,'-','color',[.7 .7 .7],'LineWidth',[3])
legstr=[legstr;'  ASHRAE class A     '];
end
if e(2)==1;%ASHRAE B                                                       % museum climate according to ASHRAE B
TaB([1:23])=[[15:1:25] [25:-1:15] 15];                                     % minimum T, T step, maximum T, Tstep, minimum T
for ashB1=[1:11]                                                           % T minimum upto T maximum
paB([ashB1])=6.11*exp(17.08*TaB(ashB1)./(234.18+TaB(ashB1)))*40;           % last number = minimum RH
paB([11+ashB1])=6.11*exp(17.08*TaB(11+ashB1)./(234.18+TaB(11+ashB1)))*60;  % last number = maximum RH
end
paB(23)=paB(1);
for ashB2=[1:23]
xaB(ashB2)=611*paB(ashB2)./(101300-paB(ashB2));
end
plot(xaB,TaB,'-','color',[.7 .7 .7],'LineWidth',[2])
legstr=[legstr;'  ASHRAE class B     '];
end
if e(3)==1;%ashrae C                                                       % museum climate according to ASHRAE C
TaC([1:23])=[[15:1:25] [25:-1:15] 15];                                     % minimum T, T step, maximum T, Tstep, minimum T
for ashC1=[1:11]                                                           % T minimum upto T maximum
paC([ashC1])=6.11*exp(17.08*TaC(ashC1)./(234.18+TaC(ashC1)))*25;           % last number = minimum RH
paC([11+ashC1])=6.11*exp(17.08*TaC(11+ashC1)./(234.18+TaC(11+ashC1)))*75;  % last number = maximum RH
end
paC(23)=paC(1);
for ashC2=[1:23]
xaC(ashC2)=611*paC(ashC2)./(101300-paC(ashC2));
end
plot(xaC,TaC,'--','color',[.7 .7 .7],'LineWidth',[2])
legstr=[legstr;'  ASHRAE class C     '];
end
if e(4)==1;%ashrae D                                                       % museum climate according to ASHRAE D
TaD([1:23])=[[15:1:25] [25:-1:15] 15];                                     % minimum T, T step, maximum T, Tstep, minimum T
for ashD1=[1:11]                                                           % T minimum upto T maximum
paD([ashD1])=6.11*exp(17.08*TaD(ashD1)./(234.18+TaD(ashD1)))*0;            % last number = minimum RH
paD([11+ashD1])=6.11*exp(17.08*TaD(11+ashD1)./(234.18+TaD(11+ashD1)))*75;  % last number = maximum RH
end
paD(23)=paD(1);
for ashD2=[1:23]
xaD(ashD2)=611*paD(ashD2)./(101300-paD(ashD2));
end
plot(xaD,TaD,'-.','color',[.7 .7 .7],'LineWidth',[2])
legstr=[legstr;'  ASHRAE class D     '];
end
if e(5)==1;%jutte                                                          % museum climate according to Ton Jutte
Tjutte([1:49])=[[2:1:25] [25:-1:2] 2];                                     % minimum T, T step, maximum T, Tstep, minimum T, minumum T
for j1=[1:24]                                                              % T minimum upto T maximum
pjutte([j1])=6.11*exp(17.08*Tjutte(j1)./(234.18+Tjutte(j1)))*49;           % last number = minimum RH
pjutte([24+j1])=6.11*exp(17.08*Tjutte(24+j1)./(234.18+Tjutte(24+j1)))*55;  % last number = maximum RH
end
pjutte(49)=pjutte(1);
for j2=[1:49]
xjutte(j2)=611*pjutte(j2)./(101300-pjutte(j2));
end
legstr=[legstr;'  ICN Ton J�tte      '];
plot(xjutte,Tjutte,'--','color',[0 0 0],'LineWidth',[2])
end
if e(6)==1;%thomson class 1                                                % museum climate according to Thomson class 1
Tth1([1:13])=[[19:1:24] [24:-1:19] 19];                                    % minimum T, T step, maximum T, Tstep, minimum T, minumum T
for ta1=[1:6]                                                              % T minimum upto T maximum
pth1([ta1])=6.11*exp(17.08*Tth1(ta1)./(234.18+Tth1(ta1)))*50;              % last number = minimum RH
pth1([6+ta1])=6.11*exp(17.08*Tth1(6+ta1)./(234.18+Tth1(6+ta1)))*55;        % last number = maximum RH
end
pth1(13)=pth1(1);
for ta2=[1:13]
xth1(ta2)=611*pth1(ta2)./(101300-pth1(ta2));
end
legstr=[legstr;'  Thomson class 1    '];
plot(xth1,Tth1,'-','color',[.3 .3 .3],'LineWidth',[2])
end
if e(7)==1;%thomson class 2                                                % museum climate according to Thomson class 2
Tth2([1:163])=[[-20:1:60] [60:-1:-20] -20];                                % minimum T, T step, maximum T, Tstep, minimum T, minumum T
for tb2=[1:81]                                                             % T minimum upto T maximum
xth2(tb2)=x(tb2,5);                                                        % column 5 of x = minimum RH
xth2(tb2+81)=x(82-tb2,8);                                                  % column 7 of x = maximum RH
end
xth2(163)=xth2(1);
legstr=[legstr;'  Thomson class 2    '];
plot(xth2,Tth2,'-','color',[.3 .3 .3],'LineWidth',[3])
end
if e(8)==1;%RGD Deltaplan                                                  % museum climate according to RGD Deltaplan
Trgd([1:7])=[[18:1:20] [20:-1:18] 18];                                     % minimum T, T step, maximum T, Tstep, minimum T, minumum T
for rgd1=[1:3]                                                             % T minimum upto T maximum
prgd([rgd1])=6.11*exp(17.08*Trgd(rgd1)./(234.18+Trgd(rgd1)))*50;           % last number = minimum RH
prgd([3+rgd1])=6.11*exp(17.08*Trgd(3+rgd1)./(234.18+Trgd(3+rgd1)))*60;     % last number = maximum RH
end
prgd(7)=prgd(1);
for rgd2=[1:7]
xrgd(rgd2)=611*prgd(rgd2)./(101300-prgd(rgd2));
end
legstr=[legstr;'  RGD Deltaplan      '];
plot(xrgd,Trgd,'-','color',[0 0 1],'LineWidth',[2])
end
if e(9)==1;%Marion Mecklenburg                                             % museum climate according to Marion Mecklenburg
Tmm([1:9])=[[20:1:23] [23:-1:20] 20];                                      % minimum T, T step, maximum T, Tstep, minimum T, minumum T
for mm1=[1:4]                                                              % T minimum upto T maximum
pmm([mm1])=6.11*exp(17.08*Tmm(mm1)./(234.18+Tmm(mm1)))*35;                 % last number = minimum RH
pmm([4+mm1])=6.11*exp(17.08*Tmm(4+mm1)./(234.18+Tmm(4+mm1)))*60;           % last number = maximum RH
end
pmm(9)=pmm(1);
for mm2=[1:9]
xmm(mm2)=611*pmm(mm2)./(101300-pmm(mm2));
end
legstr=[legstr;'  Marion Mecklenburg '];
plot(xmm,Tmm,'-','color',[0 1 0],'LineWidth',[2])
end
if e(10)==1;%Canadian Conservation Institute, Lafontaine                   % museum climate according to CCI Lafontaine
Tcci([1:13])=[[20:1:25] [25:-1:20] 20];                                    % minimum T, T step, maximum T, Tstep, minimum T, minumum T
for cc1=[1:6]                                                              % T minimum upto T maximum
pcci([cc1])=6.11*exp(17.08*Tcci(cc1)./(234.18+Tcci(cc1)))*35;              % last number = minimum RH
pcci([6+cc1])=6.11*exp(17.08*Tcci(6+cc1)./(234.18+Tcci(6+cc1)))*58;        % last number = maximum RH
end
pcci(13)=pcci(1);
for cc2=[1:13]
xcci(cc2)=611*pcci(cc2)./(101300-pcci(cc2));
end
legstr=[legstr;'  CCI Lafontaine     '];
plot(xcci,Tcci,'-','color',[1 0 0],'LineWidth',[2])
end
end
l=legend([legstr],4 );                                                     % creates legend containing all legstrings in lower right corner
set(l,'FontSize',7);                                                       % sets legend fontsize to 7
text(x(48,2),27,'10%')                                                     % creates text label for each isoRHline
text(x(48,3),27,'20%')
text(x(48,4),27,'30%')
text(x(48,5),27,'40%')
text(x(48,6),27,'50%')
text(x(48,7),27,'60%')
text(x(48,8),27,'70%')
text(x(48,9),27,'80%')
text(x(48,10),27,'90%')
text(x(48,11),27,'100%')
grid;                                                                      % turns grid on
hold off;
name=sprintf('%smollier',sn);                                       % creates filename: inputfilename-mollier-variable
if exist(datestr(floor(now)),'file')==0                                    % creates new folder with name=current date
   mkdir(datestr(floor(now)));
end
cd(datestr(floor(now)))                                                    % loads folder
print('-dtiff','-r250',name)                                               % saves plot, -rDPI = output resolution
clear a b file1 file2 seasons wstat                                        % empties workspace
cd ..                                                                      % back to previous folder