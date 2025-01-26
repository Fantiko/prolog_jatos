% Jato 0
:- module(jato0, [obter_controles/2]).

%% Explicação:
% Sensores:
% X: posição horizontal do jato
% Y: posiçao vertical do jato
% ANGLE: angulo de inclinacao do jato: 0 para virado para frente até PI*2 (~6.28)
% Sensores: olhe em "doc/info.png"
%   S1,S2,S3,S4,S5,S6,S7,S8,S9,S10: valores de 0 à 1, onde 0 indica sem obstáculo e 1 indica tocando o jato
% SCORE: inteiro com a "vida" do jato. Em zero, ele perdeu
% SPEED: velocidade do jato
% Controles:
% [FORWARD, REVERSE, LEFT, RIGHT, BOOM]
% FORWARD: 1 para acelerar e 0 para continuar a velocidade atual
% REVERSE: 1 para desacelerar e 0 para continuar a velocidade atual
% LEFT: 1 para ir pra esquerda e 0 para não ir
% RIGHT: 1 para ir pra direita e 0 para não ir
% BOOM: 1 para tentar disparar (BOOM). Obs.: ele só pode disparar uma bala a cada segundo

troca(0, 1).
troca(1, 0).

% [FORWARD, REVERSE, LEFT, RIGHT, BOOM]

% Acelera caso nao haja perigo
obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,SCORE,SPEED], [FORWARD, 0, 0, 0, 1]) :-
    DEBOA is 0.5,
    (S1 =< DEBOA; S2 =< DEBOA; S8 =< DEBOA; S9 =< DEBOA; S10 =< DEBOA) ->
        FORWARD is 10,

% Desacelera caso perigo
obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,SCORE,SPEED], [0, REVERSE, 0, 0, 1]) :-
    PERIGO is 0.6,
    ((S5 =< PERIGO, S4 =< PERIGO, S6 =< PERIGO), SPEED >= 1) ->
        REVERSE is 1.

% Chegar de frente
obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,SCORE,SPEED], [0, 1, LEFT, RIGHT, 1]) :-
    PERIGO is 0.5,
    (S5 >= PERIGO, S4 >= PERIGO, S6 >= PERIGO) ->
        % Escolher o lado mais livre para virar
        ((S6 + S7 + S8) < (S2 + S3 + S4) ->
            (LEFT is 0, RIGHT is 1)
        ;
            (LEFT is 1, RIGHT is 0)).

% Chegar pela direita
obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,SCORE,SPEED], [AA, 0, LEFT, 0, 1]) :-
    PERIGO is 0.4,
    (S5 >= PERIGO; (S6 >= PERIGO, S7 >= PERIGO)) ->
        random_between(0,1,AA),
        LEFT is 1.

% Chegar pela esquerda
obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,SCORE,SPEED], [AA, 0, 0, RIGHT, 1]) :-
    PERIGO is 0.4,
    (S5 >= PERIGO; (S4 >= PERIGO, S3 >= PERIGO)) ->
        random_between(0,1,AA),
        RIGHT is 1.

% Proteção contra ficar em cima de outro jato
obter_controles([X,Y,ANGLE,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,SCORE,SPEED], [FORWARD, 0, 0, 0, 1]) :-
    PERIGO is 0.8,
    (S1 >= PERIGO, S2 >= PERIGO, S3 >= PERIGO, S4 >= PERIGO, S5 >= PERIGO, S6 >= PERIGO, S7 >= PERIGO, S8 >= PERIGO, S9 >= PERIGO, S10 >= PERIGO) ->
        FORWARD is 1.

% Para evitar erros, o jato para:
obter_controles(_, [0,0,0,0,0]).
