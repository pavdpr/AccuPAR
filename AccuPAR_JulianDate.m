function julianDay = AccuPAR_JulianDate( dateString )
%ACCUPAR_JULIANDATE Converts a date string into a Julian Day
%
% DETAILED DESCRIPTION:
%   This function converts a date string into a Julian Day
%
% INPUTS:
%   dateString: a string containing the date. A timeString has 2 slashes. 
%       e.g., 6/13/2012
%
% OUTPUTS:
%   julianDay: The Julian Day
%
% HISTORY:
%   2013-05-08: Written by Paul Romanczyk (par4249 at rit dot edu)
% 
% REFERENCES:
%   http://www.decagon.com/assets/Manuals/AccuPAR-LP-80.pdf
%


idx = strfind( dateString, '/' );
if numel( idx ) ~= 2
    error( 'AccuPAR_JulianDate:InvalidDateString', ...
        'Invalid Date String' );
end

month = str2double( dateString( 1:idx( 1 ) - 1 ) );
day = str2double( dateString( idx( 1 ) + 1:idx( 2 ) - 1 ) );
year = str2double( dateString( idx( 2 ) + 1:end ) );

leapYear = isLeapYear( year );
if ~leapYear
    monthStart = [ 0 31	59 90 120 151 181 212 243 273 304 334 ];
else
    monthStart = [ 0 31 60 91 121 152 182 213 244 274 305 335 ];
end

julianDay = monthStart( month ) + day;

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
