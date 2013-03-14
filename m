Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab3CNSrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 14:47:08 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:33409 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3CNSrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 14:47:07 -0400
Date: Thu, 14 Mar 2013 11:47:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.8.3
Message-ID: <20130314184702.GA17860@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.8.3 kernel.

All users of the 3.8 kernel series must upgrade.

The updated 3.8.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.8.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                      |    2=20
 arch/arm/boot/dts/kirkwood-dns320.dts         |    2=20
 arch/arm/boot/dts/kirkwood-dns325.dts         |    1=20
 arch/arm/boot/dts/kirkwood-dockstar.dts       |    1=20
 arch/arm/boot/dts/kirkwood-dreamplug.dts      |    1=20
 arch/arm/boot/dts/kirkwood-goflexnet.dts      |    1=20
 arch/arm/boot/dts/kirkwood-ib62x0.dts         |    1=20
 arch/arm/boot/dts/kirkwood-iconnect.dts       |    1=20
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts |    1=20
 arch/arm/boot/dts/kirkwood-km_kirkwood.dts    |    1=20
 arch/arm/boot/dts/kirkwood-lschlv2.dts        |    1=20
 arch/arm/boot/dts/kirkwood-lsxhl.dts          |    1=20
 arch/arm/boot/dts/kirkwood-mplcec4.dts        |    1=20
 arch/arm/boot/dts/kirkwood-ns2-common.dtsi    |    1=20
 arch/arm/boot/dts/kirkwood-nsa310.dts         |    1=20
 arch/arm/boot/dts/kirkwood-openblocks_a6.dts  |    2=20
 arch/arm/boot/dts/kirkwood-topkick.dts        |    1=20
 arch/arm/boot/dts/kirkwood.dtsi               |    5=20
 arch/arm/configs/mxs_defconfig                |    1=20
 arch/arm/include/asm/delay.h                  |    1=20
 arch/arm/include/asm/mmu.h                    |    8=20
 arch/arm/include/asm/mmu_context.h            |    2=20
 arch/arm/include/asm/pgtable.h                |    3=20
 arch/arm/kernel/asm-offsets.c                 |    2=20
 arch/arm/kernel/head.S                        |   26 ++-
 arch/arm/kernel/perf_event_v7.c               |    2=20
 arch/arm/kernel/smp.c                         |    3=20
 arch/arm/lib/delay.c                          |    1=20
 arch/arm/mm/alignment.c                       |   11 -
 arch/arm/mm/context.c                         |   25 +--
 arch/arm/vfp/vfpmodule.c                      |    2=20
 arch/powerpc/kernel/setup_64.c                |   16 +
 arch/tile/include/asm/compat.h                |    3=20
 arch/tile/kernel/compat.c                     |   13 +
 arch/x86/kernel/kvmclock.c                    |   11 -
 arch/x86/kernel/pvclock.c                     |    2=20
 arch/x86/pci/xen.c                            |    9 +
 arch/x86/xen/enlighten.c                      |   10 +
 crypto/ablkcipher.c                           |   12 -
 crypto/aead.c                                 |    9 -
 crypto/ahash.c                                |    2=20
 crypto/blkcipher.c                            |    6=20
 crypto/crypto_user.c                          |   22 +-
 crypto/pcompress.c                            |    3=20
 crypto/rng.c                                  |    2=20
 crypto/shash.c                                |    3=20
 drivers/block/xen-blkback/blkback.c           |    1=20
 drivers/char/hw_random/core.c                 |   19 +-
 drivers/char/random.c                         |   12 -
 drivers/connector/cn_proc.c                   |    8=20
 drivers/firmware/dmi_scan.c                   |    5=20
 drivers/firmware/efivars.c                    |  210 ++++++++++++++++-----=
-----
 drivers/gpio/gpio-mvebu.c                     |    7=20
 drivers/gpu/drm/i915/i915_dma.c               |   23 +-
 drivers/gpu/drm/i915/i915_drv.c               |   25 ++-
 drivers/gpu/drm/i915/i915_drv.h               |    1=20
 drivers/gpu/drm/i915/i915_irq.c               |    4=20
 drivers/gpu/drm/i915/intel_crt.c              |    2=20
 drivers/gpu/drm/i915/intel_pm.c               |    2=20
 drivers/gpu/drm/radeon/radeon_combios.c       |    9 +
 drivers/gpu/drm/radeon/radeon_irq_kms.c       |   12 +
 drivers/hid/hid-logitech-dj.c                 |   22 +-
 drivers/hwmon/pmbus/ltc2978.c                 |   30 +--
 drivers/hwmon/sht15.c                         |    8=20
 drivers/md/dm-crypt.c                         |   39 +---
 drivers/md/dm-delay.c                         |    8=20
 drivers/md/dm-flakey.c                        |    7=20
 drivers/md/dm-ioctl.c                         |   14 +
 drivers/md/dm-linear.c                        |    7=20
 drivers/md/dm-mpath.c                         |    8=20
 drivers/md/dm-raid.c                          |    8=20
 drivers/md/dm-raid1.c                         |    8=20
 drivers/md/dm-snap.c                          |   18 --
 drivers/md/dm-stripe.c                        |    7=20
 drivers/md/dm-thin.c                          |   80 ++++++---
 drivers/md/dm-verity.c                        |    8=20
 drivers/md/dm.c                               |   42 +++--
 drivers/md/md.c                               |    7=20
 drivers/md/raid0.c                            |    5=20
 drivers/md/raid1.c                            |    1=20
 drivers/md/raid10.c                           |    1=20
 drivers/memstick/host/rtsx_pci_ms.c           |    7=20
 drivers/mfd/rtsx_pcr.c                        |   61 ++++++-
 drivers/mmc/host/rtsx_pci_sdmmc.c             |   18 ++
 drivers/net/ethernet/broadcom/tg3.c           |   14 -
 drivers/net/ethernet/intel/e1000e/netdev.c    |    2=20
 drivers/net/usb/smsc95xx.c                    |    6=20
 drivers/net/wireless/ath/ath9k/common.h       |    2=20
 drivers/net/wireless/ath/ath9k/htc.h          |    1=20
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   18 +-
 drivers/net/wireless/ath/ath9k/hw.c           |    4=20
 drivers/net/wireless/iwlwifi/iwl-devtrace.h   |   10 -
 drivers/net/wireless/iwlwifi/pcie/internal.h  |    9 +
 drivers/net/wireless/iwlwifi/pcie/tx.c        |   75 +++++++--
 drivers/net/wireless/libertas/if_sdio.c       |    6=20
 drivers/net/wireless/mwifiex/pcie.c           |    2=20
 drivers/platform/x86/acer-wmi.c               |    3=20
 drivers/platform/x86/sony-laptop.c            |    2=20
 drivers/rtc/rtc-mv.c                          |   28 ++-
 drivers/scsi/dc395x.c                         |    2=20
 drivers/scsi/storvsc_drv.c                    |    1=20
 drivers/target/iscsi/iscsi_target.c           |   11 +
 drivers/target/target_core_pscsi.c            |    1=20
 drivers/usb/core/hub.c                        |  178 +++++++++++-----------
 drivers/usb/host/ehci-timer.c                 |   29 +--
 drivers/w1/masters/w1-gpio.c                  |    2=20
 drivers/watchdog/Kconfig                      |    1=20
 drivers/watchdog/sp5100_tco.c                 |   27 ---
 drivers/xen/xenbus/xenbus_client.c            |    1=20
 fs/btrfs/inode.c                              |    4=20
 fs/btrfs/tree-log.c                           |   18 ++
 fs/btrfs/volumes.c                            |    1=20
 fs/cifs/cifsfs.c                              |    5=20
 fs/cifs/smb2ops.c                             |    1=20
 fs/compat.c                                   |   15 -
 fs/ext4/balloc.c                              |    2=20
 fs/ext4/mballoc.c                             |    8=20
 fs/ext4/resize.c                              |    6=20
 fs/ext4/super.c                               |    2=20
 fs/namei.c                                    |    2=20
 fs/nfs/nfs4filelayout.c                       |    6=20
 fs/nfs/nfs4proc.c                             |   11 +
 fs/nfs/pnfs.c                                 |   14 +
 fs/nfs/pnfs.h                                 |    6=20
 fs/nfs/unlink.c                               |   20 +-
 fs/pipe.c                                     |    3=20
 fs/proc/namespaces.c                          |   12 -
 include/linux/device-mapper.h                 |    4=20
 include/linux/mfd/rtsx_pci.h                  |    2=20
 ipc/msg.c                                     |    6=20
 ipc/msgutil.c                                 |    3=20
 kernel/fork.c                                 |    5=20
 kernel/time/tick-sched.c                      |    7=20
 kernel/trace/Kconfig                          |   24 +-
 kernel/user_namespace.c                       |    4=20
 mm/mempolicy.c                                |    2=20
 mm/process_vm_access.c                        |    8=20
 net/ieee802154/6lowpan.c                      |    2=20
 net/mac80211/mlme.c                           |   11 +
 net/sunrpc/xprt.c                             |    6=20
 security/keys/compat.c                        |    4=20
 security/keys/process_keys.c                  |    4=20
 sound/core/vmaster.c                          |    5=20
 sound/pci/ice1712/ice1712.c                   |    2=20
 144 files changed, 1052 insertions(+), 607 deletions(-)

Al Viro (1):
      vfs: fix pipe counter breakage

Alan Stern (1):
      USB: EHCI: revert "remove ASS/PSS polling timeout"

Alex Deucher (2):
      drm/radeon: don't set hpd, afmt interrupts when interrupts are disabl=
ed
      drm/radeon: add primary dac adj quirk for R200 board

Andrew Lunn (2):
      rtc: rtc-mv: Add support for clk to avoid lockups
      gpio: mvebu: Add clk support to prevent lockup

Asias He (1):
      target/pscsi: Fix page increment

Avinash Patil (1):
      mwifiex: correct sleep delay counter

Ben Greear (1):
      mac80211: Fix crash due to un-canceled work-items

Ben Hutchings (1):
      dmi_scan: fix missing check for _DMI_ signature in smbios_present()

Benjamin Tissoires (1):
      HID: logitech-dj: do not directly call hid_output_raw_report() during=
 probe

Benny Halevy (1):
      pnfs: fix resend_to_mds for directio

Bing Zhao (1):
      libertas: fix crash for SD8688

Catalin Marinas (1):
      ARM: 7654/1: Preserve L_PTE_VALID in pte_modify()

Chris Metcalf (1):
      tile: work around bug in the generic sys_llseek

Dan Carpenter (1):
      SCSI: dc395x: uninitialized variable in device_alloc()

Daniel Vetter (2):
      drm/i915: reorder setup sequence to have irqs for output setup
      drm/i915: enable irqs earlier when resuming

David Howells (1):
      keys: fix race with concurrent install_user_keyrings()

David S. Miller (1):
      6lowpan: Remove __init tag from lowpan_netlink_fini().

Eric W. Biederman (3):
      proc: Use nd_jump_link in proc_ns_follow_link
      userns: Stop oopsing in key_change_session_keyring
      userns: Don't allow CLONE_NEWUSER | CLONE_FS

Fabio Estevam (1):
      ARM: mxs_defconfig: Make USB host functional again

Felix Fietkau (3):
      ath9k: fix RSSI dummy marker value
      ath9k_htc: fix signal strength handling issues
      ath9k_hw: improve reset reliability after errors

Frederic Weisbecker (1):
      nohz: Make tick_nohz_irq_exit() irq safe

Greg Kroah-Hartman (2):
      Revert "xen/blkback: Don't trust the handle from the frontend."
      Linux 3.8.3

Guenter Roeck (2):
      hwmon: (pmbus/ltc2978) Fix peak attribute handling
      hwmon: (pmbus/ltc2978) Use detected chip ID to select supported funct=
ionality

Hauke Mehrtens (1):
      w1-gpio: fix section mismatch

Hillf Danton (1):
      mm/mempolicy.c: fix wrong sp_node insertion

Jason Cooper (1):
      ARM: kirkwood: of_serial: fix clock gating by removing clock-frequency

Jeff Layton (1):
      cifs: ensure that cifs_get_root() only traverses directories

Johannes Berg (1):
      iwlwifi: always copy first 16 bytes of commands

Josef Bacik (4):
      Btrfs: copy everything if we've created an inline extent
      Btrfs: delete inline extents when we find them during logging
      Btrfs: account for orphan inodes properly during cleanup
      Btrfs: cleanup orphan reservation if truncate fails

Jun'ichi Nomura (1):
      dm: do not replace bioset for request based dm

K. Y. Srinivasan (1):
      SCSI: storvsc: Initialize the sglist

Kees Cook (1):
      proc connector: reject unprivileged listener bumps

Kenneth Graunke (1):
      drm/i915: Fix Haswell/CRW PCI IDs.

Konrad Rzeszutek Wilk (2):
      xen/pat: Disable PAT using pat_enabled value.
      xen/pci: We don't do multiple MSI's.

Konstantin Khlebnikov (1):
      e1000e: fix pci-device enable-counter balance

Lee, Chun-Yi (1):
      acer-wmi: avoid the warning of 'devices' may be used uninitialized

Linus Torvalds (1):
      vfs: don't BUG_ON() if following a /proc fd pseudo-symlink results in=
 a symlink

Lukas Czerner (1):
      ext4: convert number of blocks to clusters properly

Marcelo Tosatti (1):
      x86: pvclock kvm: align allocation size to page size

Mark Brown (1):
      hwmon: (sht15) Check return value of regulator_enable()

Mathias Krause (1):
      crypto: user - fix info leaks in report API

Mathieu Desnoyers (1):
      Fix: compat_rw_copy_check_uvector() misuse in aio, readv, writev, and=
 security keys

Matt Fleming (2):
      efivars: efivarfs_valid_name() should handle pstore syntax
      efivarfs: return accurate error code in efivarfs_fill_super()

Matthew Garrett (1):
      efi: be more paranoid about available space when creating variables

Mattia Dongili (1):
      sony-laptop: fully enable SNY controlled modems

Michael Ellerman (1):
      powerpc: Apply early paca fixups to boot_paca and the boot cpu's paca

Mike Christie (1):
      dm: fix limits initialization when there are no data devices

Mikulas Patocka (2):
      dm: fix truncated status strings
      dm snapshot: add missing module aliases

Ming Lei (1):
      usbnet: smsc95xx: fix suspend failure

NeilBrown (3):
      md: fix two bugs when attempting to resize RAID0 array.
      md: raid0: fix error return from create_stripe_zones.
      md/raid1,raid10: fix deadlock with freeze_array()

Nicholas Bellinger (1):
      iscsi-target: Fix immediate queue starvation regression with DATAIN

Nicolas Pitre (1):
      ARM: 7653/2: do not scale loops_per_jiffy when using a constant delay=
 clock

Nithin Sujir (1):
      tg3: Update link_up flag for phylib devices

Patrik Jakobsson (1):
      drm/i915: Turn off hsync and vsync on ADPA when disabling crt

Pavel Shilovsky (1):
      CIFS: Fix missing of oplock_read value in smb30_values structure

Peter Hurley (3):
      ipc: fix potential oops when src msg > 4k w/ MSG_COPY
      ipc: don't allocate a copy larger than max
      x86/kvm: Fix pvclock vsyscall fixmap

Randy Dunlap (1):
      watchdog: da9055_wdt needs to select WATCHDOG_CORE

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

Sean Connor (1):
      ALSA: ice1712: Initialize card->private_data properly

Sebastian Riemer (1):
      md: protect against crash upon fsync on ro array

Seiji Aguchi (1):
      efivars: Disable external interrupt while holding efivars->lock

Steven Noonan (1):
      xenbus: fix compile failure on ARM with Xen enabled

Steven Rostedt (1):
      ftrace: Update the kconfig for DYNAMIC_FTRACE

St=E9phane Marchesin (1):
      drm/i915: Increase the RC6p threshold.

Takahisa Tanaka (2):
      watchdog: sp5100_tco: Fix wrong indirect I/O access for getting value=
 of reserved bits
      watchdog: sp5100_tco: Write back the original value to reserved bits,=
 instead of zero

Takashi Iwai (1):
      ALSA: vmaster: Fix slave change notification

Theodore Ts'o (1):
      random: fix locking dependency with the tasklist_lock

Thomas Gleixner (1):
      btrfs: Init io_lock after cloning btrfs device struct

Trond Myklebust (2):
      NFS: Don't allow NFS silly-renamed files to be deleted, no signal
      SUNRPC: Don't start the retransmission timer when out of socket space

Wei WANG (2):
      mfd: rtsx: Optimize card detect flow
      mfd: rtsx: Fix issue that booting OS with SD card inserted

Weston Andros Adamson (1):
      NFSv4.1: Hold reference to layout hdr in layoutget

Will Deacon (4):
      ARM: 7657/1: head: fix swapper and idmap population with LPAE and big=
-endian
      ARM: 7658/1: mm: fix race updating mm->context.id on ASID rollover
      ARM: 7659/1: mm: make mm->context.id an atomic64_t variable
      ARM: 7663/1: perf: fix ARMv7 EVTYPE_MASK to include NSH bit


--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRQhsmAAoJEDjbvchgkmk+P8cP/2ujssNQw20v1wkTVbB4+LDX
It35RFNIHQnCW53AHaE2RUVMDxda+alUaj6pyGbxvdGPRyMdeKIJk8QQysyLCC9t
ii2r5BYLKQXNLVhBGsSViSNq5eHEYXcRabDFUMD48dW8MT1UNushnJ3/urc4Bu5w
Z49qBpGH3bbaiJyyxRC8Ja+q/TUg+jptoEr7jWMb1egMCFKo4kQJcr/vLQpTd9vb
R4yb8MsSRnqsR3BWIw6vikzztUnZmhUeNSUnOQSqN4t7Z5RidkP0v4M7dkmXhhNm
+T5Qmzm1pXlc37aY4Sw4RhAhYI7FciB/rsn7bNKuQ+DYXqwsmiU4e86k9un7Czzf
KQLi175BCwOwReyn3L58p3eqPqlY4ZZYecCdGzefGECSO11FlMejW9CUI1SV/uz2
nvA3AX9zdUxqm6W968keDn0NoLg8Y3suBIolszXcUbYrFp0aIWeYJeiuzJE1a7a8
w3phB4b1fya5nMxEraqfuziXxkEZOC+TFupq6gxJnCwZ3B2nUr+78gQqcDNnjNjl
eHxsulVp6Zxs8VeCJICX3zLpx6d5/L/Dj8c1y7xuzEeO8vWLdBnN89uubKKLtFoU
mvtSWfHy6SFR2DaEAbeZ21lbk/n4XnpngQx/u4G7U2jrGAFuK2smLyirXxBWrTO5
3/jQ7ZMSDDFVtqaZHW2U
=mT9E
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
