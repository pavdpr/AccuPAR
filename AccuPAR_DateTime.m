function [ julianDay, t ] = AccuPAR_DateTime( dateTimeString, isDST )
%ACCUPAR_DATETIMECONVERT Parses an AccuPAR date/time string
%
% DETAILED DESCRIPTION:
%   This function converts a date/time string to a Julian date and decimal 
%       time in hours
%
% INPUTS:
%   dateTimeString: a string containing the time. A timeString has 2 colons
%       (:), 2 spaces ( ), 2 slashes (/). e.g., 6/13/2012 12:32:01 AM. The 
%       AM or PM part of the time string is all capitols.
%   isDST: a bool that is true if it Daylight Savings Time
%
% OUTPUTS:
%   t: the time in hours. The values are in the range [0.0,24.0).
%   julianDay: the Julian Day
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
    
    idx1 = strfind( dateTimeString, ' ' );
    idx2 = strfind( dateTimeString, '/' );
    idx3 = strfind( dateTimeString, ':' );
    
    if ( numel( idx1 ) ~= 2 ) || ( numel( idx2 ) ~= 2 ) || ...
            ( numel( idx3 ) ~= 2 )
        error( 'AccuPAR_DateTime:InvalidDateTimeString', ...
            'Invalid Date/Time String' );
    end
    
    % get the date
    month = str2double( dateTimeString( 1:idx2( 1 ) - 1 ) );
    day = str2double( dateTimeString( idx2( 1 ) + 1:idx2( 2 ) - 1 ) );
    year = str2double( dateTimeString( idx2( 2 ) + 1:idx1( 1 ) - 1 ) );

    leapYear = isLeapYear( year );
    if ~leapYear
        monthStart = [ 0 31	59 90 120 151 181 212 243 273 304 334 ];
    else
        monthStart = [ 0 31 60 91 121 152 182 213 244 274 305 335 ];
    end

    julianDay = monthStart( month ) + day;
    
    % Are we AM or PM
    
    AmPmString = dateTimeString( idx1( 2 ) + 1:end );
    if strcmp( AmPmString, 'AM' )
        am = true;
    elseif strcmp( AmPmString, 'PM' )
        am = false;
    else
        error( 'AccuPAR_DateTime:InvalidDateTimeString', ...
            'Invalid Date/Time String' );
    end

    
    % Get the time
    hour = str2double( dateTimeString( idx1( 1 ) + 1:idx3( 1 ) - 1 ) );
    minute = str2double( dateTimeString( idx3( 1 ) + ...
        1:idx3( 2 ) - 1 ) ) / 60; 
    second = str2double( dateTimeString( idx3( 2 ) + ...
        1:idx1( 2 ) - 1 ) ) / 3600;

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
        % check if we are at the boundary of a day
        if t < 0
            t = t + 24;
            julianDay = julianDay - 1;
            % check if we are at the boundary of a year
            if julianDay < 1
                if isLeapYear( year - 1 )
                    julianDay = 366;
                else
                    julianDay = 365;
                end
            end
        end
    end

end

function leapYear = isLeapYear( year )
    if mod( year, 400 ) == 0
        leapYear = true;
    elseif mod( year, 100 ) == 0
        leapYear = false;
    elseif mod( year, 4 ) == 0
        leapYear = true;
    else
        leapYear = false;
    end
end