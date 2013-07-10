Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab3GJTVe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:21:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44413 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab3GJTVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:21:31 -0400
Date: Wed, 10 Jul 2013 12:21:30 -0700 (PDT)
Message-Id: <20130710.122130.1380851842199973691.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just a few small things:

1) module_platform_driver_probe() conversions from Jingoo Han.

2) module_pci_driver() conversion from Libo Chen.

3) PIO size calculation fix from Steven J. Hill.

Please pull, thanks a lot!

The following changes since commit 47b3bc907328db968bc9b43c41f48f8d1e140750:

  Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2013-03-07 15:57:38 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide.git master

for you to fetch changes up to 1581208b2f0643eebfa7a3fbe5bad831c0bb7f0e:

  ide: Fix IDE PIO size calculation (2013-07-10 12:09:10 -0700)

----------------------------------------------------------------
Jingoo Han (3):
      ide: tx4938ide: use module_platform_driver_probe()
      ide: tx4939ide: use module_platform_driver_probe()
      ide: gayle: use module_platform_driver_probe()

Libo Chen (1):
      drivers/ide/delkin_cb: Convert to module_pci_driver

Steven J. Hill (1):
      ide: Fix IDE PIO size calculation

 drivers/ide/delkin_cb.c    | 13 +------------
 drivers/ide/gayle.c        | 15 +--------------
 drivers/ide/ide-taskfile.c |  5 ++---
 drivers/ide/tx4938ide.c    | 13 +------------
 drivers/ide/tx4939ide.c    | 13 +------------
 5 files changed, 6 insertions(+), 53 deletions(-)
