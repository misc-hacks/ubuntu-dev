ubuntu-dev
==========

Ubuntu images for development purposes.

## Supported Environment Variables

- `TIMEZONE`
  - The value is used to modify the `TZ` value in user `dev`'s `.zshrc` file.
  - Note the default `TZ` value is `Asia/Shanghai`.
- `SUDO_PASSWORD_HASH`
  - The value is used to set the password of `dev`, the default sudo user.
  - Note the value is only used when the password of `dev` is not set.
  - To generate a password hash, we can use `openssl passwd -5`.
- `PUBLIC_KEY_DIR`
  - The value specifies a directory containing SSH keys. Those keys would be
    copied to the `authorized_keys` file so that authorized users can log in
    containers via SSH services without passwords.
  - Note the value should point to a directory within the container.
    Nevertheless, we can mount an external volume to that directory and so keys
    can be persisted.
  - Besides, the `authorized_keys` would be overridden on each restart (i.e.,
    manually added keys would be lost on each restart).

## Supported Services

The SSH service would be started automatically and we can export it by mapping
the SSH port, e.g., `-p 2222:22`.

## Other Hints

The main process recognizes two magic files, namely `/tmp/__magic_exit_0` and
`/tmp/__magic_exit_1`. If the main process detects `/tmp/__magic_exit_0`, it
would exit with code 0, and similarly, it would exit with code 1 when
`/tmp/__magic_exit_1` is detected. These magic files allow us to stop
containers from inside. And when containers are run with flags like
`--restart on-failure`, touching `/tmp/__magic_exit_1` would allow us to restart
containers from inside. 

## Example Starting Script

```bash
HASH=$(openssl passwd -5)
docker run -d \
  -e SUDO_PASSWORD_HASH=${HASH} \
  -e PUBLIC_KEY_DIR=/mnt/keys \
  -p 2222:22 \
  -v $(pwd)/keys:/mnt/keys \
  ghcr.io/misc-hacks/ubuntu-dev:20.04
```
