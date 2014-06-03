Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbaFCHBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:01:10 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:42631 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753643AbaFCHBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:01:07 -0400
To: gxt@mprc.pku.edu.cn, torvalds@linux-foundation.org
Subject: [GIT PULL] UniCore32 update for v3.15-rc8
Cc: linux-kernel@vger.kernel.org
Message-Id: <20140603065940.A4756146003B@linuxdev-32>
Date: Tue,  3 Jun 2014 14:59:40 +0800 (CST)
From: guanxuetao@mprc.pku.edu.cn (guanxuetao)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is unicore32 pull request for v3.15-rc8.

This pull request includes bugfixes to make unicore32 successfully build under defconfig,
and some changes for allmodconfig (though not finished).

Please pull tags/for-linus with following updates.

Thanks and Regards,
Xuetao Guan

The following changes since commit cae61ba37b4c2672704cbd8a626fbd85be7e67d9:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net

are available in the git repository at:

  git://github.com/gxt/linux.git tags/for-linus

for you to fetch changes up to aba36cb673f6e3e41bd8d5cde1891795c4dace58:

  UniCore32: Change git tree location information in MAINTAINERS (2014-05-27 07:53:10 +0800)

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Chen Gang (17):
      arch/unicore32/kernel/ksyms.c: remove several undefined exported symbols
      arch/unicore32/kernel/module.c: use __vmalloc_node_range() instead of __vmalloc_area()
      arch/unicore32/kernel/clock.c: add readl() and writel() for 'PM_' macros
      arch/unicore32/mm/alignment.c: include "asm/pgtable.h" to avoid compiling error
      arch/unicore32/include/asm/ptrace.h: add generic definition for profile_pc()
      arch/unicore32/include/asm/io.h: add readl_relaxed() generic definition
      drivers/rtc/rtc-puv3.c: use dev_dbg() instead of dev_debug() for typo issue
      drivers/rtc/rtc-puv3.c: remove "&dev->" for typo issue MIME-Version: 1.0
      arch/unicore32/kernel/ksyms.c: remove 2 export symbols to avoid compiling failure
      arch: unicore32: kernel: ksyms: remove 'bswapsi2' and 'muldi3' to avoid compiling failure
      drivers: scsi: mvsas: fix compiling issue by adding 'MVS_' for "enum pci_interrupt_cause"
      arch/unicore32/kernel/setup.c: add generic 'screen_info' to avoid compiling failure
      unicore32: include: asm: add missing ')' for PAGE_* macros in pgtable.h
      arch:unicore32:mm: add devmem_is_allowed() to support STRICT_DEVMEM
      arch: unicore32: ksyms: export additional find_first_*() to avoid compiling failure
      arch: unicore32: ksyms: export 'pm_power_off' to avoid compiling failure.
      arch: unicore32: ksyms: export '__cpuc_coherent_kern_range' to avoid compiling failure

Guan Xuetao (1):
      UniCore32: Change git tree location information in MAINTAINERS

Zhichuang SUN (1):
      drivers/video/fbdev/fb-puv3.c: Add header files for function unifb_mmap

 MAINTAINERS                          |    4 +-
 arch/unicore32/include/asm/io.h      |   27 ++++++++++++++++
 arch/unicore32/include/asm/pgtable.h |   10 +++---
 arch/unicore32/include/asm/ptrace.h  |    1 +
 arch/unicore32/kernel/clock.c        |    8 ++--
 arch/unicore32/kernel/ksyms.c        |   41 +-----------------------
 arch/unicore32/kernel/ksyms.h        |    2 -
 arch/unicore32/kernel/module.c       |   11 ++-----
 arch/unicore32/kernel/process.c      |    1 +
 arch/unicore32/kernel/setup.c        |    4 ++
 arch/unicore32/mm/alignment.c        |    1 +
 arch/unicore32/mm/proc-syms.c        |    2 +
 drivers/rtc/rtc-puv3.c               |    4 +-
 drivers/scsi/mvsas/mv_94xx.c         |   10 +++---
 drivers/scsi/mvsas/mv_94xx.h         |   58 +++++++++++++++++-----------------
 drivers/video/fbdev/fb-puv3.c        |    2 +
 16 files changed, 90 insertions(+), 96 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJTjWloAAoJENFylnOm3dTbbrkP/0Ol6LiUULkenh7J2CvxBw2r
DGqogrFlJKlrZDPbnNomNKnhiBJsjCTPmgoUTfP8NSxTu0vmaeqHUz/JFsP3GwXC
FL985EDrj4TyB16evse21rY3f5z+UNGdAHsxlzFC+2WBFxEbWnbVmyXwanqmw8Xa
zxt9IK3eXWgulvGYMxtQ/xT4SF0AGtZDHGGn0nZsSolnY4ChUKSmoRMziHpb9GFp
m/Jb4aMCLdlb2BcJUifln5joDecP8XOnfPWjUdxZLPmHFT6KxgTzgiT8pqZ6XfNc
g2KU4DT0YcLKEnBYFnxy8JFt4kU174VZ7tJKtAPdIcnwur23Khfh+xR0McALcA7S
3YkDF7zZ8Aj10/m0njEQx4utgcJ6qf6S0PJ9mMfRT9SrTPvT6dOYp+JGlgnk91IT
2Mgd1zxUEopdAE3HHmeM5Ii17gr5ifZ0BZNzXSKf/rOY7tmvrso9tbAUMdElg3cd
/tkRsb2z+flT0xnFmCvdAmPWppSaXWWW/RF4Wq9JkRCGA8F8KW2/GoG2GitUjMfn
vj1bN0lH5tpkNkJpHxrCB5z54YMMFLA1eSEcdfl8PfkXlFYZY+pRXjc5Rph3sStp
ckD17QtBzD2NbaiwrCJuMQ7cDtmdj3maTleJiQLccj8Sh98gp6FpSiTZcsGTuGnQ
mhfN3djHkuz5OLSLGX8/
=jyTe
-----END PGP SIGNATURE-----
