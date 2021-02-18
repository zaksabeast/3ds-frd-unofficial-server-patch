.thumb


; The password is located in empty space
; password = *password_ptr
@password_ptr equ 0x164F94
; password = *(password_struct + 4)
; password_ptr = password_struct + 4
; password_struct = password_ptr - 4
; We don't have to care about any other parts of the struct
@password_struct equ @password_ptr - 4
; password = *(*password_struct_ptr + 4)
@password_struct_ptr equ 0x127620
; Sets r0 to the password struct
; The next routine called after this will read the password from *(r0 + 4)
@set_password_struct equ 0x1275dc


; This instruction normally reads a constant from password_struct_ptr
; To free up password_struct_ptr, this instruction will read the same constant from another address
.org 0x127608
ldr r0, [0x12767c]


; With this address no longer being referenced by anything, it can point to password_struct instead
.org @password_struct_ptr
.word @password_struct


; so r0 needs to be password_struct which is loaded password_struct_ptr
.org @set_password_struct
ldr r0, [@password_struct_ptr]


; Set the pointer to the alternate password
.org @password_ptr
.word @alternate_password


@alternate_password:
  ; 'password' needs to be provided to armips at the time of assembly
  .halfword password, 0
