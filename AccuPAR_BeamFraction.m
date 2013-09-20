function Fb = AccuPAR_BeamFraction( zenith, par )
%ACCUPAR_BEAMFRACTION Calculates the beam fraction, Fb
%
% DETAILED DESCRIPTION:
%   This function computes the beam fraction, Fb for a given zenith an PAR
%   reading. Fb is the ratio of direct radiation from the sun to all other
%   ambient sources.
%
% INPUTS:
%   zenith: the zenith angle in degrees
%   par: the Photosynthetic Active Radiation in umol/m^2/s
%
% OUTPUTS:
%   Fb: the Beam Fraction
%
% HISTORY:
%   2013-05-06: Written by Paul Romanczyk (par4249 at rit dot edu)
%   2013-07-23: Bug Fix by Wei Yao
%               'par' not 'PAR'
%   2013-09-20: Added RIT Copyright
%
% COPYRIGHT:
%   (C) 2013 Rochester Institute of Technology
% 
% REFERENCES:
%   http://www.decagon.com/assets/Manuals/AccuPAR-LP-80.pdf
%   http://www.decagon.com/products/environmental-instruments/ceptometer-par-lai-instruments-2/accupar-lp-80/
%   Code "stolen" from the macro in LAI-Calculator.xls
%
% NOTES:
%   Fb should be calculated on the above canopy (logger) instrument.
%
% ORIGINAL VISUAL BASIC SCRIPT:
%   Function BeamFraction(Zenith As Single, PAR As Single) As Single
%       Const pi = 3.14159
%       Dim r As Single, b As Single
%
%       Zenith = Zenith * pi / 180
%       If Zenith > 1.5 Then
%           b = 0#      'nighttime
%       Else
%           r = PAR / (2550# * Cos(Zenith)) '600 w/m2 * 4.25 umol/w/m2 (.235 MJ/mol)(600 is potential PAR)
%           If r > 0.82 Then r = 0.82
%           If r < 0.2 Then r = 0.2
%           b = 48.57 + r * (-59.024 + r * 24.835)
%           b = 1.395 + r * (-14.43 + r * b)
%       End If
%       BeamFraction = b
%   End Function
%

% reshape inputs
zenith = zenith(:);
par = par(:);

% error checking
nZ = numel( zenith );
nP = numel( par );

if ( ( nZ ~= nP ) || ( nZ ~= 1 ) || ( nP ~= 1 ) )
    error( 'AccuPAR_BeamFraction:InvalidInputDimensions', ...
        'The inputs must be the same size or one input have size 1' );
end

% convert to radians
zenith = zenith .* ( pi / 180.0 );

r = par ./ ( 2550.0 .* cos( zenith ) ); 
% 600 w/m2 * 4.25 umol/w/m2 (.235 MJ/mol)(600 is potential PAR)
r( r > 0.82 ) = 0.82;
r( r < 0.2 ) = 0.2;
b = 1.395 + r .* ( -14.43 + r .* ( 48.57 + r .* ( -59.024 + r .* 24.835 ) ) );
% This is equal to: 1.395 + r .* -14.43 + r .^2 .* 47.57 + r .^3 .* -59.024
% + r .^4 .* 24.835. 
% I am not sure if this is more efficent????

% zenith > 1.5 -> nighttime, set Fb to 0.0.
Fb = b .* ( zenith <= 1.5 );
end

