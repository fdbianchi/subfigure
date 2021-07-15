function alignylabel(Ha,xpos,side)

% ALIGNYLABEL places ylabel at the same x-position given by xpos
%
% Inputs:
%   Ha: axes handles
%   xpos: desired x-position
%   side: left or rigth
%

% fbianchi - 2015-03-20 - v0.1
% fbianchi - 2020-08-27 - v0.2

if verLessThan('matlab','8.4') 

    % ylabel handles
    Hylabel = cell2mat(get(Ha,'ylabel'));
    
    % ylabel positions
    position = cell2mat(get(Hylabel,'Position'));
    
    % new x position
    position(:,1) = xpos*ones(size(position,1),1);
    
    % set the new position
    for ii=1:length(Hylabel)
        set(Hylabel(ii),'Position',position(ii,:));
    end
    
else
    
    % set the new position
    if (nargin < 3)
        for ii = 1:length(Ha)
            Ha(ii).YAxis(1).Label.Position(1) = xpos;
        end
    
    else
        if strcmp(side,'left')
        for ii = 1:length(Ha)
            Ha(ii).YAxis(1).Label.Position(1) = xpos;
        end
            
        elseif strcmp(side,'rigth')
            for ii = 1:length(Ha)
                if (length(Ha(ii).YAxis) > 1)
                    Ha(ii).YAxis(2).Label.Position(1) = xpos;
                end
            end
        else
            error('Third argument invalid')
        end
    end
%     for ii = 1:length(Ha)
%         
%     end

end
