Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaGVFhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:37:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41759 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaGVFhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:37:11 -0400
Date: Mon, 21 Jul 2014 22:37:08 -0700 (PDT)
Message-Id: <20140721.223708.524693301044885285.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 21 Jul 2014 22:37:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these IDE fixes:

1) Fix interrupt registry for some Atari IDE chipsets.

2) Adjust Kconfig dependencies for x86_32 specific chips.

Thanks!

The following changes since commit 0c0bd34a142963ca3454f530e47ce1c230d8cc9d:

  Merge branch 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2014-03-03 10:49:24 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide.git master

for you to fetch changes up to 5b40dd30bbfaa7fcba0cd945a4852a146c552ea7:

  ide: Fix SC1200 dependencies (2014-03-17 15:57:28 -0400)

----------------------------------------------------------------
Jean Delvare (2):
      ide: Fix CS5520 and CS5530 dependencies
      ide: Fix SC1200 dependencies

Michael Schmitz (1):
      m68k/atari - ide: do not register interrupt if host->get_lock is set

 drivers/ide/Kconfig     | 5 ++++-
 drivers/ide/ide-probe.c | 8 +++++---
 2 files changed, 9 insertions(+), 4 deletions(-)
