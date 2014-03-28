%% 1)
room(kitchen).
room(office).
room(hall).
room('dining room').
room(cellar).
location(desk, office).
location(apple, kitchen).
location(flashlight, desk).
location('washing machine', cellar).
location(nani, 'washing machine').
location(crackers, kitchen).
location(computer, office).
location(Item, ItemOrRoom):- \+Item = ItemOrRoom, location(Item, AnotherItem), location(AnotherItem, ItemOrRoom).
item(Item):- location(Item, _).
%% 2)
%% room(X), write(X), nl, fail.
%% item(X), write(X), nl, fail.
%% 3)
where(Item):- item(Item), room(Room), location(Item, Room),
              write('Item '), write(Item), write(' is in room '),
              write(Room), write('.'), nl, fail.
where(Item):- \+location(Item, _),
              write('Cannot find '), write(Item), write('.'), nl, fail.
where(Item, Room):- item(Item), room(Room), location(Item, Room),
                    write('Item '), write(Item), write(' is in room '),
                    write(Room), write('.'), nl, fail.
where(Item, Room):- \+location(Item, Room),
                    write('Cannot find '), write(Item), write('.'), nl, fail.
%% 4)
door(office, hall).
door(kitchen, office).
door(hall, 'dining room').
door(kitchen, cellar).
door('dining room', kitchen).
connected(RoomA, RoomB):- door(RoomA, RoomB) | door(RoomB, RoomA).

%% Declare dynamic procedures.
:- dynamic at/1.
:- dynamic r_at/1.
:- dynamic visited/1.
%% You will get inverted results by this procudure.
%% The first version of r_find/1, the recursive body.
r_find(Item):- at(Room), assert(visited(Room)), \+location(Item, Room),
               retract(at(Room)), room(AnotherRoom), \+visited(AnotherRoom),
               connected(Room, AnotherRoom), assert(at(AnotherRoom)),
               r_find(Item),
               write(Room), write(' => '), write(AnotherRoom), nl, !.
%% The second version of r_find/1, the base condition.
r_find(Item):- at(Room), assert(visited(Room)), location(Item, Room),
               write('Found '), write(Item), write(' at '), write(Room), write('.'), nl, !.

%% You will get normal results by this procudure.
%% The first version of find/1, the recursive body.
find(Room):- room(Room), assert(visited(Room)),
             room(Destination), at(Destination), \+Room = Destination,
             retract(r_at(Room)), room(AnotherRoom),
             \+visited(AnotherRoom), connected(Room, AnotherRoom),
             assert(r_at(AnotherRoom)), find(AnotherRoom), 
             write(AnotherRoom), write(' => '), write(Room), nl, !.
%% The second version of find/1, the base condition.
find(Room):- room(Room), assert(visited(Room)),
             room(Destination), at(Destination), Room = Destination, !.
%% The third version of find/1, the entrance.
find(Item):- item(Item), room(Room), location(Item, Room),
             assert(r_at(Room)), find(Room), 
             write('Found '), write(Item), write(' at '), write(Room), write('.'), nl, !.

%% Initialization.
at(office).

