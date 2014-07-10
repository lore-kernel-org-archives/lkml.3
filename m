Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaGJP1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:27:44 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:34057 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaGJP1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:27:41 -0400
Date: Thu, 10 Jul 2014 11:27:37 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [GIT PULL] libata fixes for v3.16-rc4
Message-ID: <20140710152737.GG6609@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Nothing too interesting.  All fixes are ahci_platform related.

Thanks.

The following changes since commit ebe06187bf2aec10d537ce4595e416035367d703:

  epoll: fix use-after-free in eventpoll_release_file (2014-06-16 17:21:59 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata.git for-3.16-fixes

for you to fetch changes up to 2a0bdff6b958d1b2523d2754b6cd5e0ea4053016:

  ahci_xgene: fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode command. (2014-07-08 11:46:05 -0400)

----------------------------------------------------------------
Kefeng Wang (1):
      ahci: disable ncq feature for hisilicon sata

Mikko Perttunen (1):
      libahci_platform: Fail when PHY required but PHY support disabled

Russell King (1):
      ata: ahci_imx: warn when disabling ahci link

Shawn Guo (1):
      ahci: imx: manage only sata_ref_clk in imx_sata_enable[disable]

Suman Tripathi (2):
      libahci: export ahci_qc_issue() and ahci_start_fix_rx()
      ahci_xgene: fix the dma state machine lockup for the IDENTIFY DEVICE PIO mode command.

 drivers/ata/ahci.h             |  2 ++
 drivers/ata/ahci_imx.c         | 38 +++++++++++++++++++++++---
 drivers/ata/ahci_platform.c    |  2 +-
 drivers/ata/ahci_xgene.c       | 60 +++++++++++++++++++++++++++++++++---------
 drivers/ata/libahci.c          |  7 ++---
 drivers/ata/libahci_platform.c |  7 ++++-
 6 files changed, 94 insertions(+), 22 deletions(-)

-- 
tejun
