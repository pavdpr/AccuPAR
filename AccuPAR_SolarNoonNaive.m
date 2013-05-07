function t0 = AccuPAR_SolarNoonNaive( JulianDay, longitude )
%ACCUPAR_SOLARNOONNAIVE Computes the time of solar noon
%
% DETAILED DESCRIPTION:
%   Computes the time of solar noon. This function assumes that standard
%       meridians occur every 15 degrees of longitude.
%
% INPUTS:
%   JulianDay: The day of the year
%   longitude: The longitude. Longitudes in the eastern hemisphere are
%       negative.
%
% OUTPUTS:
%   t0: The time of Solar Noon
%
% HISTORY:
%   2013-05-06: Written by Paul Romanczyk (par4249 at rit dot edu)
% 
% REFERENCES:
%   http://www.decagon.com/assets/Manuals/AccuPAR-LP-80.pdf
%

JulianDay = JulianDay(:);
longitude = longitude(:);

% error checking
if ( numel( JulianDay ) ~= numel( longitude ) )
    error( 'AccuPAR_SolarNoonNaive:InvalidInputDimensions', ...
        'The inputs must be the same size' );
end

% assume the standard meridians are evenly spaced every 15 deg.
standardMeridian = 15 .* round( longitude ./ 15.0 );

% the Longitude correction is +1/15 hr for every degree east of a standard
% meridian
LC = ( standardMeridian - longitude ) ./ 15.0;

% Compute the time of Solar Noon (Equation 32)
t0 = 12 - LC - AccuPAR_EquationOfTime( JulianDay );

end

