% Symptoms
symptom(fever).
symptom(cough).
symptom(sore_throat).
symptom(runny_nose).
symptom(headache).
symptom(fatigue).
symptom(chest_pain).
symptom(shortness_of_breath).
symptom(body_aches).
symptom(nausea).
symptom(diarrhea).
symptom(vomiting).
symptom(chills).
symptom(loss_of_taste_or_smell).
symptom(dizziness).

% Diseases
disease(flu, 'Influenza, commonly known as the flu, is a viral infection that attacks the respiratory system.').
disease(cold, 'The common cold is a viral infection of your nose and throat (upper respiratory tract).').
disease(covid19, 'COVID-19 is a respiratory illness caused by the coronavirus SARS-CoV-2.').
disease(pneumonia, 'Pneumonia is an infection that inflames the air sacs in one or both lungs.').
disease(stomach_flu, 'Stomach flu (gastroenteritis) is an intestinal infection marked by nausea, diarrhea, and vomiting.').
disease(malaria, 'Malaria is a life-threatening disease caused by parasites transmitted through the bites of infected mosquitoes.').
disease(migraine, 'Migraine is a neurological condition that can cause multiple symptoms, including severe headache and dizziness.').

disease_details(UserInput) :-
    (UserInput = all ->
        write('All Disease Information:'), nl,
        forall(disease(Name, Description),
               (write('Name: '), write(Name), nl,
                write('Description: '), write(Description), nl, nl));
     disease(UserInput, Description) ->
        write('Name: '), write(UserInput), nl,
        write('Description: '), write(Description), nl;
        write('No disease found with the given input.'), nl).

% Relationships between diseases and symptoms
has_symptom(flu, fever).
has_symptom(flu, cough).
has_symptom(flu, sore_throat).
has_symptom(flu, headache).
has_symptom(flu, body_aches).
has_symptom(flu, chills).

has_symptom(cold, runny_nose).
has_symptom(cold, sore_throat).
has_symptom(cold, cough).
has_symptom(cold, headache).
has_symptom(cold, fatigue).

has_symptom(covid19, fever).
has_symptom(covid19, cough).
has_symptom(covid19, fatigue).
has_symptom(covid19, headache).
has_symptom(covid19, shortness_of_breath).
has_symptom(covid19, loss_of_taste_or_smell).

has_symptom(pneumonia, fever).
has_symptom(pneumonia, cough).
has_symptom(pneumonia, chest_pain).
has_symptom(pneumonia, shortness_of_breath).

has_symptom(stomach_flu, nausea).
has_symptom(stomach_flu, diarrhea).
has_symptom(stomach_flu, fatigue).
has_symptom(stomach_flu, vomiting).

has_symptom(malaria, fever).
has_symptom(malaria, chills).
has_symptom(malaria, body_aches).
has_symptom(malaria, nausea).

has_symptom(migraine, headache).
has_symptom(migraine, dizziness).
has_symptom(migraine, nausea).

% Rule: A disease is diagnosed if all its associated symptoms are present.
diagnose(Disease) :-
    disease(Disease, _), 
    findall(Symptom, has_symptom(Disease, Symptom), Symptoms),
    check_all_symptoms(Symptoms).

% Helper Rule: Check if the user has all symptoms in the list.
check_all_symptoms([]).
check_all_symptoms([Symptom | Rest]) :-
    ask_symptom(Symptom),
    check_all_symptoms(Rest).

% Suggest potential diseases if some symptoms match
partial_diagnose(Disease) :-
    disease(Disease, _),
    findall(Symptom, has_symptom(Disease, Symptom), Symptoms),
    count_matching_symptoms(Symptoms, Count),
    Count > 0.

% Count the number of matching symptoms
count_matching_symptoms([], 0).
count_matching_symptoms([Symptom | Rest], Count) :-
    (yes(Symptom) -> count_matching_symptoms(Rest, RestCount), Count is RestCount + 1;
    count_matching_symptoms(Rest, Count)).

% Dynamic fact to store user responses
:- dynamic(yes/1).
:- dynamic(no/1).

% User interaction: Ask if a symptom is present
ask_symptom(Symptom) :-
    (yes(Symptom) -> true; 
    no(Symptom) -> fail;
    write('Do you have '), write(Symptom), write('? (yes/no)'), nl,
    read(Response),
    (Response == yes -> assert(yes(Symptom));
    Response == no -> assert(no(Symptom)), fail;
    write('Invalid input, please type yes or no.'), nl,
    ask_symptom(Symptom))).

% Clear previous user responses
clear_responses :-
    retractall(yes(_)),
    retractall(no(_)).

% Start diagnosis and provide feedback
start_diagnosis :-
    clear_responses,
    (diagnose(Disease) ->
        disease(Disease, Description),
        write('You may have: '), write(Disease), nl,
        write('Description: '), write(Description), nl;
        write('No exact match found for the symptoms.'), nl,
        findall(PossibleDisease, partial_diagnose(PossibleDisease), PossibleDiseases),
        (PossibleDiseases \= [] ->
            write('You might have: '), write(PossibleDiseases), nl;
            write('No matching disease found. Please consult a doctor.'), nl)).

% Menu for user interaction
menu :-
    nl,
    write(' ================================================='), nl,
    write('|   Welcome to the Interactive Diagnosis System   |'), nl,
    write(' ================================================='), nl,
    write('1. Start Diagnosis'), nl,
    write('2. View All Disease Details'), nl,
    write('3. View Specific Disease Details'), nl,
    write('4. Exit'), nl,
    write('Enter your choice (1/2/3/4): '), nl,
    read(Choice),
    handle_choice(Choice).

% Handle user menu choices
handle_choice(1) :-
    start_diagnosis,
    menu.
handle_choice(2) :-
    disease_details(all),
    menu.
handle_choice(3) :-
    write('Enter disease name: '),
    read(UserInput),
    disease_details(UserInput),
    menu.
handle_choice(4) :-
    write('Goodbye! Stay healthy!'), nl.
handle_choice(_) :-
    write('Invalid choice. Please try again.'), nl,
    menu.
