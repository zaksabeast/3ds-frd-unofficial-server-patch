all:
	@armips src/main.s -strequ password $(PASSWORD) -strequ nasc_url $(NASC_URL) -strequ root_ca $(ROOT_CA) -equ root_ca_size $(ROOT_CA_SIZE)
	@flips -c code.bin code_patched.bin code.ips

clean:
	@rm code_patched.bin code.ips
