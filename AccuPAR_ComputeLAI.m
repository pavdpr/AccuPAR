function LAI = AccuPAR_ComputeLAI( K, fb, tau, a )
%ACCUPAR_COMPUTELAI Computes the LAI
%
% DETAILED DESCRIPTION:
%   This function computes the Leaf Area Index (LAI) from the transmission,
%       canopy extinction, fraction of direct solar illumination, and
%       absorbtion in the PAR bands.
%
% INPUTS:
%   K: the canopy extinction. Can be computed with
%       AccuPAR_CanopyExtinction.m
%   fb: the fraction of incident PAR from the sun vs other sources. Can be
%       computed by using AccuPAR_BeamFraction.m
%   tau: the fraction of transmitted light in the PAR band. This is the
%       ratio of the below canopy PAR divided by the above canopy PAR.
%   a: (optional) the leaf absorbtivity in the PAR band. Default is 0.9
%
% OUTPUTS:
%   LAI: the leaf area index
%
% HISTORY:
%   2013-05-08: Written by Paul Romanczyk (par4249 at rit dot edu)
%   2013-09-20: Added RIT Copyright
%
% COPYRIGHT:
%   (C) 2013 Rochester Institute of Technology
% 
% REFERENCES:
%   http://www.decagon.com/assets/Manuals/AccuPAR-LP-80.pdf

if nargin < 4
    a = 0.9;
end

A = 0.283 + 0.785 .* a - 0.159 .* a .^2;

fb = fb(:);
tau = tau(:);
K = K(:);
A = A(:);

% error checking
nf = numel( fb );
nT = numel( tau );
nK = numel( K );
nA = numel( A );

N = [ nf nT nK nA ];
u = unique( N );
if numel( u ) == 1
    % nothing to do
elseif numel( u ) == 2
    if u( 1 ) ~= 1
        error( 'AccuPAR_transmittedPAR_NormanJarvis:InvalidInputDimensions', ...
        'The inputs must be the same size n or 1' );
    end
    if nf == 1
        fb = fb .* ones( u( 2 ), 1 );
    end
    if nT == 1
        tau = tau .* ones( u( 2 ), 1 ); 
    end
    if nK == 1
        K = K .* ones( u( 2 ), 1 );
    end
    if nA == 1
        A = A .* ones( u( 2 ), 1 );
    end
else
    error( 'AccuPAR_transmittedPAR_NormanJarvis:InvalidInputDimensions', ...
        'The inputs must be the same size n or 1' );
end

% equation 15
LAI = ( ( 1 - 1 / ( 2 .* K ) ) .* fb - 1 ) .* log( tau ) ./ ...
    ( A .* ( 1 - 0.47 .* fb ) );

end

