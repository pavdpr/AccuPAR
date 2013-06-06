function [ output, idx ] = AccuPAR_FindClosestSample( data, time, isDST, method )
%ACCUPAR_FINDCLOSESTSAMPLE Finds the closest sample to a specified time
%
% DETAILED DESCRIPTION:
%   This function searches data to find the closest sample to a specified
%       time.
%
% INPUTS:
%   data: An array of structures containing the data. At a minimum, the
%       data array must have JulianDay, t, and year fields.
%   data( i ): the i th entry of the spreadsheet.
%   data.JulianDay: The Julian Day.
%   data.t: The time in hours, corrected for daylight savings.
%   data.year: the year
%   time: a string contianing the time to use. e.g. '5/9/2013 4:30:00 PM'
%   isDST: (optional) a bool that is true if time is in DST. this does not
%       affect the times in data.
%   method: (optional) a string telling the function how to get find the
%       closest sample
%       + 'closest' Use the closest sample to time
%       + 'earlier' Use the closest sample to time that is earlier than
%           time
%       + 'later' Use the closest sample to time that is later than time
%
% OUTPUTS:
%   output: An array of structures containing the data with in the 
%       specified time range. 
%   idx: the index of data that generates output e.g., output = data( idx )
%
% HISTORY:
%   2013-05-10: Written by Paul Romanczyk (par4249 at rit dot edu)
% 
% NOTES:
%   Note that if no time satifies the conditions of 'earlier' or 'later',
%       the function reverts to 'closest'.
%   This function may return two (or more) results if more than one sample 
%       is equally close to time.
%
% REFERENCES:
%   http://www.decagon.com/assets/Manuals/AccuPAR-LP-80.pdf

if nargin < 3 
    isDST = false;
end
if nargin < 4
    method = 'closest';
end

% compute the time to a numeric value
[ J, T, Y ] = AccuPAR_DateTime( time, isDST );
t = ( Y + ( J + T / 24.0 ) / 366.0 ) .* ones( size( data ) );

n = numel( data );

% make a vector of time info from data
T = zeros( size(  data ) );
for i = 1:numel( T )
    T( i ) = data( i ).year + ...
        ( data( i ).JulianDay + data( i ).t / 24.0 ) / 366.0;
end

if strcmp( method, 'closest' )
    idx = find( min( abs( T - t ) ) == abs( T - t ) );
elseif strcmp( method, 'earlier' )
    tmp = ( T - t );
    idx1 = ( tmp <= 0 );
    tmp( ~idx1 ) = inf;
    idx = find( min( abs( tmp ) ) == abs( tmp ) );
    if numel( idx ) == n
        % All values are outside the range, default to closest
        idx = find( min( abs( T - t ) ) == abs( T - t ) );
    end
elseif strcmp( method, 'later' )
    tmp = ( T - t );
    idx1 = ( tmp >= 0 );
    tmp( ~idx1 ) = inf;
    idx = find( min( abs( tmp ) ) == abs( tmp ) );
    if numel( idx ) == n
        % All values are outside the range, default to closest
        idx = find( min( abs( T - t ) ) == abs( T - t ) );
    end
else
    error( 'AccuPAR_FindClosestSample:InvalideMethod', ...
        'Invalid method' );
end

output = data( idx );

end

