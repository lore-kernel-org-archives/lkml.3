Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbaBVWAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 17:00:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaBVWAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 17:00:50 -0500
Date: Sat, 22 Feb 2014 14:03:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.12.13
Message-ID: <20140222220334.GA17704@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.12.13 kernel.

All users of the 3.12 kernel series must upgrade.

The updated 3.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.12.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                      |    2=20
 arch/s390/kernel/head64.S                     |    7 +-
 arch/s390/mm/page-states.c                    |   10 ++
 arch/x86/include/asm/pgtable.h                |   14 +++-
 arch/x86/kernel/cpu/common.c                  |    7 +-
 arch/x86/kernel/ftrace.c                      |   83 +++++++++++++--------=
--
 arch/x86/mm/fault.c                           |   14 ++--
 arch/x86/xen/mmu.c                            |    4 -
 block/blk-lib.c                               |    8 ++
 block/blk.h                                   |    2=20
 drivers/block/xen-blkfront.c                  |    5 +
 drivers/char/raw.c                            |    2=20
 drivers/edac/edac_mc.c                        |   13 ++-
 drivers/edac/edac_mc_sysfs.c                  |   10 +-
 drivers/edac/edac_module.h                    |    2=20
 drivers/gpu/drm/i915/i915_gpu_error.c         |    5 +
 drivers/gpu/drm/radeon/r600.c                 |    4 +
 drivers/gpu/drm/radeon/si.c                   |    4 +
 drivers/hv/connection.c                       |   11 ---
 drivers/hwmon/ntc_thermistor.c                |    6 -
 drivers/i2c/busses/i2c-mv64xxx.c              |   33 ++++-----
 drivers/iio/adc/max1363.c                     |    2=20
 drivers/iio/imu/adis16400.h                   |    1=20
 drivers/iio/imu/adis16400_core.c              |   10 +-
 drivers/iio/magnetometer/ak8975.c             |   16 ++--
 drivers/infiniband/hw/qib/qib_iba7322.c       |    5 +
 drivers/md/raid1.c                            |   13 ++-
 drivers/md/raid5.c                            |   90 ++++++++++++---------=
-----
 drivers/misc/mei/client.c                     |   11 ++-
 drivers/net/wireless/ath/ar5523/ar5523.c      |    2=20
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    8 ++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   25 +++----
 drivers/net/wireless/ath/ath9k/init.c         |    8 ++
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c  |    5 +
 drivers/net/wireless/iwlwifi/mvm/scan.c       |    3=20
 drivers/net/wireless/iwlwifi/mvm/utils.c      |    2=20
 drivers/of/address.c                          |    5 -
 drivers/pci/hotplug/acpiphp_glue.c            |   15 +++-
 drivers/power/max17040_battery.c              |    5 -
 drivers/spi/spi-nuc900.c                      |    2=20
 drivers/spi/spi.c                             |    4 -
 drivers/staging/comedi/drivers/adv_pci1710.c  |   17 +++-
 drivers/staging/iio/adc/ad799x_core.c         |    3=20
 drivers/staging/lustre/lustre/llite/dir.c     |    2=20
 drivers/staging/rtl8188eu/os_dep/usb_intf.c   |    2=20
 drivers/target/target_core_pr.c               |   11 ++-
 drivers/tty/n_gsm.c                           |   11 +++
 drivers/tty/serial/sirfsoc_uart.c             |    4 -
 drivers/tty/vt/vt.c                           |    2=20
 drivers/usb/core/hcd.c                        |    1=20
 drivers/usb/core/hub.c                        |    7 --
 drivers/usb/core/usb.h                        |    1=20
 drivers/usb/host/xhci-ring.c                  |   54 ---------------
 drivers/usb/host/xhci.c                       |   18 +++--
 drivers/usb/host/xhci.h                       |    2=20
 drivers/usb/serial/ftdi_sio.c                 |    3=20
 drivers/usb/serial/ftdi_sio_ids.h             |    7 ++
 drivers/usb/serial/option.c                   |    3=20
 drivers/usb/serial/qcserial.c                 |    3=20
 drivers/usb/serial/usb-serial-simple.c        |    3=20
 drivers/usb/storage/Kconfig                   |    4 -
 drivers/usb/storage/scsiglue.c                |    6 +
 drivers/usb/storage/unusual_cypress.h         |    2=20
 drivers/usb/storage/unusual_devs.h            |    7 ++
 drivers/vme/bridges/vme_ca91cx42.c            |    4 -
 drivers/vme/bridges/vme_tsi148.c              |    4 -
 fs/bio-integrity.c                            |   10 ++
 fs/cifs/cifsacl.c                             |   28 ++++++--
 fs/cifs/cifsglob.h                            |   10 ++
 fs/cifs/inode.c                               |   13 ++-
 fs/cifs/smb1ops.c                             |    8 ++
 fs/cifs/xattr.c                               |   64 +++++++++++-------
 fs/file.c                                     |    2=20
 fs/lockd/svclock.c                            |    8 ++
 fs/nfs/dir.c                                  |    5 +
 include/linux/compiler-gcc4.h                 |    6 -
 include/linux/usb.h                           |    2=20
 kernel/irq/irqdesc.c                          |    1=20
 kernel/time/jiffies.c                         |    6 +
 kernel/time/tick-broadcast.c                  |    1=20
 kernel/trace/ring_buffer.c                    |    7 ++
 mm/memory-failure.c                           |    6 +
 net/mac80211/cfg.c                            |   41 ++++++-----
 net/mac80211/tx.c                             |    2=20
 net/wireless/nl80211.c                        |    3=20
 scripts/mod/file2alias.c                      |    4 -
 sound/pci/hda/patch_realtek.c                 |    1=20
 virt/kvm/coalesced_mmio.c                     |    8 --
 88 files changed, 553 insertions(+), 342 deletions(-)

Alan Stern (3):
      usb-storage: add unusual-devs entry for BlackBerry 9000
      usb-storage: restrict bcdDevice range for Super Top in Cypress ATACB
      usb-storage: enable multi-LUN scanning when needed

Alex Deucher (1):
      drm/radeon: fix UVD IRQ support on 7xx

Alexander Usyskin (2):
      mei: clear write cb from waiting list on reset
      mei: don't unset read cb ptr on reset

Axel Lin (1):
      spi: nuc900: Set SPI_LSB_FIRST for master->mode_bits if hw->pdata->ls=
b is true

Beomho Seo (1):
      iio: ak8975: Fix calculation formula for convert micro tesla to gauss=
 unit

Bj=C3=B8rn Mork (2):
      usb: qcserial: add Netgear Aircard 340U
      usb: ftdi_sio: add Mindstorms EV3 console adapter

Borislav Petkov (2):
      EDAC: Poll timeout cannot be zero, p2
      EDAC: Correct workqueue setup path

Christian K=C3=B6nig (1):
      drm/radeon: fix UVD IRQ support on SI

C=C3=A9dric Dufour (1):
      staging: lustre: fix quotactl permission denied (LU-4530)

Dan Carpenter (1):
      KVM: return an error code in kvm_vm_ioctl_register_coalesced_mmio()

David Vrabel (1):
      xen-blkfront: handle backend CLOSED without CLOSING

Doug Anderson (1):
      hwmon: (ntc_thermistor) Avoid math overflow

Eliad Peller (1):
      mac80211: move roc cookie assignment earlier

Emmanuel Grumbach (4):
      mac80211: release the channel in error path in start_ap
      iwlwifi: mvm: don't allow A band if SKU forbids it
      iwlwifi: mvm: print the version of the firmware when it asserts
      iwlwifi: mvm: BT Coex - disable BT when TXing probe request in scan

Eric W. Biederman (1):
      fs/file.c:fdtable: avoid triggering OOMs from alloc_fdmem

Geert Uytterhoeven (1):
      spi: Fix crash with double message finalisation on error handling

Greg Kroah-Hartman (1):
      Linux 3.12.13

Guenter Roeck (1):
      iio: max1363: Use devm_regulator_get_optional for optional regulator

H Hartley Sweeten (1):
      staging: comedi: adv_pci1710: fix analog output readback value

H. Peter Anvin (2):
      x86, smap: Don't enable SMAP if CONFIG_X86_SMAP is disabled
      x86, smap: smap_violation() is bogus if CONFIG_X86_SMAP is off

Hartmut Knaack (1):
      staging:iio:ad799x fix error_free_irq which was freeing an irq that m=
ay not have been requested

Jan Moskyto Matejka (1):
      Modpost: fixed USB alias generation for ranges including 0x9 and 0xA

Jens Axboe (1):
      block: add cond_resched() to potentially long running ioctl discard l=
oop

Johannes Berg (1):
      mac80211: fix fragmentation code, particularly for encryption

K. Y. Srinivasan (1):
      Drivers: hv: vmbus: Don't timeout during the initial connection with =
host

Kleber Sacilotto de Souza (1):
      of: fix PCI bus match for PCIe slots

Krist=C3=B3f Ralovich (1):
      USB: simple: add Dynastream ANT USB-m Stick device support

Krzysztof Kozlowski (1):
      power: max17040: Fix NULL pointer dereference when there is no platfo=
rm_data

Larry Finger (1):
      staging: r8188eu: Fix typo in USB_DEVICE list

Lars Poeschel (1):
      tty: n_gsm: Fix for modems with brk in modem status control

Marcus Folkesson (1):
      iio: adis16400: Set timestamp as the last element in chan_spec

Martin K. Petersen (1):
      block: Fix nr_vecs for inline integrity vectors

Martin Schwidefsky (1):
      s390: fix kernel crash due to linkage stack instructions

Martyn Welch (1):
      VME: Correct read/write alignment algorithm

Mel Gorman (1):
      xen: properly account for _PAGE_NUMA during xen pte translations

Michael Holzheu (1):
      s390/dump: Fix dump memory detection

Mika Kuoppala (1):
      drm/i915: Pair va_copy with va_end in i915_error_vprintf

Mika Westerberg (1):
      ACPI / hotplug / PCI: Relax the checking of _STA return values

Mike Marciniszyn (1):
      IB/qib: Add missing serdes init sequence

Mikulas Patocka (1):
      time: Fix overflow when HZ is smaller than 60

Naoya Horiguchi (1):
      mm/memory-failure.c: move refcount only in !MF_COUNT_INCREASED

NeilBrown (2):
      lockd: send correct lock when granting a delayed lock.
      md/raid1: restore ability for check and repair to fix read errors.

Nicholas Bellinger (1):
      target: Fix free-after-use regression in PR unregister

Oleg Nesterov (1):
      md/raid5: Fix CPU hotplug callback registration

Oleksij Rempel (2):
      ath9k_htc: Do not support PowerSave by default
      ar5523: fix usb id for Gigaset.

Paul Bolle (1):
      raw: test against runtime value of max_raw_minors

Paul Gortmaker (1):
      genirq: Add missing irq_to_desc export for CONFIG_SPARSE_IRQ=3Dn

Petr P=C3=ADsa=C5=99 (1):
      vt: Fix secure clear screen

Pontus Fuchs (1):
      nl80211: Reset split_start when netlink skb is exhausted

Prarit Bhargava (1):
      drivers/edac/edac_mc_sysfs.c: poll timeout cannot be zero

Qipan Li (1):
      serial: sirf: fix kernel panic caused by unpaired spinlock

Rafael Aquini (1):
      mm: fix page leak at nfs_symlink()

Raymond Wanyoike (1):
      usb: option: blacklist ZTE MF667 net interface

Sarah Sharp (5):
      xhci 1.0: Limit arbitrarily-aligned scatter gather.
      Revert "xhci: Set scatter-gather limit to avoid failed block writes."
      Revert "xhci: Avoid infinite loop when sg urb requires too many trbs"
      Revert "usb: xhci: Link TRB must not occur within a USB payload burst"
      Revert "usbcore: set lpm_capable field for LPM capable root hubs"

Stanislaw Gruszka (1):
      ath9k_htc: make ->sta_rc_update atomic for most calls

Steve French (3):
      CIFS: Fix SMB2 mounts so they don't try to set or get xattrs via cifs
      Add protocol specific operation for CIFS xattrs
      retrieving CIFS ACLs when mounted with SMB2 fails dropping session

Steven Noonan (1):
      compiler/gcc4: Make quirk for asm_volatile_goto() unconditional

Steven Rostedt (Red Hat) (2):
      ftrace/x86: Use breakpoints for converting function graph caller
      ring-buffer: Fix first commit on sub-buffer having non-zero delta

Sujith Manoharan (1):
      ath9k: Do not support PowerSave by default

Takashi Iwai (1):
      ALSA: hda - Fix mic capture on Sony VAIO Pro 11

Tejun Heo (1):
      block: __elv_next_request() shouldn't call into the elevator if bypas=
sing

Thomas Gleixner (1):
      tick: Clear broadcast pending bit when switching to oneshot

Ulrich Hahn (1):
      USB: ftdi_sio: add Tagsys RFID Reader IDs

Wolfram Sang (1):
      i2c: mv64xxx: refactor message start to ensure proper initialization


--y0ulUmNC+osPPQO6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCR61AAoJEDjbvchgkmk+SZMP/11oRa/beeORzpO0SzgFWWIt
s1v2/iBNBYkokRxgYA5cChdkUubd9DS/UjtCk4aUCYiA3OLkeritsv0C3z9LTWtY
qgKZkHtvNlBDzMpFz4T8TgEnIrO40ybKK4PBuX50oqL8tY0ECU475FJg5n1DK/FQ
PNPBxPICkwZSniJL5LaZI9tJnbPn4H9/7Iu+0j3wJMbyiSa4ohcjVsWrwOK5zmA1
/PzRyZRaDLfISNdq9Jij00o6l8mHAAIfWFlsAgg10FSaNJgBF9WHh4V9yI2Nuzsy
KQo3FqvSXM/e+fK2EpfS9pzy6R/EFNvFrQgkS1k1YCYev7LMaqr1GtH80CvUocx7
hqy39yoEzy/4uZfifkF2Hg9bdcYZpr0HzW3v4bcr9J1KiwErMEULNJrdkTk0SG9i
dxLxWdSciFfyc4khFKVOkqzwzyWoN5bVirjnP1aX8gvy4NzFrgQBxr5Dojp5iw8o
5ZYl8ea+rPh4s77Lt/l+jeFCq914yGBEyArJ8QY4mJBT/uqmXRB0+tW9/dCUS+8t
BNcU9a8Yq5Dblr6EisJAyHHGuRZmTHpN3Z5iy5nHD6g3ZKoZlPyVr2y/c1k7L08O
CNbR98LHEebYVNHl9hSFdQbD7OUyAJqtNVy+yIjxPMKE1Psa98nmPLOEhwsCHF8P
xUMBuaZ/ZhRQz1S/MEsb
=LOsf
-----END PGP SIGNATURE-----

--y0ulUmNC+osPPQO6--
