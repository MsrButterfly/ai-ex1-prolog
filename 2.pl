:- dynamic color/1.
:- dynamic size/1.
:- dynamic eats/1.
:- dynamic tail/1.
:- dynamic live/1.
%% 1)
bird(raven):- color(black), size(medium), eats(meat), tail(wedge), live(forest).
bird(sparrow):- color(brown), size(small), eats(corn), tail('short square'), live(field).
bird(swallow):- color(white), size(medium), eats(insects), tail(forked), live(barn).
bird(magpie):- color('black white'), size(large), eats(omnivorous), tail(long), live(trees).
%% 2)
:- dynamic known/3.
color(Value):- known(yes, color, Value).
size(Value):- known(yes, size, Value).
eats(Value):- known(yes, eats, Value).
tail(Value):- known(yes, tail, Value).
live(Value):- known(yes, live, Value).
has(Attribute, Value):- known(_, Attribute, Value).
add(Result, Attribute, Value):- Result = yes,
                                assert(known(yes, Attribute, Value)).
add(Result, Attribute, Value):- \+Result = yes,
                                assert(known(no, Attribute, Value)).
ask(Attribute, Value):- has(Attribute, Value), fail.
ask(Attribute, Value):- \+has(Attribute, Value),
                        write(Attribute), write(': '), write(Value),
                        write(' (yes or no)? '), read(Result),
                        add(Result, Attribute, Value), !.
%% 3)
is_color(black).
is_color(brown).
is_color(white).
is_color('black white').
is_size(medium).
is_size(small).
is_size(large).
is_food(meat).
is_food(corn).
is_food(insects).
is_food(omnivorous).
is_shape(wedge).
is_shape('short square').
is_shape(forked).
is_shape(long).
is_place(forest).
is_place(field).
is_place(barn).
is_place(trees).
add_bird_attributes(Color, Size, Food, Shape, Place):-
    is_color(Color), is_size(Size), is_food(Food),
    is_shape(Shape), is_place(Place),
    assert(color(Color)), assert(size(Size)), assert(eats(Food)),
    assert(tail(Shape)), assert(live(Place)).
remove_all_bird_attributes:-
    retractall(color(_)), retractall(size(_)), retractall(eats(_)),
    retractall(tail(_)), retractall(live(_)).
identify:- retractall(known(_, _, _)), remove_all_bird_attributes,
           is_color(Color), ask(color, Color), known(yes, color, Color),
           is_size(Size), ask(size, Size), known(yes, size, Size),
           is_food(Food), ask(eats, Food), known(yes, eats, Food),
           is_shape(Shape), ask(tail, Shape), known(yes, tail, Shape),
           is_place(Place), ask(live, Place), known(yes, live, Place),
           add_bird_attributes(Color, Size, Food, Shape, Place),
           bird(Bird), write('The '), write(Bird), write(' is a '), write(Size),
           write('-sized bird with '), write(Color), write(' body and '),
           write(Shape), write(' tail.'), nl, write('It eats '), write(Food),
           write(' and lives at '), write(Place), write('.'), nl, !.
