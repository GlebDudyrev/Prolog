implement main
    open core, stdio, file

domains
    id = integer.
    fullname = string.
    address = string.
    phone_number = string.
    age = integer.
    work_place = string.
    specialization = string.
    date = integer.
    diagnosis = string.
    purpose = string.
    medical = yes; no.

class facts - polyclinicDb
    total_age : (integer) determ.
    count_of_patients : (integer) determ.
    patient_card : (id, fullname, address, phone_number, age, work_place) nondeterm.
    doctor : (id, fullname, specialization) nondeterm.
    reception : (id, id, date, diagnosis, purpose, medical) nondeterm.

class predicates
    findClient : (fullname Name, string* List) nondeterm.
clauses
    findClient(Name, [Name | _]).
    findClient(Name, [_ | Tail]) :-
        findClient(Name, Tail).

class predicates
    findClientInList : (fullname Name).
clauses
    findClientInList(Name) :-
        List = clientsList(),
        findClient(Name, List),
        write(Name, "-клиент есть в списке"),
        !.
    findClientInList(Name) :-
        write(Name, "-клиента нет в списке").

class predicates
    clientsList : () -> string* nondeterm.
clauses
    clientsList() = List :-
        List = [ Name || patient_card(_, Name, _, _, _, _) ].

class predicates
    clientsAgeList : () -> integer* nondeterm.
clauses
    clientsAgeList() = List :-
        List = [ Age || patient_card(_, _, _, _, Age, _) ].

class predicates
    length : (A*) -> integer N.
    sum_list : (integer* List) -> integer Sum.
    avg_list : (integer* List) -> real Average determ.
    max_age : (integer* List, integer Max) nondeterm anyflow.
    max : (integer X, integer Y, integer Z) nondeterm anyflow.

clauses
    max(X, Y, Max) :-
        X <= Y,
        Max = Y.
    max(X, Y, Max) :-
        X >= Y,
        Max = X.

    max_age([Max], Max).
    max_age([H | T], Max) :-
        max_age(T, M),
        max(H, M, Max).

    length([]) = 0.
    length([_ | T]) = length(T) + 1.

    sum_list([]) = 0.
    sum_list([H | T]) = sum_list(T) + H.

    avg_list(L) = sum_list(L) / length(L) :-
        length(L) > 0.

class predicates
    clientsCount : () -> integer Count nondeterm.
clauses
    clientsCount() = length(clientsList()).

class predicates
    printList : (string* Str).
    printList_int : (integer* Int).

clauses
    printList(L) :-
        foreach Elem = list::getMember_nd(L) do
            write(Elem, '; ')
        end foreach,
        write("\n").

    printList_int(L) :-
        foreach Elem = list::getMember_nd(L) do
            write(Elem, '; ')
        end foreach,
        write("\n").

clauses
    run() :-
        consult("../db.txt", polyclinicDb),
        fail.

    run() :-
        nl,
        List = clientsList(),
        printList(List),
        nl,
        fail.

    run() :-
        nl,
        Length = length(clientsList()),
        write("Количество пациентов посчитанное с помощью списка: ", Length),
        nl,
        fail.

    run() :-
        nl,
        AvgAge = avg_list(clientsAgeList()),
        write("Средний возраст пациентов, посчитаный с помощью списка возраста: ", AvgAge),
        nl,
        fail.

    run() :-
        nl,
        List = clientsList(),
        findClient("Oleg Dobrii", List),
        write("No"),
        nl,
        fail.

    run() :-
        nl,
        findClientInList("Grigoryev Nikita"),
        nl,
        fail.

    run() :-
        nl,
        List = clientsAgeList(),
        max_age(List, Max),
        write("Максимальный возраст:", Max),
        nl,
        fail.

    run().

end implement main

goal
    console::runUtf8(main::run).
