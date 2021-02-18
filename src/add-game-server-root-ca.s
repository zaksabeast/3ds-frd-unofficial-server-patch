; Thanks to libctru for the reference
; https://github.com/devkitPro/libctru/blob/master/libctru/source/services/httpc.c

.thumb


get_thread_local_storage equ 0x135840
add_default_cert equ 0x12b748


; Empty space in .data to store things
@empty_data_space equ 0x162e80
; Empty space in .text to store things
@empty_text_space equ 0x156cf0  
; Adds a default cert (SSLC_DefaultRootCert in libctru) to the nasc request http context
; Multiple certs are added around here, this just adds cert 1
@add_nasc_default_cert_1 equ 0x11d186


.org @empty_text_space
; r0 should have the httpc context
@add_game_server_root_ca:
  push { r1, r4, lr }
  mov r4, r0
  blx get_thread_local_storage
  add r0, #0x80 ; get thread command buffer
  ldr r1, [@add_trusted_root_ca_ipc_header]
  str r1, [r0] ; store IPC header
  ldr r1, [r4, #0x4]
  str r1, [r0,#0x4] ; store context->httpHandle
  ldr r1, [@root_ca_size]
  str r1, [r0,#0x8] ; store cert size
  lsl r1, #0x4
  add r1, #0xa ; calculate ipc description buffer
  str r1, [r0,#0xC] ; store ipc description buffer
  ldr r1, [@root_ca_ptr]
  str r1, [r0,#0x10] ; store cert pointer
  ldr r0, [r4,#0xc] ; load context->servehandle
  swi 0x32 ; svcSendSyncRequest
  pop { r1, r4, pc }

.pool
@root_ca_ptr:
  .word @root_ca
@add_trusted_root_ca_ipc_header:
  .word 0x240082
@root_ca_size:
  .word root_ca_size

@add_default_cert_1_and_game_server_root_ca:
  push { r4, lr }
  mov r4, r0 ; store http context for later
  bl @add_game_server_root_ca
  cmp r0, 0
  bne @@return ; Return if there is an error
  mov r0, r4
  mov r1, 1
  bl add_default_cert ; Add default cert 1
  @@return:
    pop { r4, pc }


.org @empty_data_space
@root_ca:
  .incbin root_ca


; Replace adding default cert 1 with a routine that
; adds the new server's root CA and default cert 1
.org @add_nasc_default_cert_1
  bl @add_default_cert_1_and_game_server_root_ca
