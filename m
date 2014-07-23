Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041AbaGWEyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 00:54:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:47380 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbaGWEyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 00:54:49 -0400
Message-ID: <1406091277.22200.44.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Wed, 23 Jul 2014 14:54:37 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here is a handful of powerpc fixes for 3.16. They are all pretty
simple and self contained and should still make this release.

Cheers,
Ben.

The following changes since commit f56029410a13cae3652d1f34788045c40a13ffc7:

  powerpc/perf: Never program book3s PMCs with values >= 0x80000000 (2014-07-11 13:50:47 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 6f5405bc2ee0102bb3856e2cdea64ff415db2e0c:

  powerpc: use _GLOBAL_TOC for memmove (2014-07-22 15:56:04 +1000)

----------------------------------------------------------------
Aneesh Kumar K.V (1):
      powerpc: subpage_protect: Increase the array size to take care of 64TB

Joel Stanley (1):
      powerpc: Disable doorbells on Power8 DD1.x

Li Zhong (1):
      powerpc: use _GLOBAL_TOC for memmove

Paul Mackerras (1):
      powerpc: Fix bugs in emulate_step()

Tyrel Datwyler (1):
      powerpc/pseries: dynamically added OF nodes need to call of_node_init

 arch/powerpc/include/asm/cputable.h       |  1 +
 arch/powerpc/include/asm/mmu-hash64.h     |  3 ++-
 arch/powerpc/kernel/cputable.c            | 20 ++++++++++++++++++++
 arch/powerpc/lib/mem_64.S                 |  2 +-
 arch/powerpc/lib/sstep.c                  | 10 +++++-----
 arch/powerpc/platforms/pseries/dlpar.c    |  1 +
 arch/powerpc/platforms/pseries/reconfig.c |  1 +
 7 files changed, 31 insertions(+), 7 deletions(-)


