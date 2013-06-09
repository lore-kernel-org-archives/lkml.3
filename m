Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179Ab3FIWp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 18:45:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:48269 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab3FIWpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 18:45:54 -0400
Message-ID: <1370817945.14883.40.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 10 Jun 2013 08:45:45 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here's the previous pull request with a couple of commits removed,
this is purely regressions (though not all recent ones) or stable
material.

Cheers,
Ben.


The following changes since commit 1612e111e4e565422242727efb59499cce8738e4:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-06-06 18:09:05 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to b11ae95100f7061b39a15e5c1ecbf862464ac4b4:

  powerpc: Partial revert of "Context switch more PMU related SPRs" (2013-06-10 08:36:35 +1000)

----------------------------------------------------------------
Gavin Shan (1):
      powerpc/eeh: Don't check RTAS token to get PE addr

Kevin Hao (1):
      powerpc/pci: Check the bus address instead of resource address in pcibios_fixup_resources

Michael Ellerman (2):
      powerpc/perf: Fix deadlock caused by calling printk() in PMU exception
      powerpc: Partial revert of "Context switch more PMU related SPRs"

Michael Neuling (4):
      powerpc/power8: Fix oprofile and perf
      powerpc/pseries: Simplify denormalization handler
      powerpc/power8: Update denormalization handler
      powerpc/hw_breakpoints: Add DABRX cpu feature to fix 32-bit regression

 arch/powerpc/include/asm/cputable.h          |   17 +++--
 arch/powerpc/kernel/cputable.c               |    8 +--
 arch/powerpc/kernel/entry_64.S               |   28 --------
 arch/powerpc/kernel/exceptions-64s.S         |   90 ++++++++------------------
 arch/powerpc/kernel/pci-common.c             |    4 +-
 arch/powerpc/kernel/process.c                |    3 +-
 arch/powerpc/perf/core-book3s.c              |    2 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c |   12 ++--
 8 files changed, 51 insertions(+), 113 deletions(-)


