Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322AbaAYRvH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 12:51:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50421 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752171AbaAYRvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 12:51:03 -0500
Date: Sat, 25 Jan 2014 09:51:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.10.28
Message-ID: <20140125175156.GA4864@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.10.28 kernel.

All users of the 3.10 kernel series must upgrade.

The updated 3.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.10.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                             |    2=20
 arch/arm/kernel/machine_kexec.c                      |    1=20
 arch/arm/mach-highbank/highbank.c                    |    1=20
 arch/arm/mach-omap2/omap4-common.c                   |    1=20
 arch/x86/kernel/cpu/perf_event_amd_ibs.c             |   53 ++++++++++++++=
++---
 arch/x86/kernel/entry_32.S                           |    4 -
 arch/x86/kernel/entry_64.S                           |    2=20
 drivers/gpu/drm/i915/intel_ddi.c                     |    8 ++
 drivers/gpu/drm/i915/intel_display.c                 |    4 -
 drivers/hwmon/coretemp.c                             |    2=20
 drivers/md/md.c                                      |   18 +++++-
 drivers/md/md.h                                      |    3 +
 drivers/md/raid10.c                                  |   12 ++--
 drivers/md/raid5.c                                   |    4 -
 drivers/staging/comedi/drivers/addi_apci_1032.c      |    4 -
 drivers/staging/comedi/drivers/adl_pci9111.c         |    2=20
 drivers/tty/serial/amba-pl011.c                      |    6 ++
 fs/dcache.c                                          |    7 ++
 fs/fs-writeback.c                                    |   15 +++--
 fs/gfs2/inode.c                                      |   16 +++++
 fs/nilfs2/segment.c                                  |   10 ++-
 include/linux/mm.h                                   |   13 ++--
 mm/huge_memory.c                                     |    6 +-
 mm/memory-failure.c                                  |   14 +++--
 security/selinux/hooks.c                             |   20 ++++++-
 security/selinux/include/objsec.h                    |    5 +
 tools/perf/util/scripting-engines/trace-event-perl.c |    2=20
 27 files changed, 177 insertions(+), 58 deletions(-)

Andreas Rohner (1):
      nilfs2: fix segctor bug that causes file system corruption

Arnaldo Carvalho de Melo (1):
      perf scripting perl: Fix build error on Fedora 12

Bob Peterson (1):
      GFS2: Increase i_writecount during gfs2_setattr_chown

Eric W. Biederman (1):
      vfs: In d_path don't call d_dname on a mount point

Geert Uytterhoeven (1):
      mm: Make {,set}page_address() static inline if WANT_PAGE_VIRTUAL

Greg Kroah-Hartman (1):
      Linux 3.10.28

H Hartley Sweeten (2):
      staging: comedi: addi_apci_1032: fix subdevice type/flags bug
      staging: comedi: adl_pci9111: fix incorrect irq passed to request_irq=
()

Hugh Dickins (1):
      thp: fix copy_page_rep GPF by testing is_huge_zero_pmd once only

Jan Kara (1):
      writeback: Fix data corruption on NFS

Jean Delvare (1):
      hwmon: (coretemp) Fix truncated name of alarm attributes

Jianguo Wu (1):
      mm/memory-failure.c: recheck PageHuge() after hugetlb page migrate su=
ccessfully

Jon Medhurst (1):
      serial: amba-pl011: use port lock to guard control register access

NeilBrown (4):
      md: fix problem when adding device to read-only array with bitmap.
      md/raid10: fix bug when raid10 recovery fails to recover a block.
      md/raid10: fix two bugs in handling of known-bad-blocks.
      md/raid5: Fix possible confusion when multiple write errors occur.

Paulo Zanoni (1):
      drm/i915: fix DDI PLLs HW state readout code

Robert Richter (1):
      perf/x86/amd/ibs: Fix waking up from S3 for AMD family 10h

Steven Rostedt (2):
      SELinux: Fix possible NULL pointer dereference in selinux_inode_permi=
ssion()
      ftrace/x86: Load ftrace_ops in parameter not the variable holding it

Taras Kondratiuk (1):
      ARM: 7938/1: OMAP4/highbank: Flush L2 cache before disabling

Vijaya Kumar K (1):
      ARM: 7815/1: kexec: offline non panic CPUs on Kdump panic

Ville Syrj=E4l=E4 (1):
      drm/i915: Don't grab crtc mutexes in intel_modeset_gem_init()


--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4/m8AAoJEDjbvchgkmk+PLsP/2Xa4a3xN6ejvBNXIz7BvGj3
G3nAu5qc9simpd68XrX9LqEG0bh1Yi2ShCTlwx2jBfiunmqYs0SwzwxuSWv8utAi
tiqxNjbVmIjnhWzDV46OVrOsY4dvQak1fnpenBD+7n7vZO78anAsA1a0ZgcbgZjk
hRq/VbzPbhAbaM/1HHlWoma4UMjQ/v6P/CAF3eit7HjU1G3EpWFJ0M08uFd2IPqF
IBIs+8G1zw95CAajUDSwjnkSmbCO2lJQ/Op3GhbacdFX8cG50gT287OhV5XiWf73
sC5VOgrzNsfKaDn2T2TWTjxV+JSemSiuH8in5tAZOx2NQNm7V0HEH8B2te71rtOS
6jVy9LB4viqXUl8yYHEGrocPeIPLpSnrJ6Fqx6uqAZY6tidYKJ3vXDJHbs649kAS
SIwLcOPXWpJ2yy6lBG7ZIbwRTb4CpkANW29SOrPMCDFnDoAJ1U3sfpb1udbk2/EM
Xc1yqnTPYyzrMGodQbyydYsKyQNb/7tuDD8vNKgy6p9Nsxlmvo+QGbQCGkFJby1P
trLOcmERvmDuAJ24Uf9yMmYaR2mK+XvaxGiyXcsFAaCFGlb1iGQytRPsQvxO/DuY
1vyHalNkz+WQeyTkgqVnG+9SftC2TxogoBzX3Ms8Aq4XcosKS7pKJ2W0FRcA/KkE
RmQekPh7qNucfyP4s7ZN
=fI9R
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
