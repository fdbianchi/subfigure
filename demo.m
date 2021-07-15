
% examples of use of subfigures
%
% fbianchi - 20/03/2015

close all
clearvars

% data
x  = linspace(0,2*pi,50);
y1 = sin(x);
y2 = cos(x);
y3 = y1 + y2;
y4 = y1 - y2;

% -----------------------------------------------------------------------
% default options: heigth of each axes is computed to fill the export area

Ha = subfigures(3);

% plots
plot(Ha(1),x,y1,x,y2);
ylabel(Ha(1),'plot 1')
legend(Ha(1),'y1','y2')

plot(Ha(2),x,y1,x,y4);
ylabel(Ha(2),'plot 2')
legend(Ha(2),'y1','y4')

yyaxis(Ha(3),'left')
plot(Ha(3),x,y3);
ylabel(Ha(3),'plot 3 Left')
yyaxis(Ha(3),'right')
plot(Ha(3),x,y4);
ylabel(Ha(3),'plot 3 Right')

legend(Ha(3),'y3','y4')

% all ylabel aligned
alignylabel(Ha,-0.5)
alignylabel(Ha,7.5,'rigth')

print('-depsc2','-loose','figure1.eps')
% print('-depsc2','figure1.eps')

% -----------------------------------------------------------------------
% giving options 

% figure settings
options.fig.Tag            = '';
options.fig.Height         = 0.88; 
% Font
options.ax.FontName       = 'Helvetica';
options.ax.FontSize       = 10;
% Line Styles
options.ax.LineStyleOrder = {'-','--','-.',':'};
options.ax.ColorOrder     = lines(7);
options.ax.LineWidth      = 2;
% Axes dimenstions (normalized)
options.ax.offx           = 0.10;
options.ax.offy           = 1;      % in cm
options.ax.sepy           = 0.7;    % in cm    
options.ax.indWidth       = 0.70;
options.ax.indHeight      = 4;      % in cm
options.ax.totHeight      = 0.85;
% Axes style
options.ax.xtickOff       = false;
options.ax.Xlim           = [0 10];

Hb = subfigures(3,options);

plot(Hb(1),x,y1,x,y2);
ylabel(Hb(1),'$y_1$','Interpreter','latex')
legend(Hb(1),'y1','y2')

plot(Hb(2),x,y1,x,y4);
ylabel(Hb(2),'plot 2')
legend(Hb(2),{'$y_1$','$y_4$'},'Interpreter','latex')

plot(Hb(3),x,y3);
ylabel(Hb(3),'plot 3 Left')
legend(Ha(3),'y3','y4')


print('-depsc2','-loose','figure2.eps')


% -----------------------------------------------------------------------
% giving options with a file

Hc = subfigures(4,'figsetup.m');

plot(Hc(2),x,y1,x,y4);
ylabel(Hc(2),'plot 2')
legend(Hc(2),'y1','y4')

yyaxis(Hc(3),'left')
plot(Hc(3),x,y3);
ylabel(Hc(3),'plot 3 Left')
yyaxis(Hc(3),'right')
plot(Hc(3),x,y4);
ylabel(Hc(3),'plot 3 Right')

% all ylabel aligned
alignylabel(Ha,-0.3)

print('-depsc2','-loose','figure3.eps')

