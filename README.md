# Zadanie-SQL

Zastosowane założenia:
Multitenancy - System obsługuje wiele niezależnych podmiotów.
Responsywność - Zakłada się, że system będzie musiał obsłużyć miliony zadań i użytkowników.
Hierarchia użytkowników - Menadżerowie mogą zarządzać i przeglądać zadania swoich podwładnych, ale nie mogą zmieniać zadań innych menadżerów ani ich podwładnych.
Historia zmian - W systemie przechowywana jest historia zmian każdego zadania.
Statystyki - Menadżerowie mogą przeglądać statystyki zadań na poziomie swoich podwładnych z podziałem na miesiące. 

#Tabele
Podmioty (Tenants)
Tenants: Przechowuje informacje o podmiotach korzystających z systemu.

Użytkownicy (Users)
Users: Przechowuje informacje o użytkownikach, ich rolach oraz przynależności do podmiotów.
UserRoles: Przechowuje informacje o rolach użytkowników (pracownik/menadżer).
UserAssignments: Przechowuje informacje o przypisaniu pracowników do menadżerów.

Zadania (Tasks)
Tasks: Przechowuje informacje o zadaniach.
TaskHistory: Przechowuje historię zmian zadań.
TaskShare: Przechowuje informacje o zadaniach udostępnionych innym użytkownikom.

Statystyki (Statistics)
TaskStatistics: Widok generujący statystyki zadań na poziomie użytkowników i miesięcy.

#Procedury składniowe
Dodawanie zadań:
sp_CreateTask: Tworzy nowe zadanie.

Edycja zadań:
sp_UpdateTask: Aktualizuje zadanie oraz dodaje wpis do historii.

Usuwanie zadań:
sp_DeleteTask: Usuwa zadanie i odpowiednie wpisy w historii.

Zarządzanie użytkownikami:
sp_CreateUser: Tworzy nowego użytkownika.
sp_AssignUserToManager: Przypisuje pracownika do menadżera.

Zarządzanie podmiotami:
sp_CreateTenant: Tworzy nowy podmiot.

Przeglądanie statystyk:
sp_GetTaskStatistics: Zwraca statystyki zadań dla menadżera.
