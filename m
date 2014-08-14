Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbaHNXR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 19:17:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33729 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135AbaHNXRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 19:17:25 -0400
Date: Thu, 14 Aug 2014 16:17:24 -0700 (PDT)
Message-Id: <20140814.161724.1511384545281030914.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Aug 2014 16:17:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hook up the memfd syscall, and properly claim all PCI resources
discovered when building the PCI device tree.

Please pull, thanks a lot!

The following changes since commit f0094b28f3038936c1985be64dbe83f0e950b671:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-08-13 18:27:40 -0600)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to 10cf15e1d1289aa0bf1d26e9f55176b4c7c5c512:

  sparc: Hook up memfd_create system call. (2014-08-13 22:00:09 -0700)

----------------------------------------------------------------
David S. Miller (4):
      sparc64: Expand PCI bridge probing debug logging.
      sparc64: Skip bogus PCI bridge ranges.
      sparc64: Properly claim resources as each PCI bus is probed.
      sparc: Hook up memfd_create system call.

 arch/sparc/include/uapi/asm/unistd.h |  3 ++-
 arch/sparc/kernel/pci.c              | 67 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 arch/sparc/kernel/systbls_32.S       |  2 +-
 arch/sparc/kernel/systbls_64.S       |  4 ++--
 4 files changed, 71 insertions(+), 5 deletions(-)
