Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab3JICNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 22:13:11 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:37313 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754092Ab3JICNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 22:13:08 -0400
From: Brian Norris <computersforpeace@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [GIT PULL] MTD fixes for 3.12-rc
Date: Tue,  8 Oct 2013 19:10:22 -0700
Message-Id: <1381284622-24286-1-git-send-email-computersforpeace@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus!

David Woodhouse and I have queued up a few MTD fixes for 3.12. As David seems
to be MIA again, I am sending the following pull request with his permission.

Thanks,
Brian

The following changes since commit 7b9e3a6ac00be4f3d654a711573b1794b046c22f:

  Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2013-09-19 18:49:08 -0500)

are available in the git repository at:


  git://git.infradead.org/linux-mtd.git tags/for-linus-20131008

for you to fetch changes up to 2b468ef0e7959b703626b64c4d264ef822c9267a:

  mtd: m25p80: Fix 4 byte addressing mode for Micron devices. (2013-09-27 05:56:22 -0500)

----------------------------------------------------------------

- fix a small memory leak in some new ONFI code
- account for additional odd variations of Micron SPI flash

----------------------------------------------------------------
Brian Norris (1):
      mtd: nand: fix memory leak in ONFI extended parameter page

Elie De Brauwer (1):
      mtd: m25p80: Fix 4 byte addressing mode for Micron devices.

 drivers/mtd/devices/m25p80.c | 17 +++++++++++++++--
 drivers/mtd/nand/nand_base.c |  8 +++-----
 2 files changed, 18 insertions(+), 7 deletions(-)
