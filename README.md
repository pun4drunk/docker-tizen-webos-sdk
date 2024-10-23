# Docker Image for Tizen Signed Package

This docker image extends the great [vitalets/docker-tizen-webos-sdk](https://github.com/vitalets/docker-tizen-webos-sdk).

Additionally, it implements the highly-demanded Tizen signed package feature by running `gnome-keyring` and `xbus` in Docker, helping you to finally get rid of that annoying "Invalid Password" error.

## How to Run Your Package

1. **Mount your certificates at `/certificates` and your working project at `/data`.**
2. **Pass environment variables:**
    - `SIGN_PROFILE`: Security profile name
    - `SIGN_AUTHOR_CERT`: Path to your author cert (default: `/certificates/author.p12`)
    - `SIGN_AUTHOR_CERT_PASS`: Your author cert password
    - `SIGN_DISTRIBUTOR_CERT`: Path to your distributor cert (default: `/certificates/distributor.p12`)
    - `SIGN_DISTRIBUTOR_CERT_PASS`: Your distributor cert password
3. **Enable `ipc_lock` capability by running Docker with `--cap-add ipc_lock`.**
4. **Run `tizen-package` executable, included in image PATH, using `dbus-run-session`.**

## Example

```sh
docker run -w /data \
    -v '/path/to/your/certificates:/certificates' \
    -v '/path/to/your/project:/data' \
    -e 'SIGN_PROFILE=YourSecurityProfile' \
    -e 'SIGN_AUTHOR_CERT=/certificates/author.p12' \
    -e 'SIGN_AUTHOR_CERT_PASS=authorCertPassword' \
    -e 'SIGN_DISTRIBUTOR_CERT=/certificates/distributor.p12' \
    -e 'SIGN_DISTRIBUTOR_CERT_PASS=distributorCertPassword' \
    --rm --cap-add ipc_lock \
    'pun4drunk/docker-tizen-webos-sdk' \
    dbus-run-session /scripts/package --type wgt --sign YourSecurityProfile --output '.' -- './.buildResult'
```

## Output example:

```sh
GNOME_KEYRING_CONTROL=/home/developer/.cache/keyring-8FT3V2
SSH_AUTH_SOCK=/home/developer/.cache/keyring-8FT3V2/ssh
Loaded in '/home/developer/tizen-studio-data/profile/profiles.xml'.
author path: /certificates/author.p12
author password: ****************
distributor1 path: /certificates/distributor.p12
distributor1 password: ****************

Wrote to '/home/developer/tizen-studio-data/profile/profiles.xml'.
Succeed to add 'YourSecurityProfile' profile.
If want to sign by this, add the file of security profiles in CLI configuration
  like 'tizen cli-config "profiles.path=/home/developer/tizen-studio-data/profile/profiles.xml"'.
Setting configuration is succeeded....

Author certficate: /certificates/author.p12
Distributor1 certificate : /certificates/distributor.p12
Excludes File Pattern: {.manifest.tmp, .delta.lst}
Ignore File: /data/.buildResult/.manifest.tmp
Package File Location: /data/YourProject.wgt
```