.thumb


; enum NascEnvironment {
; 	PROD = 0,
; 	TEST = 1,
; 	DEV = 2,
; };

; NascEnvironment::TEST
@nasc_test_environment equ 1
; Location of the nasc test url
@nasc_test_url equ 0x16129A
; Sets the nasc environment argument (r1), normally NascEnvironment::PROD
@set_game_nasc_environment equ 0x12283C


; Use the test environment when a game wants to connect online
.org @set_game_nasc_environment
mov r1, @nasc_test_environment


; Replace the test url with a one that points to a private server
.org @nasc_test_url
; 'nasc_url' needs to be provided to armips at the time of assembly
.asciiz nasc_url
