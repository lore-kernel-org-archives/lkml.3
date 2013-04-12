Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab3DLRdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 13:33:06 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:56172 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab3DLRdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 13:33:02 -0400
Date: Fri, 12 Apr 2013 10:32:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.8.7
Message-ID: <20130412173234.GA28236@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.8.7 kernel.

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
 arch/alpha/kernel/sys_nautilus.c              |    5 +
 arch/arm/mach-exynos/common.c                 |    6 -
 arch/mips/kernel/mcount.S                     |   11 +-
 arch/mips/lib/bitops.c                        |   16 +--
 arch/powerpc/platforms/pseries/lpar.c         |    8 +
 arch/x86/boot/compressed/Makefile             |    5 -
 arch/x86/include/asm/syscall.h                |    4=20
 block/blk-sysfs.c                             |    2=20
 crypto/gcm.c                                  |   17 +++
 drivers/acpi/pci_root.c                       |  121 ++++++++++++---------=
-----
 drivers/ata/ata_piix.c                        |   14 ++-
 drivers/ata/libata-core.c                     |    6 +
 drivers/base/regmap/regcache-rbtree.c         |    2=20
 drivers/base/regmap/regmap.c                  |    4=20
 drivers/cpufreq/exynos-cpufreq.c              |    4=20
 drivers/crypto/ux500/cryp/cryp_core.c         |    2=20
 drivers/eisa/pci_eisa.c                       |   67 +++++++++-----
 drivers/gpio/gpio-stmpe.c                     |   15 ++-
 drivers/gpu/drm/drm_fops.c                    |    6 -
 drivers/gpu/drm/i915/i915_gem_execbuffer.c    |    2=20
 drivers/gpu/drm/i915/intel_crt.c              |   40 +++-----
 drivers/gpu/drm/i915/intel_display.c          |    9 +
 drivers/gpu/drm/mgag200/mgag200_mode.c        |   13 --
 drivers/gpu/drm/nouveau/nouveau_abi16.c       |   18 ++-
 drivers/hid/hid-magicmouse.c                  |   29 ++++--
 drivers/hwspinlock/hwspinlock_core.c          |    2=20
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |   11 +-
 drivers/net/ethernet/realtek/r8169.c          |   28 +++++-
 drivers/net/wireless/mwifiex/cfg80211.c       |    3=20
 drivers/net/wireless/mwifiex/scan.c           |   11 +-
 drivers/net/wireless/rt2x00/rt2x00pci.c       |    4=20
 drivers/pci/pci-acpi.c                        |   15 +--
 drivers/pci/pcie/portdrv_pci.c                |   13 --
 drivers/platform/x86/msi-wmi.c                |    4=20
 drivers/remoteproc/Kconfig                    |    2=20
 drivers/remoteproc/remoteproc_core.c          |    4=20
 drivers/remoteproc/ste_modem_rproc.c          |    7 +
 drivers/rtc/rtc-at91rm9200.c                  |   50 ++++------
 drivers/rtc/rtc-at91rm9200.h                  |    1=20
 drivers/spi/spi-mpc512x-psc.c                 |    2=20
 drivers/spi/spi-s3c64xx.c                     |   41 +++++---
 drivers/thermal/thermal_sys.c                 |    1=20
 drivers/tty/serial/8250/8250_pnp.c            |   12 +-
 drivers/vfio/pci/vfio_pci.c                   |    3=20
 fs/nfs/nfs4client.c                           |   45 ++++++---
 fs/nfs/nfs4state.c                            |    8 +
 fs/reiserfs/xattr.c                           |    4=20
 fs/ubifs/super.c                              |   12 +-
 include/linux/ata.h                           |    2=20
 include/linux/libata.h                        |    1=20
 include/linux/preempt.h                       |   22 +++-
 include/linux/spinlock_up.h                   |   29 +++---
 kernel/trace/ftrace.c                         |    8 -
 mm/mmap.c                                     |    2=20
 mm/nommu.c                                    |    2=20
 net/can/gw.c                                  |    6 -
 net/mac80211/cfg.c                            |    6 -
 net/mac80211/ieee80211_i.h                    |    3=20
 net/mac80211/offchannel.c                     |   23 +++-
 net/sunrpc/clnt.c                             |    4=20
 sound/pci/hda/hda_codec.c                     |    2=20
 sound/pci/hda/hda_eld.c                       |    2=20
 sound/pci/hda/patch_realtek.c                 |    4=20
 sound/soc/fsl/imx-ssi.c                       |    5 +
 sound/soc/sh/dma-sh7760.c                     |    4=20
 sound/soc/spear/spear_pcm.c                   |   12 +-
 67 files changed, 507 insertions(+), 341 deletions(-)

Adam Jackson (1):
      drm/i915: Be sure to turn hsync/vsync back on at crt enable (v2)

Alex Williamson (1):
      vfio-pci: Fix possible integer overflow

Anatolij Gustschin (1):
      spi/mpc512x-psc: optionally keep PSC SS asserted across xfer segmensts

Arnd Bergmann (1):
      block: avoid using uninitialized value in from queue_var_store

Artem Bityutskiy (1):
      UBIFS: make space fixup work in the remount case

Benjamin Tissoires (1):
      HID: magicmouse: fix race between input_register() and probe()

Bing Zhao (1):
      mwifiex: complete last internal scan

Bjorn Helgaas (1):
      Revert "PCI/ACPI: Request _OSC control before scanning PCI root bus"

Christopher Harvey (1):
      drm/mgag200: Index 24 in extended CRTC registers is 24 in hex, not de=
cimal.

Chuck Lever (1):
      SUNRPC: Remove extra xprt_put()

David Daney (2):
      MIPS: Fix logic errors in bitops.c
      MIPS: Unbreak function tracer for 64-bit kernel.

David Henningsson (1):
      ALSA: hda - fix typo in proc output

David Woodhouse (1):
      libata: fix DMA to stack in reading devslp_timing parameters

Dimitris Papastamos (1):
      regmap: Initialize `map->debugfs' before regcache

Dmitry Tarnyagin (1):
      remoteproc/ste: fix memory leak on shutdown

Gabriel Fernandez (1):
      gpio: stmpe: pass DT node to irqdomain

Girish K S (1):
      spi/s3c64xx: modified error interrupt handling and init

Greg Kroah-Hartman (1):
      Linux 3.8.7

Ilija Hadzic (1):
      drm: correctly restore mappings if drm_open fails

Jakub Kicinski (1):
      ixgbe: fix registration order of driver and DCA nofitication

Jan Beulich (1):
      x86: Fix rebuild with EFI_STUB enabled

Jan Kara (1):
      reiserfs: Fix warning and inode leak when deleting inode with xattrs

Jan Kiszka (1):
      ftrace: Consistently restore trace function on sysctl enabling

Jan Stancek (1):
      mm: prevent mmap_cache race in find_vma()

Jani Nikula (3):
      drm/i915: add quirk to invert brightness on eMachines G725
      drm/i915: add quirk to invert brightness on eMachines e725
      drm/i915: add quirk to invert brightness on Packard Bell NCL20

Jay Estabrook (1):
      alpha: Add irongate_io to PCI bus resources

Johan Hovold (1):
      Revert "drivers/rtc/rtc-at91rm9200.c: use a variable for storing IMR"

Johannes Berg (1):
      mac80211: fix remain-on-channel cancel crash

Jonghwan Choi (1):
      cpufreq: exynos: Get booting freq value in exynos_cpufreq_init

Jussi Kivilinna (1):
      crypto: gcm - fix assumption that assoc has one segment

Lars-Peter Clausen (3):
      ASoC: dma-sh7760: Fix compile error
      ASoC: spear_pcm: Update to new pcm_new() API
      regmap: cache Fix regcache-rbtree sync

Lauri Kasanen (1):
      drm/i915: Fix build failure

Li Fei (1):
      hwspinlock: fix __hwspin_lock_request error path

Linus Torvalds (1):
      spinlocks and preemption points need to be at least compiler barriers

Linus Walleij (1):
      crypto: ux500 - add missing comma

Maarten Lankhorst (1):
      drm/nouveau: fix handling empty channel list in ioctl's

Maxim Mikityanskiy (1):
      msi-wmi: Fix memory leak

Mengdong Lin (1):
      ALSA: hda - bug fix on return value when getting HDMI ELD info

Michael Wolf (1):
      powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition being =
performed before the ANDCOND test

Paul Moore (1):
      x86: remove the x32 syscall bitmask from syscall_get_nr()

Rafael J. Wysocki (2):
      PCI/ACPI: Always resume devices on ACPI wakeup notifications
      PCI/PM: Disable runtime PM of PCIe ports

Rainer Koenig (1):
      ALSA: hda - Enabling Realtek ALC 671 codec

Richard Guy Briggs (1):
      thermal: return an error on failure to register thermal class

Robert Tivy (1):
      remoteproc: fix FW_CONFIG typo

Sascha Hauer (1):
      ASoC: imx-ssi: Fix occasional AC97 reset failure

Sean Young (1):
      Revert "tty/8250_pnp: serial port detection regression since v3.7"

Shan Hai (2):
      libata: Use integer return value for atapi_command_packet_set
      libata: Set max sector to 65535 for Slimtype DVD A DS8A8SH drive

Sjur Br=E6ndeland (1):
      remoteproc: fix error path of handle_vdev

Stone Piao (1):
      mwifiex: limit channel number not to overflow memory

Thomas Abraham (1):
      ARM: EXYNOS: Fix crash on soft reset on EXYNOS5440

Tim Gardner (1):
      rt2x00: rt2x00pci_regbusy_read() - only print register access failure=
 once

Trond Myklebust (3):
      NFSv4: Fix a memory leak in nfs4_discover_server_trunking
      NFSv4/4.1: Fix bugs in nfs4[01]_walk_client_list
      NFSv4: Doh! Typo in the fix to nfs41_walk_client_list

Wei Yongjun (1):
      can: gw: use kmem_cache_free() instead of kfree()

Yinghai Lu (2):
      EISA/PCI: Init EISA early, before PNP
      EISA/PCI: Fix bus res reference

Youquan Song (1):
      ata_piix: Fix DVD not dectected at some Haswell platforms

hayeswang (1):
      r8169: fix auto speed down issue


--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRaEUyAAoJEDjbvchgkmk+SlsQAIwtajZrq3A3NhyqB2h6sTTR
K0yeCFndBhhMx6urmdjNfZeW89v3upILBDOm6jLqgkukLroq4bYYq5z+Ks7eTqVv
A7+BexK2WOWh1PD6aTwR951X/7/+aXzLVSDBZdwiKr1BIDueQoNuRdZvO/R4A/RZ
f7xbWQ1/wnO9jV5jV2j+zh3OOqJS7T12KCICq2kLdiFGgv5dfsO3IeIPCstsT85D
Q8FoSwbr+EFs+4hxBybShloaix7gnl+SNkcRdOnuythVgmTCGrCPhN5zNZddzTxw
2NfIL8UBZ9fdGJ1VbMwATmwjZqZl25Avzey6bU8sh9pNFpmYf1+vtGEX2xwd4ZHu
k8LgMtHeurLv3rQsqYn7l256/1V+mKxI1tbPgEmdhkWMYyhOSaQzYl4NRtpfDWUD
8KLS+QksjlUPvPfmSGbw6xH5UzyVWczfAp0AdVBQQEo1zxeVZanhsIsNZy9mzx7X
u0jr5GkrrDuv3vvfaA2K1p+7AVrSdhGwYt2+4xv21WR7UqaP/QF3JGsm/fc7bcCX
r3GtCfdfKmjbkSqGWvBzKfwXttIt4pEFjU5VHVtUwyMpuOaRavmGJa+j9ehsc6xS
5VYyQSDKqD+3ZeVrXH/Nb8CldCoxJQxZhgRQPsL3Ajk5KlUaDV1uFApKomqnemgU
FnMXwWndhXLJ70uQi1dR
=j/qy
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
