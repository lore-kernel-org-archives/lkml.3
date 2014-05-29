Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978AbaE2IUl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:20:41 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:48971 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373AbaE2IUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:20:38 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL REQUEST] UniCore32 update for 3.15-rc7
Cc: linux-kernel@vger.kernel.org
Message-Id: <20140529081928.4CDCB1463DC2@linuxdev-32>
Date: Thu, 29 May 2014 16:19:28 +0800 (CST)
From: guanxuetao@mprc.pku.edu.cn (guanxuetao)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The following changes since commit f2159d1e99612ceb94bf9a2dc2fbca409d828b1b:
  Linus Torvalds (1):
        Merge tag 'sound-3.15-rc8' of git://git.kernel.org/.../tiwai/sound

are available in the git repository at:

  git://github.com/gxt/linux.git unicore32

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

iQIbBAEBAgAGBQJThuzIAAoJENFylnOm3dTbBOEP+M+dTEQdovyc2u9PyDhiJeg5
wuid6ZmliuPomCCG1CuimfYZ3mqBlXnwmofLaTStbVGANO1ibOdyyyzPEptoaOXk
MLoQcIpW7b3wleXwFtKoq+gRCQNMLQcH3v4UfM9cYYQm6fpXCkmNoD/7FCAAngym
4DQhAihJ2oqjxusIrhmlaPtx9GG0BIFHR5XKZgP/CpzdWyCcyim/YVrmrMovvXxT
UkGc2lfxqp66Pc29uTE8EzW9gFe9LCs0NN1bBy80DTOhHkr2JT4Y6dvm/68ugfnI
0OeN6pI/2BzwuudgixBKEL+KW7MWbzQQlS8a9ussqLnFYWXteCFHtYC2P0NJwJTe
OVgaJLiXsWtDuKAuzJkQfiP0NmFJlGCi9Z5kn4QeMURns+eTZAUY0O8+D8oDXPPp
14CtgO7OEwoPpCoBRyei5vW/P3rfbCIbvlbTkFkWB39/Y3vPXIcTiViUv1Wc0NjF
dJuxAhteM8MUUCrFkYNokiEFaJRA+S5Etw8wJieYTPE08t0niRO1VuECp4UWVm+4
72pZlNi7uq2GQQ7+8jSDuLAtSkURwn1ZRoFmTnmsCa/27RcGAVgjNYb9QjxpaPf6
giW+buhRhuHcVtd+iROU4vXzWklEE+Xlsl94ldoaNirPIW2jh+R/GPPL1rWzO3h+
HzMswTfyIz06rgEIYAM=
=pk0J
-----END PGP SIGNATURE-----
