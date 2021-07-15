function fig2eps(Hf,figname,folder,folder2)

% FIG2EPS produces a eps file for the figure
%
% Use:
%   fig2eps(figname)
%   fig2eps(Hf,figname,folder,folder2)
%
% Inputs:
%   Hf: figure handle
%   figname: eps file name
%   folder(optional): folder in which the eps file is located
%   folder2(optional): if there exist a file figname.tex in folder2, the
%       eps file is generated after compiling it in latex, this is used to
%       replace string with psfrag
%

% fbianchi - 20/03/2015


if nargin<2
    figname = Hf;
    Hf = gcf;
    folder  = [];
    folder2 = folder;
elseif nargin<3
    folder  = [];
    folder2 = folder;
elseif nargin<4
    folder2 = folder;
end

if ~ischar(figname)
    error('FIGNAME must be a string')
end
if ~isempty(folder) && ~ischar(folder)
    error('FOLDER must be a string')
end
if ~isempty(folder2) && ~ischar(folder2)
    error('FOLDER2 must be a string')
end

% create an eps file
print(Hf,'-depsc2',sprintf('%s/%s_eps.eps',folder2,figname));

% for psfrag replacements
if exist(sprintf('%s/%s.tex',folder2,figname),'file')

    % current folder
    old_path = cd;
    
    % new folder
    if ~isempty(folder2)
        cd(folder2);
    end
    
    
    % eval(sprintf('!latex -output-directory=%s %s.tex',pathstr,figname));
    eval(sprintf('!latex %s.tex',figname));
    % eval(sprintf('!dvips %s.dvi -o %s.eps',figname,figname));
    
    eval(sprintf('!dvips %s.dvi -o %s/%s.eps',figname,folder,figname));
    
    exts = {'aux','dvi','pfg','log'};
    for ii=1:length(exts)
        delete(sprintf('%s.%s',figname,exts{ii}));
    end
    
    % go back to the inital folder
    cd(old_path);
end
