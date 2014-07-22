Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaGVFiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 01:38:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41765 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaGVFiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 01:38:22 -0400
Date: Mon, 21 Jul 2014 22:38:16 -0700 (PDT)
Message-Id: <20140721.223816.1457327353814495306.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 21 Jul 2014 22:38:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Need to hook up the new renameat2 system call.

Please pull, thanks!

The following changes since commit 9a3c4145af32125c5ee39c0272662b47307a8323:

  Linux 3.16-rc6 (2014-07-20 21:04:16 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to 26053926feb1c16ade9c30bc7443bf28d829d08e:

  sparc: Hook up renameat2 syscall. (2014-07-21 22:27:56 -0700)

----------------------------------------------------------------
David S. Miller (1):
      sparc: Hook up renameat2 syscall.

 arch/sparc/include/uapi/asm/unistd.h | 3 ++-
 arch/sparc/kernel/sys32.S            | 1 +
 arch/sparc/kernel/systbls_32.S       | 1 +
 arch/sparc/kernel/systbls_64.S       | 2 ++
 4 files changed, 6 insertions(+), 1 deletion(-)
