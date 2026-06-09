# Librepods-WindowsFix
This fork only contains files for a windows "bridge" of librepods

Thanks to:
- The Librepods project (https://github.com/kavishdevar/librepods)
- Tblob18 (https://github.com/Tblob18/librepods-windows)

This fork successfully allows for librepods to work on windows with the ability to change listening modes and more.

## How does it work?

LibrePods communicates with AirPods over the Bluetooth **L2CAP** protocol, but Windows
blocks user-mode L2CAP, which is why a normal build can't connect. To work around this,
this fork uses the [MagicAAP driver](https://magicpods.app/magicaap/) to talk to the
AirPods at the kernel level. (own driver in the works)

## Steps to install

1. Install the **MagicAAP driver** in Windows **Test Mode**.

> **Do NOT install the community-signed driver.** It relies on a code-signing exploit
> (a leaked certificate plus an untrusted root CA) and opens a potential backdoor on your
> system.
