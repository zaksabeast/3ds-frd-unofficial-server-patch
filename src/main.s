.3ds

.open "code.bin", "code_patched.bin", 0x100000

.include "src/add-game-server-root-ca.s"
.include "src/change-game-nasc.s"
.include "src/alternate-password.s"

.close
