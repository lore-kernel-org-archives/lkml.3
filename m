Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaA2IvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 03:51:07 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:49634 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaA2IvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 03:51:03 -0500
Date: Wed, 29 Jan 2014 00:51:02 -0800 (PST)
Message-Id: <20140129.005102.504048866066889878.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two cleanups from Paul Gortmaker and hook up the new scheduler
system calls.

Please pull, thanks a lot!

The following changes since commit 0e47c969c65e213421450c31043353ebe3c67e0c:

  Merge tag 'for-linus-20140127' of git://git.infradead.org/linux-mtd (2014-01-28 18:56:37 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to a54983ae64b12cf7e098c464c7eaf058752bc9cc:

  sparc: Hook up sched_setattr and sched_getattr syscalls. (2014-01-29 00:45:06 -0800)

----------------------------------------------------------------
David S. Miller (1):
      sparc: Hook up sched_setattr and sched_getattr syscalls.

Paul Gortmaker (2):
      sparc: delete non-required instances of include <linux/init.h>
      sparc: don't use module_init in non-modular pci.c code

 arch/sparc/include/uapi/asm/unistd.h | 4 +++-
 arch/sparc/kernel/cpumap.c           | 1 -
 arch/sparc/kernel/ebus.c             | 1 -
 arch/sparc/kernel/hvtramp.S          | 1 -
 arch/sparc/kernel/of_device_common.c | 1 -
 arch/sparc/kernel/pci.c              | 3 +--
 arch/sparc/kernel/pci_common.c       | 1 -
 arch/sparc/kernel/process_32.c       | 1 -
 arch/sparc/kernel/sparc_ksyms_32.c   | 1 -
 arch/sparc/kernel/sparc_ksyms_64.c   | 1 -
 arch/sparc/kernel/systbls_32.S       | 2 +-
 arch/sparc/kernel/systbls_64.S       | 4 ++--
 arch/sparc/kernel/trampoline_32.S    | 1 -
 arch/sparc/kernel/trampoline_64.S    | 1 -
 arch/sparc/mm/hugetlbpage.c          | 1 -
 arch/sparc/mm/tlb.c                  | 1 -
 arch/sparc/prom/p1275.c              | 1 -
 drivers/sbus/char/bbc_i2c.c          | 1 -
 drivers/sbus/char/display7seg.c      | 1 -
 drivers/sbus/char/envctrl.c          | 1 -
 drivers/sbus/char/flash.c            | 1 -
 drivers/sbus/char/uctrl.c            | 1 -
 22 files changed, 7 insertions(+), 24 deletions(-)
