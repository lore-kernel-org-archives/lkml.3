Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaHLEB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 00:01:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:32881 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbaHLEB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 00:01:56 -0400
Date: Mon, 11 Aug 2014 21:01:55 -0700 (PDT)
Message-Id: <20140811.210155.356776804451079746.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Aug 2014 21:01:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull to get these Sparc bug fixes, one of which was preventing
successful SMP boots with mainline.

The following changes since commit 85417aef44fc58b08773117ceb1bc6ca5684e973:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/ide (2014-08-06 09:42:33 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to 8bccf5b313180faefce38e0d1140f76e0f327d28:

  sparc64: Fix pcr_ops initialization and usage bugs. (2014-08-11 20:45:12 -0700)

----------------------------------------------------------------
David S. Miller (3):
      sparc: Hook up seccomp and getrandom system calls.
      sparc64: Do not disable interrupts in nmi_cpu_busy()
      sparc64: Fix pcr_ops initialization and usage bugs.

Hans Wennborg (1):
      sparc: fix decimal printf format specifiers prefixed with 0x

 arch/sparc/include/uapi/asm/unistd.h | 4 +++-
 arch/sparc/kernel/nmi.c              | 1 -
 arch/sparc/kernel/perf_event.c       | 7 +++++--
 arch/sparc/kernel/process_64.c       | 3 +++
 arch/sparc/kernel/smp_32.c           | 2 +-
 arch/sparc/kernel/smp_64.c           | 1 -
 arch/sparc/kernel/systbls_32.S       | 2 +-
 arch/sparc/kernel/systbls_64.S       | 4 ++--
 8 files changed, 15 insertions(+), 9 deletions(-)
