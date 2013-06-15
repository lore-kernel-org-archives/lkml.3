Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab3FODLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 23:11:14 -0400
Received: from gate.crashing.org ([63.228.1.57]:53948 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab3FODLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 23:11:13 -0400
Message-ID: <1371265846.21896.29.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Sat, 15 Jun 2013 13:10:46 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Hopefully this one smells better ...

So here are 3 fixes still for 3.10. Fixes are simple, bugs are nasty
(though not recent regressions, nasty enough) and all targeted at
stable. Please apply.

Thanks !

Cheers,
Ben.

The following changes since commit 34376a50fb1fa095b9d0636fa41ed2e73125f214:

  Fix lockup related to stop_machine being stuck in __do_softirq. (2013-06-10 17:46:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 230b3034793247f61e6a0b08c44cf415f6d92981:

  powerpc: Fix missing/delayed calls to irq_work (2013-06-15 12:33:30 +1000)

----------------------------------------------------------------
Benjamin Herrenschmidt (1):
      powerpc: Fix missing/delayed calls to irq_work

Michael Ellerman (1):
      powerpc: Fix stack overflow crash in resume_kernel when ftracing

Paul Mackerras (1):
      powerpc: Fix emulation of illegal instructions on PowerNV platform

 arch/powerpc/include/asm/exception-64s.h |    2 +-
 arch/powerpc/kernel/exceptions-64s.S     |    2 +-
 arch/powerpc/kernel/irq.c                |    2 +-
 arch/powerpc/kernel/process.c            |    4 ++--
 arch/powerpc/kernel/traps.c              |   10 ++++++++++
 5 files changed, 15 insertions(+), 5 deletions(-)


