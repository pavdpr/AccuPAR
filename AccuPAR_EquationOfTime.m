function ET = AccuPAR_EquationOfTime( JulianDay )
%ACCUPAR_EQUATIONOFTIME Computes the Equation of Time
%
% DETAILED DESCRIPTION:
%   A time correction that depends on the time of year.
%
% INPUTS:
%   JulianDay: The day of the year
%
% OUTPUTS:
%   ET: The time correction in hours
%
% HISTORY:
%   2013-05-06: Written by Paul Romanczyk (par4249 at rit dot edu)
% 
% REFERENCES:
%   http://www.decagon.com/assets/Manuals/AccuPAR-LP-80.pdf
%

phi = ( 279.575 + 0.986 .* JulianDay ) .* ( pi / 180.0 );

% Equation 33
ET = ( -104.7 .* sin( phi ) + 596.2 .* sin( 2 .* phi ) + ...
    4.3 .* sin( 3 .* phi ) - 12.7 .* sin( 4 .* phi ) - ...
    429.3 .* cos( phi ) - 2.0 .* cos( 2 .* phi ) + ...
    19.3 .* cos( 3 .* phi ) ) ./ 3600.0;

end

