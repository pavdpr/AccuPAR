function [ output, idx ] = AccuPAR_TemporalSubset( data, timeRange, isDST )
%ACCUPAR_TEMPORALSUBSET Provides a way to subset data based on time
%
% DETAILED DESCRIPTION:
%   This function temporally subsets the data.
%
% INPUTS:
%   data: An array of structures containing the data. At a minimum, the
%       data array must have JulianDay, t, and year fields.
%   data( i ): the i th entry of the spreadsheet.
%   data.JulianDay: The Julian Day.
%   data.t: The time in hours, corrected for daylight savings.
%   data.year: the year
%   timeRange: a string contianing the time range to use. There are a few
%       possible formats for this string
%       + Single date. e.g. '5/9/2013': this will return all entries on
%           this date.
%       + Single date and time. e.g. '5/9/2013 4:30:00 PM': This will
%           return any entry at this date and time.
%       + Time Range with dates. e.g. '5/8/2013-5/9/2013': This will return
%           all entries in data in the time range.
%       + Time range with dates and times. e.g. 
%           '5/8/2013 11:28:23 AM-5/9/2013 4:42:17 PM': This will return
%           all entries of data in the time ranges.
%       + Time range with mixed dates/times. e.g.
%           '5/8/2013 11:28:23 AM-5/9/2013' or 
%           '5/8/2013-5/9/2013 4:42:17 PM': This will return all entries of 
%           data in the time ranges.
%       + All points before a time (either mixed date/time or date only)
%           '-5/8/2013 11:28:23 AM' or '-5/8/2013' 
%       + All points after a time (either mixed date/time or date only)
%           '5/8/2013 11:28:23 AM-' or '5/8/2013-'
%   isDST: (optional) a bool that is true if the time(s) in timeRange is
%       (are) in Daylight Savings time
%
% OUTPUTS:
%   output: An array of structures containing the data with in the 
%       specified time range. 
%   idx: the index of data that generates output e.g., output = data( idx )
%
% HISTORY:
%   2013-05-10: Written by Paul Romanczyk (par4249 at rit dot edu)
%   2013-07-23: Modified by Paul Romanczyk
%       Added the ability to do one sided ranges
%   2013-08-12: Modified by Wei Yao (wxy3806 at ...)
%       Fixed a bug in calculating "t" when endOfDay is true
%   2013-09-20: Added RIT Copyright
% 
% NOTES:
%   Time Ranges are inclusive of the entered values.
%
% COPYRIGHT:
%   (C) 2013 Rochester Institute of Technology
%
% REFERENCES:
%   http://www.decagon.com/assets/Manuals/AccuPAR-LP-80.pdf
%

while iscell( timeRange )
    startOrDate = startOrDate{ 1 };
end

if nargin < 3
    isDST = false;
end

idx = strfind( timeRange, '-' );

if numel( idx ) == 0
    T = zeros( size(  data ) );
    for i = 1:numel( T )
        T( i ) = data( i ).year + data( i ).JulianDay / 366.0;
    end
    % we are looking for equal to the date
    t = parseTime( timeRange, isDST );
    idx = ( T == t );
    output = data( idx );
    return;
elseif numel( idx ) == 1
    % we are looking for a range
    if idx == 1
        % We are looking for all points before the given time
        t1 = -inf;
        t2 = parseTime( timeRange( 2:end ), isDST, true );
    elseif idx == numel( timeRange )
        % We are looking for all points after the given time
        t1 = parseTime( timeRange( 1:end - 1 ), isDST, true );
        t2 = inf;
    else
        % both beginning and end have been defined
        startString = timeRange( 1:idx - 1 );
        stopString = timeRange( idx + 1:end );

        t1 = parseTime( startString, isDST );
        t2 = parseTime( stopString, isDST, true );
    end
    T = zeros( size(  data ) );
    for i = 1:numel( T )
        T( i ) = data( i ).year + ...
            ( data( i ).JulianDay + data( i ).t / 24.0 ) / 366.0;
    end
    
    idx = ( ( T >= t1 ) & ( T <= t2 ) );
    output = data( idx );
    
else
    % invalid input
    error( 'AccuPAR_TemporalSubset:InvalidTimeRange', ...
        'The time range is invalid' );
end

end


function t = parseTime( timeString, isDST, endOfDay )
    if nargin < 3
        endOfDay = false;
    end
    
    idx = strfind( timeString, ' ' );
    
    % A Year, day and time string has 2 space; a year and day string has 0.
    if numel( idx ) == 2    
        % Year, Day, and time
        [ J, T, Y ] = AccuPAR_DateTime( timeString, isDST );
        t = Y + ( J + T / 24.0 ) / 366.0;
    elseif numel( idx ) == 0
        % Year and day
        [ J, Y ] = AccuPAR_JulianDate( timeString );
        t = Y + J / 366.0;
        if endOfDay
            % if this is an end of day measurement, add 23 hrs 59 min and
            %   59 sec to the time
            t = t + ( 23.0 + ( 59.0 + ( 59.0 / 60.0 ) ) / 60.0 ) / 24.0 ...
                / 366.0;
        end
    else
        error( 'AccuPAR_TemporalSubset:parseTime:InvalidTimeString', ... 
                'Invalid time string' );
    end
    if isDST
        t = t - ( 1.0 / 24.0 ) / 366.0;
    end
end
