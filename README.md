# Zadanie-SQL

Zastosowane założenia:
Multitenancy - System obsługuje wiele niezależnych podmiotów.
Responsywność - Zakłada się, że system będzie musiał obsłużyć miliony zadań i użytkowników.
Hierarchia użytkowników - Menadżerowie mogą zarządzać i przeglądać zadania swoich podwładnych, ale nie mogą zmieniać zadań innych menadżerów ani ich podwładnych.
Historia zmian - W systemie przechowywana jest historia zmian każdego zadania.
Statystyki - Menadżerowie mogą przeglądać statystyki zadań na poziomie swoich podwładnych z podziałem na miesiące. 

Jednak aby najlepiej stowrzyć hierarchie, powinny zostać stworzone grupy użytkowników w bazie SQL lub aplikacja np. webowa, która po loginie ograniczała by zakres widocznych danych. Np. na stronie loguje się użytkownik i ma widok swoich zadań które pobierają się po jego ID, które zapisane jest w np. loginie.
W samej bazie można by obsłużyć to rolami z odpowiednimi uprawnieniami, ale nie pozowoliło by to na podział między swoich pracowników a innych menadzerów.

#Tabele

Podmioty (Tenants)
Tenants: Przechowuje informacje o podmiotach korzystających z systemu. Np. Firma A to tenant o ID 1. Do tego podmiotu nalezy użytkownik o ID 1,3,4 itd. 

Użytkownicy (Users)

Users: Przechowuje informacje o użytkownikach, ich rolach oraz przynależności do podmiotów.
UserAssignments: Przechowuje informacje o przypisaniu pracowników do menadżerów.

Zadania (Tasks)
Tasks: Przechowuje informacje o zadaniach.
TaskHistory: Przechowuje historię zmian zadań.
TaskShare: Przechowuje informacje o zadaniach udostępnionych innym użytkownikom.

#Procedury składniowe

Dodawanie zadań:
CreateTask: Tworzy nowe zadanie.

Edycja zadań:
UpdateTask: Aktualizuje zadanie oraz dodaje wpis do historii.

Usuwanie zadań:
DeleteTask: Usuwa zadanie i odpowiednie wpisy w historii.

Zarządzanie użytkownikami:
CreateTenant: Tworzy nowy podmiot.
CreateUser: Tworzy nowego użytkownika.
AssignUserToManager: Przypisuje pracownika do menadżera.

Zarządzanie podmiotami:
CreateTenant: Tworzy nowy podmiot.

Przeglądanie statystyk:
GetTaskStatistics: Zwraca statystyki zadań dla menadżera.
GetTasksForManager: Zwraca wszystkie zadania dla menadżera o podanym ID oraz jego podwładnych.
GetTasksForUser: Zwraca wszystkie zadania dla użytkownika o podanym ID.

Skrypty znajdują się w odpowiednio nazwanych plikach.
