Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab3DLRja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 13:39:30 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:37622 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab3DLRj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 13:39:29 -0400
Date: Fri, 12 Apr 2013 10:39:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.0.73
Message-ID: <20130412173905.GA32458@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fdj2RfSjLxBAspz7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm announcing the release of the 3.0.73 kernel.

All users of the 3.0 kernel series must upgrade.

The updated 3.0.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                |    2 +-
 arch/alpha/kernel/sys_nautilus.c        |    5 +++++
 arch/powerpc/platforms/pseries/lpar.c   |    8 +++++++-
 arch/x86/Kconfig                        |    4 ----
 arch/x86/mm/numa.c                      |    3 ---
 arch/x86/mm/numa_internal.h             |    6 ------
 block/blk-sysfs.c                       |    2 ++
 crypto/gcm.c                            |   17 ++++++++++++++---
 drivers/ata/libata-core.c               |    4 ++++
 drivers/net/wireless/mwifiex/init.c     |    8 --------
 drivers/net/wireless/rt2x00/rt2x00pci.c |    4 ++--
 drivers/thermal/thermal_sys.c           |    1 +
 fs/ext4/ialloc.c                        |    5 +++--
 fs/reiserfs/xattr.c                     |    4 ++--
 fs/ubifs/super.c                        |   12 ++++++------
 include/linux/ata.h                     |    2 +-
 include/linux/libata.h                  |    1 +
 include/linux/preempt.h                 |   22 ++++++++++++++--------
 include/linux/spinlock_up.h             |   29 ++++++++++++++++++-----------
 kernel/trace/ftrace.c                   |    8 ++------
 mm/mmap.c                               |    2 +-
 mm/nommu.c                              |    2 +-
 sound/pci/hda/hda_codec.c               |    2 +-
 sound/pci/hda/hda_eld.c                 |    2 +-
 sound/soc/sh/dma-sh7760.c               |    4 ++--
 25 files changed, 89 insertions(+), 70 deletions(-)

Arnd Bergmann (1):
      block: avoid using uninitialized value in from queue_var_store

Artem Bityutskiy (1):
      UBIFS: make space fixup work in the remount case

Dave Hansen (1):
      x86-32, mm: Rip out x86_32 NUMA remapping code

David Henningsson (1):
      ALSA: hda - fix typo in proc output

Greg Kroah-Hartman (2):
      Revert "mwifiex: cancel cmd timer and free curr_cmd in shutdown process
      Linux 3.0.73

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

Lars-Peter Clausen (1):
      ASoC: dma-sh7760: Fix compile error

Linus Torvalds (1):
      spinlocks and preemption points need to be at least compiler barriers

Mengdong Lin (1):
      ALSA: hda - bug fix on return value when getting HDMI ELD info

Michael Wolf (1):
      powerpc: pSeries_lpar_hpte_remove fails from Adjunct partition being performed before the ANDCOND test

Richard Guy Briggs (1):
      thermal: return an error on failure to register thermal class

Shan Hai (2):
      libata: Use integer return value for atapi_command_packet_set
      libata: Set max sector to 65535 for Slimtype DVD A DS8A8SH drive

Tim Gardner (1):
      rt2x00: rt2x00pci_regbusy_read() - only print register access failure once

Todd Poynor (1):
      ext4: fixup 64-bit divides in 3.0-stable backport of upstream fix


--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRaEa4AAoJEDjbvchgkmk+4C0P/21qtIi5HmFm/WID+LfUV+ld
nYVsf7bACUR3GOb/rVjUETegkcwH+TCU4xunAwjEjx7tjfrCWxFyCCbmWauncGsu
9Aw8Bv1lNei1nutv7vA3tq6lM+TsE78P9zAhf3HY2eE4Hka1JyCXFK4HS2uAOfdI
K0wbxsWxdkX7kfYN3rxcNZx+HP2CbLDFGoTsVvMxCDVXopj6PZotvRHeE0+ccW2m
sSKmF062ohZBVfK6g+91D8OMSHFdHTYPknPrKR9/uffymMWZVUmhjGrENfa2lOwH
PYgLBaokRUWdKWPHdFjrolB1Nr9kd9cffT3p7IR7RBiqRpsl/Jy5bNpC2m+wIkI+
d8LO0jq8dQ6Ddr4Z98qqj2nUX3V5hjZxBPLTaB1s3bPEmDOxImx3bDsPeWiv/spX
SsP8pU9c8dzBNxC/hKOdPZ1z9SxyOO8OelupGUvOPLtJgtNWeAKxCzWQ20hZdkoL
f1EqyLTxlFYSFfYGMMfnq0MCsQ0x6rjVDunTT2QfcSNzxzMy6k5+ZhM9PP2llOuW
E0qGMKK+i8271m4hKKbZi22Yfgkbx145u9spfELkLIL3/NybinQ+IRyQ2GvnNR0Q
ORW9zQ1E2igJFpdMbHnyBm2liIUMasWMwvszOCKZPtKTR4vm5Pw9gVi5yqPj6T3R
pFTKbD1L3np7pI7KA6gC
=AiYj
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
