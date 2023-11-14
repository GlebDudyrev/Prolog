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
    patient_address : (fullname Name, address Address) nondeterm anyflow.
clauses
    patient_address(X, Y) :-
        patient_card(_, X, Y, _, _, _).

class predicates
    patient_phone : (fullname Имя_пациента, phone_number Телефон) nondeterm anyflow.
clauses
    patient_phone(X, Y) :-
        patient_card(_, X, _, Y, _, _).

class predicates
    patient_age : (fullname Имя_пациента, age Возраст) nondeterm anyflow.
clauses
    patient_age(X, Y) :-
        patient_card(_, X, _, _, Y, _).

class predicates
    patient_on_medical : (id Id_Patient, medical Medical) nondeterm anyflow.
clauses
    patient_on_medical(X, Y) :-
        reception(_, X, _, _, _, Y).

class predicates
    pacient_diagnosis : (fullname Имя_пациента, diagnosis Диагноз) nondeterm anyflow.
clauses
    pacient_diagnosis(X, Y) :-
        patient_card(Z, X, _, _, _, _),
        reception(_, Z, _, Y, _, _).

class predicates
    doctor_of_pacient : (fullname Имя_пациента, fullname Имя_врача) nondeterm anyflow.
clauses
    doctor_of_pacient(X, Y) :-
        patient_card(Z, X, _, _, _, _),
        reception(D, Z, _, _, _, _),
        doctor(D, Y, _).

class predicates
    specialization_of_doctor : (fullname Имя_пациента, specialization Специальность) nondeterm anyflow.
clauses
    specialization_of_doctor(X, Y) :-
        patient_card(Z, X, _, _, _, _),
        reception(D, Z, _, _, _, _),
        doctor(D, _, Y).

class predicates
    oldest_patient : (fullname Name, age Age) nondeterm anyflow.
clauses
    oldest_patient(X, Y) :-
        patient_card(_, X, _, _, Y, _),
        not((patient_card(_, _, _, _, Z, _) and Z > Y)).

class predicates
    youngest_patient : (fullname Name, age Age) nondeterm anyflow.
clauses
    youngest_patient(X, Y) :-
        patient_card(_, X, _, _, Y, _),
        not((patient_card(_, _, _, _, Z, _) and Z < Y)).

class predicates
    range_of_ages : (integer Res) nondeterm anyflow.
clauses
    range_of_ages(Res) :-
        youngest_patient(_, Y),
        oldest_patient(_, B),
        Res = B - Y.

class predicates
    counter_of_patients : (integer [out]) nondeterm.
clauses
    counter_of_patients(Res) :-
        assert(count_of_patients(0)),
        patient_card(_, _, _, _, _, _),
        retract(count_of_patients(Count)),
        Res = Count + 1,
        asserta(count_of_patients(Res)),
        fail.

    counter_of_patients(Res) :-
        retract(count_of_patients(Res)).

class predicates
    avg_age : (real [out]) nondeterm.
clauses
    avg_age(Res) :-
        assert(total_age(0)),
        patient_card(_, _, _, _, X, _),
        retract(total_age(Total)),
        Sum = Total + X,
        asserta(total_age(Sum)),
        fail.
    avg_age(Res) :-
        retract(total_age(Sum)),
        counter_of_patients(Count),
        Res = Sum / Count.

clauses
    run() :-
        consult("../db.txt", polyclinicDb),
        fail.

    run() :-
        nl,
        write("Адреса пациентов:\n"),
        patient_address(X, Y),
        write(X, ": ", Y),
        nl,
        fail.

    run() :-
        nl,
        write("Номера телефонов:\n"),
        patient_phone(X, Y),
        write(X, ": ", Y),
        nl,
        fail.

    run() :-
        nl,
        write("Возраст пациентов:\n"),
        patient_age(X, Y),
        write(X, ": ", Y),
        nl,
        fail.

    run() :-
        nl,
        write("Пациенты на больничном:\n"),
        patient_on_medical(X, yes),
        write(X),
        nl,
        fail.

    run() :-
        nl,
        write("Диагнозы пациентов:\n"),
        pacient_diagnosis(X, Y),
        write(X, ": ", Y),
        nl,
        fail.

    run() :-
        nl,
        write("Пациент и его лечащий врач:\n"),
        doctor_of_pacient(X, Y),
        write(X, ": ", Y),
        nl,
        fail.

    run() :-
        nl,
        write("Пациент и специальность врача, который его лечит:\n"),
        specialization_of_doctor(X, Y),
        write(X, ": ", Y),
        nl,
        fail.

    run() :-
        nl,
        write("Самый старший пациент:\n"),
        oldest_patient(X, Y),
        write(X, ": ", Y),
        nl,
        fail.

    run() :-
        nl,
        write("Самый младший пациент:\n"),
        youngest_patient(X, Y),
        write(X, ": ", Y),
        nl,
        fail.

    run() :-
        nl,
        write("Размах возраста пациентов:\n"),
        range_of_ages(Range),
        write(Range),
        nl,
        fail.

    run() :-
        nl,
        write("Количество пациентов:\n"),
        counter_of_patients(Res),
        write(Res),
        nl,
        fail.

    run() :-
        nl,
        write("Средний возраст пациентов:\n"),
        avg_age(Res),
        write(Res),
        nl,
        fail.

    run().

end implement main

goal
    console::runUtf8(main::run).
