function t0 = AccuPAR_SolarNoon( ET, LC )
%ACCUPAR_SOLARNOONNAIVE Computes the time of solar noon
%
% DETAILED DESCRIPTION:
%   Computes the time of solar noon using the equation of time and
%       longitude corrections.
%   This is equation 32 in the manual.
%
% INPUTS:
%   ET: The Equation of time correction in hours. Use 
%       AccuPAR_EquationOfTime.m to compute.
%   LC: The Longitude correction in hours. Use 
%       AccuPAR_LongitudeCorrection.m to compute.
%
% OUTPUTS:
%   t0: The time of Solar Noon
%
% HISTORY:
%   2013-05-06: Written by Paul Romanczyk (par4249 at rit dot edu)
%   2013-05-08: Modified by Paul Romanczyk (par4249 at rit dot edu)
%       + Removed Naive from name
%           - AccuPAR_LongitudeCorrection.m was written to allow for either
%           naive or informed meridians.
%       + Inputs are now the Longitude and Equation of Time corrections,
%       which are computed externally.
%   2013-09-20: Added RIT Copyright
%
% COPYRIGHT:
%   (C) 2013 Rochester Institute of Technology
% 
% REFERENCES:
%   http://www.decagon.com/assets/Manuals/AccuPAR-LP-80.pdf
%

LC = LC(:);
ET = ET(:);

% error checking
nLC = numel( LC );
nET = numel( ET );

if nLC == nET
    % nothing needs to be done.
elseif nLC == 1
    LC = LC .* ones( size( ET ) );
elseif nET == 1
    ET = ET .* ones( size( LC ) );
else
    error( 'AccuPAR_SolarNoon:InvalidInputDimensions', ...
        'The inputs must be the same size or one input have size 1' );
end


% Compute the time of Solar Noon (Equation 32)
t0 = 12 - LC - ET;

end

