Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3DLReD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 13:34:03 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41249 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab3DLReA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 13:34:00 -0400
Date: Fri, 12 Apr 2013 10:33:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.40
Message-ID: <20130412173314.GA28305@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.40 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                |    2=20
 arch/alpha/kernel/sys_nautilus.c        |    5 ++
 arch/powerpc/platforms/pseries/lpar.c   |    8 +++
 arch/x86/boot/compressed/Makefile       |    5 --
 arch/x86/include/asm/syscall.h          |    4 -
 block/blk-sysfs.c                       |    2=20
 crypto/gcm.c                            |   17 ++++++--
 drivers/ata/ata_piix.c                  |   13 +++++-
 drivers/ata/libata-core.c               |    4 +
 drivers/base/regmap/regcache-rbtree.c   |    2=20
 drivers/eisa/pci_eisa.c                 |   67 +++++++++++++++++++++------=
-----
 drivers/hwspinlock/hwspinlock_core.c    |    2=20
 drivers/net/wireless/mwifiex/init.c     |    8 ---
 drivers/net/wireless/rt2x00/rt2x00pci.c |    4 -
 drivers/spi/spi-mpc512x-psc.c           |    2=20
 drivers/spi/spi-s3c64xx.c               |   41 +++++++++++--------
 drivers/thermal/thermal_sys.c           |    1=20
 fs/reiserfs/xattr.c                     |    4 -
 fs/ubifs/super.c                        |   12 ++---
 include/linux/ata.h                     |    2=20
 include/linux/libata.h                  |    1=20
 include/linux/preempt.h                 |   22 ++++++----
 include/linux/spinlock_up.h             |   29 ++++++++-----
 kernel/panic.c                          |    8 +++
 kernel/trace/ftrace.c                   |    8 ---
 mm/mmap.c                               |    2=20
 mm/nommu.c                              |    2=20
 net/can/gw.c                            |    6 +-
 sound/pci/hda/hda_codec.c               |    2=20
 sound/pci/hda/hda_eld.c                 |    2=20
 sound/pci/hda/patch_realtek.c           |    4 +
 sound/soc/sh/dma-sh7760.c               |    4 -
 32 files changed, 191 insertions(+), 104 deletions(-)

Anatolij Gustschin (1):
      spi/mpc512x-psc: optionally keep PSC SS asserted across xfer segmensts

Arnd Bergmann (1):
      block: avoid using uninitialized value in from queue_var_store

Artem Bityutskiy (1):
      UBIFS: make space fixup work in the remount case

David Henningsson (1):
      ALSA: hda - fix typo in proc output

Girish K S (1):
      spi/s3c64xx: modified error interrupt handling and init

Greg Kroah-Hartman (2):
      Revert "mwifiex: cancel cmd timer and free curr_cmd in shutdown proce=
ss
      Linux 3.4.40

Jan Beulich (1):
      x86: Fix rebuild with EFI_STUB enabled

Jan Kara (1):
      reiserfs: Fix warning and inode leak when deleting inode with xattrs

Jan Kiszka (1):
      ftrace: Consistently restore trace function on sysctl enabling

Jan Stancek (1):
      mm: prevent mmap_cache race in find_vma()

Jay Estabrook (1):
      alpha: Add irongate_io to PCI bus resources

Jussi Kivilinna (1):
      crypto: gcm - fix assumption that assoc has one segment

Lars-Peter Clausen (2):
      ASoC: dma-sh7760: Fix compile error
      regmap: cache Fix regcache-rbtree sync

Li Fei (1):
      hwspinlock: fix __hwspin_lock_request error path

Linus Torvalds (1):
      spinlocks and preemption points need to be at least compiler barriers

Mengdong Lin (1):
      ALSA: hda - bug fix on return value when getting HDMI ELD info

Michael Wolf (1):
      powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition being =
performed before the ANDCOND test

Paul Moore (1):
      x86: remove the x32 syscall bitmask from syscall_get_nr()

Rainer Koenig (1):
      ALSA: hda - Enabling Realtek ALC 671 codec

Richard Guy Briggs (1):
      thermal: return an error on failure to register thermal class

Shan Hai (2):
      libata: Use integer return value for atapi_command_packet_set
      libata: Set max sector to 65535 for Slimtype DVD A DS8A8SH drive

Tim Gardner (1):
      rt2x00: rt2x00pci_regbusy_read() - only print register access failure=
 once

Vikram Mulukutla (1):
      panic: fix a possible deadlock in panic()

Wei Yongjun (1):
      can: gw: use kmem_cache_free() instead of kfree()

Yinghai Lu (2):
      EISA/PCI: Init EISA early, before PNP
      EISA/PCI: Fix bus res reference

Youquan Song (1):
      ata_piix: Fix DVD not dectected at some Haswell platforms


--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRaEVaAAoJEDjbvchgkmk+aSMP/Ry5GuxDgNJcOiug8/PXpBp3
lvR6HHDoHMq+ZtN71SFHfO63NE6laoZftUO3KkNn1489o1/Nugny/nQ28YbkbLtT
gpLCnGqAwVTQlwFvMSbuSvEPUmDETQCqeCb7zzuH9nPYmuc+/drtcCDhl2RQkT/9
bA/pt4f/1m7dF+C9e73R4QvqmNfkk6yncq5GI1+ydZF5mbIbiGiDZ42TOH0ifBCp
A+fTQyaLHBeVRzlcjvjh0U/xj4A+MOo7yBTD5hVS6Av2oSXcAfzICmr10DcLmqPI
IbomDXfgjslYfu5KFkZqK20S7vmNgxttFAUbUSqUtm1hliUYuoEEIN8yb3bSpOf8
d4uKGBaaY8Ajw1M2nlC6euqxlek1TftBNUJvCY18cGkogLqgeh0jP5utAIV91ReH
lQr/+25G4EqmfJzZEegBZ32ZM6d11tlkmICwusBeqbLxTf3ECCuNgdZoCQ5hHrty
2Bt/sXu0oSdv4JN4n+mIIa44oM+ckwIgcaoipx6VgboIrenpq7CfMXlcJnBqDQcN
bvE8xHJsfFid7MzWaCMhzHpdTPA5KZp7oWczKmJRCGZ1+1hqWEiwHyN0sR1UF8pc
81DVTlHxKj41m19Fl3Irp0uq0rxs3DP9QBkdQhdQdI2AIuqnNpBMFQHYEVb1Nnky
FNi007Fb9i+zaE4drrt3
=p/dc
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
