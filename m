Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaHFFDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 01:03:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36064 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbaHFFDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 01:03:13 -0400
Date: Tue, 05 Aug 2014 22:03:12 -0700 (PDT)
Message-Id: <20140805.220312.1017005928261423242.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Aug 2014 22:03:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just one minor cleanup, please pull!

The following changes since commit e7fda6c4c3c1a7d6996dd75fd84670fa0b5d448f:

  Merge branch 'timers-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2014-08-05 17:46:42 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide.git master

for you to fetch changes up to a53dae49b2fea43d8f4ec5aeca0e288bbc8d6895:

  ide: use module_platform_driver() (2014-08-05 21:16:46 -0700)

----------------------------------------------------------------
Christoph Jaeger (1):
      ide: use module_platform_driver()

 drivers/ide/au1xxx-ide.c   | 13 +------------
 drivers/ide/ide_platform.c | 13 +------------
 2 files changed, 2 insertions(+), 24 deletions(-)
