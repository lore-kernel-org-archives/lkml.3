Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab3CTT6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 15:58:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55216 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757387Ab3CTT6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 15:58:23 -0400
Message-ID: <1363809494.31336.73.camel@deadeye.wl.decadent.org.uk>
Subject: Linux 3.2.41
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 20 Mar 2013 19:58:14 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-5pqp9j1LJuthv9b23G4T"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 82.69.69.95
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5pqp9j1LJuthv9b23G4T
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.2.41 kernel.

All users of the 3.2 kernel series should upgrade.

The updated 3.2.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.2.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git

Ben.

------------

 .../devicetree/bindings/tty/serial/of-serial.txt   |    3 +
 Makefile                                           |    2 +-
 arch/arm/kernel/perf_event_v7.c                    |    2 +-
 arch/arm/mm/alignment.c                            |   11 +-
 arch/arm/vfp/vfpmodule.c                           |    2 +-
 arch/powerpc/include/asm/eeh.h                     |    3 -
 arch/powerpc/kernel/of_platform.c                  |    3 -
 arch/powerpc/kernel/pci-common.c                   |    7 +-
 arch/powerpc/platforms/pseries/eeh.c               |   24 +-
 arch/x86/pci/xen.c                                 |    9 +
 crypto/ablkcipher.c                                |   12 +-
 crypto/aead.c                                      |    9 +-
 crypto/ahash.c                                     |    2 +-
 crypto/blkcipher.c                                 |    6 +-
 crypto/crypto_user.c                               |   22 +-
 crypto/pcompress.c                                 |    3 +-
 crypto/rng.c                                       |    2 +-
 crypto/shash.c                                     |    3 +-
 drivers/ata/ahci.c                                 |   40 +++
 drivers/block/loop.c                               |   24 +-
 drivers/char/hw_random/core.c                      |   19 +-
 drivers/char/hw_random/virtio-rng.c                |   13 +-
 drivers/connector/cn_proc.c                        |    8 +
 drivers/cpufreq/cpufreq_stats.c                    |    1 +
 drivers/firmware/dmi_scan.c                        |    5 +-
 drivers/firmware/efivars.c                         |  136 ++++++--
 drivers/gpu/drm/i915/intel_display.c               |   11 +-
 drivers/gpu/drm/radeon/radeon_combios.c            |    9 +
 drivers/hid/hid-core.c                             |    1 +
 drivers/hid/hid-ids.h                              |    1 +
 drivers/hid/hid-sony.c                             |   18 +-
 drivers/hv/hv_kvp.c                                |   10 +-
 drivers/hwmon/lineage-pem.c                        |    2 +
 drivers/hwmon/pmbus/ltc2978.c                      |   40 +--
 drivers/hwmon/sht15.c                              |    8 +-
 drivers/iommu/amd_iommu_init.c                     |   10 +-
 drivers/md/dm-crypt.c                              |   39 +--
 drivers/md/dm-delay.c                              |    8 +-
 drivers/md/dm-flakey.c                             |    7 +-
 drivers/md/dm-ioctl.c                              |   14 +-
 drivers/md/dm-linear.c                             |    7 +-
 drivers/md/dm-mpath.c                              |    8 +-
 drivers/md/dm-raid.c                               |    8 +-
 drivers/md/dm-raid1.c                              |    8 +-
 drivers/md/dm-snap.c                               |   18 +-
 drivers/md/dm-stripe.c                             |    7 +-
 drivers/md/dm-thin.c                               |   78 +++--
 drivers/md/md.c                                    |    7 +
 drivers/md/raid0.c                                 |    5 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         |    2 +-
 drivers/net/wireless/ath/ath9k/common.h            |    2 +-
 drivers/net/wireless/ath/ath9k/htc.h               |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   18 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h  |    9 +
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c   |   72 ++++-
 drivers/net/wireless/mwifiex/pcie.c                |    2 +-
 drivers/net/xen-netfront.c                         |    4 +-
 drivers/scsi/dc395x.c                              |    2 +-
 drivers/staging/hv/storvsc_drv.c                   |    1 +
 drivers/staging/vt6656/main_usb.c                  |    4 -
 drivers/tty/serial/8250.c                          |   21 ++
 drivers/tty/serial/8250_pci.c                      |   21 +-
 drivers/tty/serial/Kconfig                         |    2 +-
 drivers/tty/serial/of_serial.c                     |    6 +
 drivers/tty/tty_buffer.c                           |   11 +-
 drivers/usb/class/cdc-wdm.c                        |   23 +-
 drivers/usb/core/hub.c                             |  178 ++++++-----
 drivers/usb/serial/cp210x.c                        |   20 ++
 drivers/usb/serial/option.c                        |    5 +
 drivers/usb/serial/qcaux.c                         |    1 +
 drivers/usb/storage/initializers.c                 |   76 +----
 drivers/usb/storage/initializers.h                 |    4 +-
 drivers/usb/storage/unusual_devs.h                 |  329 ++++++++++++++++=
+++-
 drivers/w1/w1.c                                    |    3 +-
 drivers/xen/xen-pciback/pciback_ops.c              |    3 +-
 fs/block_dev.c                                     |    4 +-
 fs/btrfs/volumes.c                                 |    7 +
 fs/cifs/cifsfs.c                                   |    5 +
 fs/compat.c                                        |   15 +-
 fs/ext3/super.c                                    |    4 +-
 fs/fat/namei_vfat.c                                |    3 +-
 fs/nfs/unlink.c                                    |   20 +-
 fs/nls/nls_base.c                                  |   43 ++-
 fs/pipe.c                                          |    3 +
 include/linux/device-mapper.h                      |    4 +-
 include/linux/efi.h                                |    6 +
 include/linux/nls.h                                |    5 +-
 include/linux/serial_core.h                        |    5 +-
 kernel/signal.c                                    |    3 +
 kernel/trace/Kconfig                               |   24 +-
 mm/memory_hotplug.c                                |   15 +-
 mm/process_vm_access.c                             |    8 -
 net/batman-adv/icmp_socket.c                       |    5 +-
 net/decnet/af_decnet.c                             |    4 +
 net/decnet/sysctl_net_decnet.c                     |   28 ++
 net/sunrpc/xprt.c                                  |    6 +-
 security/keys/compat.c                             |    4 +-
 security/keys/process_keys.c                       |    2 +-
 sound/core/seq/seq_timer.c                         |    8 +-
 sound/core/vmaster.c                               |    5 +-
 100 files changed, 1207 insertions(+), 544 deletions(-)

Al Viro (1):
      vfs: fix pipe counter breakage

Alan Stern (1):
      NLS: improve UTF8 -> UTF16 string conversion routine

Alex Deucher (1):
      drm/radeon: add primary dac adj quirk for R200 board

Amit Shah (1):
      virtio: rng: disallow multiple device registrations, fixes crashes

Avinash Patil (1):
      mwifiex: correct sleep delay counter

Axel Lin (1):
      hwmon: (lineage-pem) Add missing terminating entry for pem_[input|fan=
]_attributes

Ben Hutchings (3):
      Revert "powerpc/eeh: Fix crash when adding a device in a slot with DD=
W"
      dmi_scan: fix missing check for _DMI_ signature in smbios_present()
      Linux 3.2.41

Bj=C3=B8rn Mork (2):
      USB: option: add Huawei E5331
      USB: storage: fix Huawei mode switching regression

Christian Schmiedl (1):
      USB: added support for Cinterion's products AH6 and PLS8

Dan Carpenter (1):
      dc395x: uninitialized variable in device_alloc()

Dan Williams (1):
      qcaux: add Franklin U600

David Howells (1):
      keys: fix race with concurrent install_user_keyrings()

Eric Sandeen (1):
      btrfs: use rcu_barrier() to wait for bdev puts at unmount

Eric W. Biederman (1):
      decnet: Fix disappearing sysctl entries

Felix Fietkau (2):
      ath9k: fix RSSI dummy marker value
      ath9k_htc: fix signal strength handling issues

Fernando Luis V=C3=A1zquez Cao (2):
      HID: add support for Sony RF receiver with USB product id 0x0374
      HID: clean up quirk for Sony RF receivers

Guenter Roeck (3):
      hwmon: (pmbus/ltc2978) Fix peak attribute handling
      hwmon: (pmbus/ltc2978) Use detected chip ID to select supported funct=
ionality
      hwmon: (pmbus/ltc2978) Fix temperature reporting

Guo Chao (3):
      block: use i_size_write() in bd_set_size()
      loopdev: fix a deadlock
      loopdev: remove an user triggerable oops

Ilya Zykov (1):
      tty: Correct tty buffer flush.

James Ralston (2):
      ahci: Add Device IDs for Intel Lynx Point-LP PCH
      ahci: Add Device IDs for Intel Wellsburg PCH

Jeff Layton (1):
      cifs: ensure that cifs_get_root() only traverses directories

Jiang Liu (1):
      mm/hotplug: correctly add new zone to all other nodes' zone lists

Johannes Berg (1):
      iwlwifi: always copy first 16 bytes of commands

Josh Boyer (2):
      efivars: Disable external interrupt while holding efivars->lock
      efi: be more paranoid about available space when creating variables

K. Y. Srinivasan (1):
      storvsc: Initialize the sglist

Kees Cook (2):
      proc connector: reject unprivileged listener bumps
      signal: always clear sa_restorer on execve

Konrad Rzeszutek Wilk (2):
      xen/pci: We don't do multiple MSI's.
      xen/pciback: Don't disable a PCI device that is already disabled.

Konstantin Khlebnikov (1):
      e1000e: fix pci-device enable-counter balance

Lars-Peter Clausen (1):
      ext3: Fix format string issues

Laszlo Ersek (1):
      xen-netfront: delay gARP until backend switches to Connected

Ley Foon Tan (1):
      tty/serial: Add support for Altera serial port

Malcolm Priestley (1):
      staging: vt6656: Fix oops on resume from suspend.

Marcin Jurkowski (1):
      w1: fix oops when w1_search is called from netlink connector

Mark Brown (1):
      hwmon: (sht15) Check return value of regulator_enable()

Mathias Krause (1):
      crypto: user - fix info leaks in report API

Mathieu Desnoyers (1):
      Fix: compat_rw_copy_check_uvector() misuse in aio, readv, writev, and=
 security keys

Matwey V. Kornilov (1):
      usb: cp210x new Vendor/Device IDs

Mikulas Patocka (2):
      dm: fix truncated status strings
      dm snapshot: add missing module aliases

NeilBrown (2):
      md: fix two bugs when attempting to resize RAID0 array.
      md: raid0: fix error return from create_stripe_zones.

Oliver Neukum (1):
      USB: cdc-wdm: fix buffer overflow

Paul Bolle (1):
      tty: serial: fix typo "ARCH_S5P6450"

Paul Kot (1):
      batman-adv: bat_socket_read missing checks

Russell King (2):
      ARM: VFP: fix emulation of second VFP instruction
      ARM: fix scheduling while atomic warning in alignment handling code

Rusty Russell (1):
      hw_random: make buffer usable in scatterlist.

Sarah Sharp (4):
      USB: Don't use EHCI port sempahore for USB 3.0 hubs.
      USB: Prepare for refactoring by adding extra udev checks.
      USB: Rip out recursive call on warm port reset.
      USB: Fix connected device switch to Inactive state.

Scott Ashcroft (1):
      Fix 4 port and add support for 8 port 'Unknown' PCI serial port cards

Sebastian Riemer (1):
      md: protect against crash upon fsync on ro array

Seiji Aguchi (1):
      efi_pstore: Check remaining space with QueryVariableInfo() before wri=
ting data

Seth Heasley (2):
      ahci: AHCI-mode SATA patch for Intel Lynx Point DeviceIDs
      ahci: AHCI-mode SATA patch for Intel Avoton DeviceIDs

Shuah Khan (1):
      iommu/amd: Initialize device table after dma_ops

Steve Conklin (1):
      usb: serial: Add Rigblaster Advantage to device table

Steven Rostedt (1):
      ftrace: Update the kconfig for DYNAMIC_FTRACE

Sven Eckelmann (1):
      batman-adv: Only write requested number of byte to user buffer

Takashi Iwai (2):
      ALSA: vmaster: Fix slave change notification
      ALSA: seq: Fix missing error handling in snd_seq_timer_open()

Thomas Gleixner (1):
      btrfs: Init io_lock after cloning btrfs device struct

Trond Myklebust (2):
      NFS: Don't allow NFS silly-renamed files to be deleted, no signal
      SUNRPC: Don't start the retransmission timer when out of socket space

Tu, Xiaobing (1):
      Fix memory leak in cpufreq stats.

Ville Syrj=C3=A4l=C3=A4 (1):
      drm/i915: Don't clobber crtc->fb when queue_flip fails

Wang YanQing (1):
      serial: 8250_pci: add support for another kind of NetMos Technology P=
CI 9835 Multi-I/O Controller

Will Deacon (1):
      ARM: 7663/1: perf: fix ARMv7 EVTYPE_MASK to include NSH bit



--=-5pqp9j1LJuthv9b23G4T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUoU1ue/yOyVhhEJAQr66xAAxk6gcvf1cSwhDOfyti7mOdz5ky5Nr/rY
cLDMXtqn38lffrHyHigsXGFO44qUS+6v+C1l1ISkTni3WYnBgJIg1sEZ2F3gVwis
CYrBm8oWKS64+qo8XhZs3A9FoSGTgY1UJ8iiKcXIG87nNH3cjRp05Fz3mR93RHRY
onUn3viifNjPdDeP47F04yRMkWzdJQiQo/HmpCmW/Q4JVZG7cFkCcpCveqTTOzEq
iRvaG77+n/tqlU7qx0Sj5TyfEsun7T8DQ8UzqeeZrqe462zXx6sTFcCp898UYVx1
3ob5UgucWzkLlIEmiRlpSAz9gLCWFBLRZZ6JYg1ue+F1q9AFvzLDdNEVx4WXSa+K
hp//ahAlPHMKB8+WgkyKK3QzlpjwYChHYt2ST70F6C88jZtd5WsdTQe7VOPa+Sai
ywKYuxgGx2z/1fQwi2O1A0hw3SktVotUEP5LZ0gho8a1RGeQE4Frl/HXSP2h7X6w
0frxb0QbIHTzkZADn0H0DVvN8F4tOrFkxQzkJexD/LpT7zh/A8rJoTsZy/P/+ZXm
73AIysCXaZ4VgRZXaHyIylKhIFetn01W8hRBArwk5grJ6f4B4NpUD8uSNMdqcMxk
xPCcIIi8iVW8yf0lk55SmXJt2bdtgOzYDnJihG0f0WnKJzy+tIT1oHBDkMSxE+Fo
ZaniEnBw8tc=
=lrRu
-----END PGP SIGNATURE-----

--=-5pqp9j1LJuthv9b23G4T--
