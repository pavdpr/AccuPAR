function D = AccuPAR_SolarDeclination( JulianDay )
%ACCUPAR_SOLARDECLINATION Computes the Solar Declination Angle
%
% DETAILED DESCRIPTION:
%   Computes the solar declination angle in radians for a given Julian Day
%
% INPUTS:
%   JulianDay: The day of the year
%
% OUTPUTS:
%   D: The Solar Declination Angle in degrees
%
% HISTORY:
%   2013-05-06: Written by Paul Romanczyk (par4249 at rit dot edu)
%   2013-09-20: Added RIT Copyright
% 
% NOTES:
%   The values differ slightly from table 4. This is probably due to
%       numerial rounding issues.
%
% COPYRIGHT:
%   (C) 2013 Rochester Institute of Technology
%
% REFERENCES:
%   http://www.decagon.com/assets/Manuals/AccuPAR-LP-80.pdf


% equation 31
D = asin( 0.39785 .* sin( 4.869 + 0.0172 .* JulianDay ) + ...
    0.03345 .* sin( 6.224 + 0.0172 .* JulianDay ) );

end

