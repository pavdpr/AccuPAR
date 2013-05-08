function t = AccuPAR_NormalizeTime( timeString, isDST )
%ACCUPAR_NORMALIZETIME Converts a time string to a numeric time
%
% DETAILED DESCRIPTION:
%   This function converts a time string to a decimal time in hours
%
% INPUTS:
%   timeString: a string containing the time. A timeString has 2 colons
%       (:), and 1 space ( ). e.g., 12:32:01 AM. The AM or PM part of the 
%       time string is all capitols.
%   isDST: a bool that is true if it Daylight Savings Time
%
% OUTPUTS:
%   t: the time in hours. The values are in the range [0.0,24.0).
%
% HISTORY:
%   2013-05-08: Written by Paul Romanczyk (par4249 at rit dot edu)
% 
% REFERENCES:
%   http://www.decagon.com/assets/Manuals/AccuPAR-LP-80.pdf
%

if nargin < 2
    isDST = false;
end

idx1 = strfind( timeString, ':' );
idx2 = strfind( timeString, ' ' );

if ( numel( idx1 ) ~= 2 ) || ( numel( idx2 ) ~= 1 )
    error( 'AccuPAR_NormalizeTime:InvalidTimeString', ...
        'Invalid Time String' );
end

AmPmString = timeString( idx2 + 1:end );
if strcmp( AmPmString, 'AM' )
    am = true;
elseif strcmp( AmPmString, 'PM' )
    am = false;
else
    error( 'AccuPAR_NormalizeTime:InvalidTimeString', ...
        'Invalid Time String' );
end
    
hour = str2double( timeString( 1:idx1( 1 ) - 1 ) );
minute = str2double( timeString( idx1( 1 ) + 1:idx1( 2 ) - 1 ) ) / 60; 
second = str2double( timeString( idx1( 2 ) + 1:idx2 - 1 ) ) / 3600;

if am
    % we are in the morning. times are [0, 12)
    if hour == 12
        % times are [0,1)
        t = minute + second;
    else
        % times are [1,12)
        t = hour + minute + second;
    end
else
    % we are in the afternoon. times are [12,24)
    if hour == 12
        % times are [12,13)
        t = 12.0 + minute + second;
    else
        % times are [13,24)
        t = 12.0 + hour + minute + second;
    end
end

if isDST
    % correct for daylight savings time
    t = t - 1.0;
    if t < 0
        t = t + 24;
    end
end

end

