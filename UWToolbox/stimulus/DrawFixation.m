function [display] = DrawFixation(display)
% [display] = DrawFixation(display)
%
% Draws a fixation point (smaller square inside a larger square) in the
% center of the screen.
%
% Input:
%   display             A structure containing display information (see 
%                       OpenWindow.m) must have fields:
%                       * dist, width, resolution, center, bkColor, window
%
%       fixation        A structure containing fixation square information
%                       with fields, optional:
%           size        Size of fixation square, degrees (default: 0.5)
%           mask        Size of circular 'mask' that surrounds the
%                       fixation, degrees (default: 2)
%           color       Cell array for fixation square colors, in
%                       {inner, outer} order
%                       (default: {[255 255 255], [0 0 0]};
%                       black outer and white inner square)
%           flip        Flag to call Screen('Flip') at the end OR not,
%                       logical (default: true)
%
% Output:
%   display             Same 'display' structure, but with additional
%                       fields filled in
% 
% Note: 
% - Dependencies: <a href="matlab: web('http://psychtoolbox.org/')">Psychtoolbox</a>, angle2pix.m

% Written by G.M. Boynton at the University of Washington - 3/26/09
% Edited by Kelly Chang - February 23, 2017

%% Input Control

if ~isfield(display, 'fixation')
    display.fixation = [];
end

if ~isfield(display.fixation, 'size')
    display.fixation.size = 0.5; % degrees
end

if ~isfield(display.fixation, 'mask')
    display.fixation.mask = 2; % degrees
end

if ~isfield(display.fixation, 'color')
    display.fixation.color = {[255 255 255], [0 0 0]};
end

if ~isfield(display.fixation, 'flip')
    display.fixation.flip = true; % flip by default
end

%% Calculate and Draw Fixation Square

% Calculate size of boxes in screen coordinates
sz(1) = angle2pix(display, display.fixation.size/2); % outer square
sz(2) = angle2pix(display, display.fixation.size/4); % inner square
sz(3) = angle2pix(display, display.fixation.mask/2); % mask

% Calculate the rectangles in screen-coordinates [left top right bottom]
rect = cellfun(@(x) x'+repmat(display.center,1,2), ...
    num2cell([-1 -1 1 1]'*sz,1), 'UniformOutput', false);

% Mask (background color)
Screen('FillOval', display.windowPtr, display.bkColor, rect{3});

% Outer square (default: white)
Screen('FillRect', display.windowPtr, display.fixation.color{1}, rect{1});

% Inner square (default: black)
Screen('FillRect', display.windowPtr, display.fixation.color{2}, rect{2});

if display.fixation.flip % flip screen
    Screen('Flip', display.windowPtr); 
end