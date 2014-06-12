Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919AbaFLJcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:32:10 -0400
Received: from mail.kernel.org ([198.145.19.201]:38604 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750AbaFLJcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:32:09 -0400
From: Steven Miao <realmz6@kernel.org>
To: torvalds@linux-foundation.org
Cc: adi-buildroot-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [uclinux-dist-devel] [GIT PULL] Blackfin updates for 3.16
Date: Thu, 12 Jun 2014 17:32:01 +0800
Message-Id: <1402565521-6924-1-git-send-email-realmz6@kernel.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull blackfin updates for Linux 3.16, some bug fixes and defconfig cleanup.

The following changes since commit 1860e379875dfe7271c649058aeddffe5afd9d0d:

  Linux 3.15 (2014-06-08 11:19:54 -0700)

are available in the git repository at:

  http://git.kernel.org/pub/scm/linux/kernel/git/realmz6/blackfin-linux.git tags/blackfin-for-linus

for you to fetch changes up to 51fdc6bf98802eb7019ec94dfd82f0e6cd1c82a8:

  blackfin: defconfigs: add MTD_SPI_NOR (new dependency for M25P80) (2014-06-12 16:58:50 +0800)

----------------------------------------------------------------
blackfin updates for Linux 3.16

----------------------------------------------------------------
Brian Norris (1):
      blackfin: defconfigs: add MTD_SPI_NOR (new dependency for M25P80)

Steven Miao (2):
      bf533: fix build error: add linux/gpio.h
      Revert "blackfin: dma: current count mmr is read only"

 arch/blackfin/configs/BF526-EZBRD_defconfig    |    2 +-
 arch/blackfin/configs/BF527-EZKIT-V2_defconfig |    2 +-
 arch/blackfin/configs/BF527-EZKIT_defconfig    |    2 +-
 arch/blackfin/configs/BF548-EZKIT_defconfig    |    2 +-
 arch/blackfin/configs/BF609-EZKIT_defconfig    |    2 +-
 arch/blackfin/configs/BlackStamp_defconfig     |    3 +--
 arch/blackfin/configs/H8606_defconfig          |    3 +--
 arch/blackfin/include/asm/dma.h                |    2 ++
 arch/blackfin/mach-bf533/boards/stamp.c        |    1 +
 9 files changed, 10 insertions(+), 9 deletions(-)
