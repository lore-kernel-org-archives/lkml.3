Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbaGZA53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 20:57:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:50948 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbaGZA51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 20:57:27 -0400
From: Steven Miao <realmz6@kernel.org>
To: torvalds@linux-foundation.org
Cc: adi-buildroot-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [uclinux-dist-devel] [GIT PULL] Blackfin fixes for v3.16-rc7
Date: Sat, 26 Jul 2014 08:57:21 +0800
Message-Id: <1406336241-10044-1-git-send-email-realmz6@kernel.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull blackfin fixes for v3.16, smc nor flash PM fix, pinctrl group fix, update defconfig, and build fixes.

The following changes since commit 9a3c4145af32125c5ee39c0272662b47307a8323:

  Linux 3.16-rc6 (2014-07-20 21:04:16 -0700)

are available in the git repository at:

  http://git.kernel.org/pub/scm/linux/kernel/git/realmz6/blackfin-linux.git tags/blackfin-3.16-fixes

for you to fetch changes up to b76f98236a23f808d6e3a27f7292670bc1d2c21b:

  blackfin: vmlinux.lds.S: reserve 32 bytes space at the end of data section for XIP kernel (2014-07-26 08:32:50 +0800)

----------------------------------------------------------------
blackfin fixes for v3.16

----------------------------------------------------------------
Sonic Zhang (1):
      blackfin: bind different groups of one pinmux function to different state name

Steven Miao (5):
      pm: bf609: cleanup smc nor flash
      blackfin: fix some bf5xx boards build for missing <linux/gpio.h>
      irq: blackfin sec: drop duplicated sec priority set
      defconfig: BF609: update spi config name
      blackfin: vmlinux.lds.S: reserve 32 bytes space at the end of data section for XIP kernel

 arch/blackfin/configs/BF609-EZKIT_defconfig  |    2 +-
 arch/blackfin/kernel/vmlinux.lds.S           |    2 +-
 arch/blackfin/mach-bf533/boards/blackstamp.c |    1 +
 arch/blackfin/mach-bf537/boards/cm_bf537e.c  |    1 +
 arch/blackfin/mach-bf537/boards/cm_bf537u.c  |    1 +
 arch/blackfin/mach-bf537/boards/tcm_bf537.c  |    1 +
 arch/blackfin/mach-bf548/boards/ezkit.c      |    6 ++++--
 arch/blackfin/mach-bf561/boards/acvilon.c    |    1 +
 arch/blackfin/mach-bf561/boards/cm_bf561.c   |    1 +
 arch/blackfin/mach-bf561/boards/ezkit.c      |    1 +
 arch/blackfin/mach-bf609/boards/ezkit.c      |   20 ++++++++------------
 arch/blackfin/mach-bf609/include/mach/pm.h   |    5 +++--
 arch/blackfin/mach-bf609/pm.c                |    4 ++--
 arch/blackfin/mach-common/ints-priority.c    |    2 --
 14 files changed, 26 insertions(+), 22 deletions(-)
