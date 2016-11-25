%HAMLABMOLLIER2 Incuding Energy and Power values
%
% hamlabmollier2(BASE,Output,zonenr,name,sn,demand,)
%
% BASE      :  HAMBase BASE structure
% Output    :  HAMBase Output structure
% zonenr    :   Zone nr
% name      :   title
% sn        :   name of .tiff file
% demand    :
% demand to compare with: 'comfort'  'ashreaa'  'ashraeb'  'ashraec' 'ashraed'
%              'thomson1'  'thomson2'  'jutte'  'rgd'  'icn'  'mecklenburg'
%               or [Tmin Tmax deltaThour deltaTday RHmin RHmax deltaRHhour deltaRHday]
%  varargin: if there's an extra input which has value 1, the histograms won't be plotted
 



function hamlabmollier2(BASE,Output,zonenr,name,sn,demand,varargin)



nt=1:length(Output.Ta(:,zonenr));
time=datenum(2004,1,1) + nt'/24; 

molliernieuw2(time,Output.Ta(:,zonenr),100*Output.RHa(:,zonenr),name,sn,demand,varargin);

[Em3m3,PWm3]=enpowfun(BASE,Output,zonenr);

if isempty(varargin)
     histo=1;
 else histo=0;
end


if histo==0
    subplot(1,1,1)
else
    subplot(4,5,[1 2 3 4 6 7 8 9 11 12 13 14 16 17 18 19])% devides plotwindow in parts
end

text(22.5-5,19,'Energy [m�gas/m�building]','Color',1/255*[3 51 148],'HorizontalAlignment','center')
text(22.5-5,18,sprintf('%5.2f',Em3m3(2)),'HorizontalAlignment','center','VerticalAlignment','middle','Color',1/255*[30 51 148]);
text(21-5,17,sprintf('%5.2f',Em3m3(3)),'Color',1/255*[30 51 148],'HorizontalAlignment','center','VerticalAlignment','middle');
text(22.5-5,16,sprintf('%5.2f',Em3m3(1)),'Color',1/255*[30 51 148],'HorizontalAlignment','center','VerticalAlignment','middle');
text(24-5,17,sprintf('%5.2f',Em3m3(4)),'HorizontalAlignment','center','VerticalAlignment','middle','Color',1/255*[30 51 148]);

text(22.5-5,19-5,'Power [W/m�building]','Color',1/255*[13 51 148],'HorizontalAlignment','center')
text(22.5-5,18-5,sprintf('%5.2f',PWm3(2)),'HorizontalAlignment','center','VerticalAlignment','middle','Color',1/255*[13 51 148]);
text(21-5,17-5,sprintf('%5.2f',PWm3(3)),'Color',1/255*[13 51 148],'HorizontalAlignment','center','VerticalAlignment','middle');
text(22.5-5,16-5,sprintf('%5.2f',PWm3(1)),'Color',1/255*[13 51 148],'HorizontalAlignment','center','VerticalAlignment','middle');
text(24-5,17-5,sprintf('%5.2f',PWm3(4)),'HorizontalAlignment','center','VerticalAlignment','middle','Color',1/255*[13 51 148]);


drawnow

print('-dtiff','-r250',['CEC' sn]);