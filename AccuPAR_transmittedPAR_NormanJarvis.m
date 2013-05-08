function tau = AccuPAR_transmittedPAR_NormanJarvis( fb, L, K, a )
%ACCUPAR_TRANSMITTEDPAR_NORMANJARVIS Summary of this function goes here
%
% DETAILED DESCRIPTION:
%   This function computes the fraction of canopy extinction by using
%       Campbell (1986). This function assumes a ellipsoidal leaf angle
%       distribution.
%
% INPUTS:
%   fb: the fraction of incident PAR from the sun vs other sources. Can be
%       computed by using AccuPAR_BeamFraction.m
%   L: the leaf area index
%   K: the canopy extinction. Can be computed with
%       AccuPAR_CanopyExtinction.m
%   a: (optional) the leaf absorbtivity in the PAR band. Default is 0.9
%
% OUTPUTS:
%   tau: the fraction of transmitted light in the PAR band
%
% HISTORY:
%   2013-05-08: Written by Paul Romanczyk (par4249 at rit dot edu)
% 
% REFERENCES:
%   http://www.decagon.com/assets/Manuals/AccuPAR-LP-80.pdf

if nargin < 4
    a = 0.9;
end

A = 0.283 + 0.785 .* a - 0.159 .* a .^2;

fb = fb(:);
L = L(:);
K = K(:);
A = A(:);

% error checking
nf = numel( fb );
nL = numel( L );
nK = numel( K );
nA = numel( A );

N = [ nf nL nK nA ];
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
    if nL == 1
        L = L .* ones( u( 2 ), 1 ); 
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

% equation 14
tau = exp( ( A .* ( 1 - 0.47 .* fb ) .* L ) ./ ...
    ( ( 1 - 1 ./ ( 2.0 .* K ) ) .* fb - 1 ) );

end

