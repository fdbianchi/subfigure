function Ha = subfigures(nplot,varargin)

% SUBFIGURES creates several axes similar to subplot (1 column) but 
% reducing space between figures
%
% Use:
%   Ha = subfigures(nplot,options)
%
% Inputs:
%   nplot: number of plots
%   options: structure with figure setup (optional)
%            % figure settings
%               options.fig.Tag            = 'subFigs';
%               options.fig.Height         = 0.88; 
%            % Font
%               options.ax.FontName       = 'Times New Roman';
%               options.ax.FontSize       = 12;
%            % Line Styles
%               options.ax.LineStyleOrder = {'-','--','-.',':'};
%               options.ax.ColorOrder     = lines(7);
%               options.ax.LineWidth      = 1;
%             % Axes dimenstions (normalized)
%               options.ax.offx           = 0.10;
%               options.ax.offy           = 0.10;
%               options.ax.sepy           = 0.03;
%               options.ax.indWidth       = 0.80;
%               options.ax.indHeight      = 'auto' or value in cm;
%               options.ax.totHeight      = 0.85;
%               options.ax.totWidth       = 0.80;
%             % Axes style
%               options.ax.xtickOff       = true;
%               options.ax.Xlim           = [0 1];
%
%   These options can be defined in a file "figsetup.m" located in the 
%   current directory or other file name provided as second argument
%   in which the struct "options" is given.
%
% Output:
%   Ha: axes handles
%
% Dimension are set for exporting to a a4 paper document

% fbianchi - 2015-03-20 - v 0.1
% fbianchi - 2020-08-27 - v 0.2

% checking input arguments
if ~isnumeric(nplot) || length(nplot) > 2
    error('NPLOT must be a numeric scalar')
end

% figure options
if (nargin < 2)
    % if no arguments, check if figsetup.m file exist
    folder = cd;
    if (exist([folder '\figsetup.m'],'file') == 2)
        figsetup
        optUser = options;
    else
        optUser = struct([]);
    end
else
    if ischar(varargin{1})
        % case setup is in a file
        if (exist(varargin{1},'file') == 2)
            run(varargin{1})
            if (exist('options','var') && ~isstruct(options))
                error('The given file must define the option struct')
            else
                optUser = options;
            end
        end
    elseif ~isstruct(varargin{1})
        error('OPTIONS must be a struct, check help subfigures')
    else 
        % case setup in an struct
        optUser = varargin{1};
    end
end

% ========================================================================
% Fixed values

% screen max height normalized
scrSize          = get(0, 'Screensize');
scr.width        = scrSize(3);
scr.height       = scrSize(4);

% figure area in A4 paper size 
paper.widthMax   = 18; % cm
paper.heightMax  = 26; % cm

% max figure height
fig.heightMax    = 0.88*scr.height;


% ========================================================================
% Default axes settings

% figure settings
options.fig.Tag            = '';
options.fig.Height         = 0.88; 

% Font
options.ax.FontName       = 'Times New Roman';
options.ax.FontSize       = 12;

% Line Styles
options.ax.LineStyleOrder = {'-','--','-.',':'};
options.ax.ColorOrder     = lines(7);
options.ax.LineWidth      = 1;

% Axes dimenstions (normalized)
options.ax.offx           = 0.10;
options.ax.offy           = 0.10;
options.ax.sepy           = 0.03;
options.ax.indWidth       = 0.80;
options.ax.indHeight      = 'auto';
options.ax.totHeight      = 0.85;
options.ax.totWidth       = 0.80;

% Axes style
options.ax.xtickOff       = true;
options.ax.Xlim           = [];

% changing axes settings according to inputs
if ~isempty(optUser)
    fields = fieldnames(optUser);
    for ii = 1:length(fields)
        if isstruct(optUser.(fields{ii}))
            fields2 = fieldnames(optUser.(fields{ii}));
            for jj = 1:length(fields2)
%                 fprintf('%s - %s\n',fields{ii},fields2{jj})
                options.(fields{ii}).(fields2{jj}) = optUser.(fields{ii}).(fields2{jj});
            end
        else
            options.(fields{ii}) = optUser.(fields{ii});
        end
    end
end


% ========================================================================
% Figure setup

% fisrt check if there is a previous figure
Hf = findobj('Tag',options.fig.Tag);

if isempty(Hf) || isempty(options.fig.Tag)
    Hf = figure('Tag',options.fig.Tag,...
        'Units','normalized');
else
    set(Hf,'Tag',options.fig.Tag,...
        'Units','normalized');
    % delete previous axes
    delete(get(Hf,'children'))
end

% export options (A4 paper)
Hf.PaperUnits    = 'centimeters';
Hf.PaperSize     = [21 29.7];
Hf.PaperPosition = [1.5 2 paper.widthMax paper.heightMax];

% computing dimension according to input
if strcmp(options.ax.indHeight,'auto')
    % axes height given for the total height
    
    % adapt paper height
    Hf.PaperPosition(4) = options.fig.Height*paper.heightMax;

    % compute the individual height for the axes (normalized)
    options.ax.indHeight = (options.ax.totHeight - ...
                           (nplot - 1)*options.ax.sepy)/nplot;

else
    % axes height given as input in cm
    
    % check if the axes options have been changed
    if ~isempty(optUser) && isfield(optUser,'ax')
        axFields = fieldnames(optUser.ax);
        if all(ismember(axFields,'offy') == 0)
            options.ax.offy      = 1.5; % cm
        else
            options.ax.offy = options.ax.offy;
        end
        if all(ismember(axFields,'sepy') == 0)
            options.ax.sepy      = 0.5; % cm
        else
            options.ax.sepy = options.ax.sepy;
        end
    end
    
    % compute the total height in paper units
    paper.height = nplot*options.ax.indHeight + (nplot - 1)*options.ax.sepy + ...
                    2*options.ax.offy;
                
    % adapt paper height
    Hf.PaperPosition(4) = paper.height;
    
    % compute axes heigth in normalized units
    options.ax.offy      = options.ax.offy/paper.height;
    options.ax.sepy      = options.ax.sepy/paper.height;
    options.ax.indHeight = options.ax.indHeight/paper.height;
    
    % compute the total height 
    options.fig.Height = paper.height*(fig.heightMax/scr.height)/paper.heightMax;

end
% adapt paper width
Hf.PaperPosition(3) = paper.widthMax*min(1,options.ax.indWidth + 1.5*options.ax.offx);

% figure with to keep aspect-ratio of paper
fig.width = paper.widthMax*scr.height/paper.heightMax/scr.width;

% update the figure position
Hf.Position = [0.5 0.038 fig.width options.fig.Height];

% ========================================================================
% Axes setup

for jj = 1:nplot
    
    ax.position(1) = options.ax.offx;
    ax.position(2) = options.ax.offy + (jj - 1)*(options.ax.indHeight + options.ax.sepy);
    ax.position(3) = options.ax.indWidth;
    ax.position(4) = options.ax.indHeight;
    
    Ha(nplot-jj+1) = axes(...
        'FontName',options.ax.FontName,...
        'FontSize',options.ax.FontSize,...
        'NextPlot','add',...
        'Units','normalized',...
        'Position',ax.position,...
        'LineStyleOrder',options.ax.LineStyleOrder,...
        'DefaultLineLineWidth',options.ax.LineWidth,...
        'ColorOrder',options.ax.ColorOrder,...
        'Box','on');
    if ~isempty(options.ax.Xlim)
        set(Ha(nplot-jj+1), 'XLim', options.ax.Xlim)
    end            
    
    % remove xtick labels
    if (options.ax.xtickOff) && (jj > 1)
        Ha(nplot-jj+1).XTickLabel = [];
    end
    
end

xlabel(Ha(nplot),'Time (s)')

return

