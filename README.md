# 3ds FRD unofficial server patch

This patches the 3ds FRD system module to make building and testing unofficial 3ds game servers easier.

## Why does this exist?

Building and testing unofficial servers for 3ds online play has a few issues:

- With the 3ds friend services still operational, it wouldn't be good to use unofficial friend services since it would be easy to get desynchronized from the official services
- 3ds users have a hidden password that is used to go online. It would be bad to rely on a user's real password for unofficial servers for obvious security reaons
- NASC uses specific root CAs that don't work with any random server

This patch does the following things:

- Use official servers and the 3ds user's real password for friend services
- Use unofficial servers and a fake password for games
- Use a custom root CA so TLS doesn't have to be disabled when talking with the NASC server

## Building and installing

Make sure to have [armips](https://github.com/Kingcom/armips) and [flips](https://github.com/Alcaro/Flips) installed or an image built from the provided dockerfile

1. Extract the `code.bin` from the frd sysmodule (0004013000003202) and put it in this directory
1. Run `make -e PASSWORD="<password>" -e NASC_URL="<nasc url>" -e ROOT_CA="<cert file>" -e ROOT_CA_SIZE=<cert size>`
1. Copy the resulting `code.ips` to `/luma/titles/0004013000003202/code.ips`

### Building with docker

1. `docker build -t patch-builder .`
1. `docker run --rm -w /app -v $(pwd):/app patch-builder make -e PASSWORD="<password>" -e NASC_URL="<nasc url>" -e ROOT_CA="<cert file>" -e ROOT_CA_SIZE=<cert size>`
