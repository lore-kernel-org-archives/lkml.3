Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbaB1Ipu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 03:45:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:44242 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859AbaB1Ipm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 03:45:42 -0500
Message-ID: <1393577130.22449.8.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Fri, 28 Feb 2014 19:45:30 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3-0ubuntu3~saucy1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few more powerpc fixes for 3.14. Most of these are also
CC'ed to stable and fix bugs in new functionality introduced in
the last 2 or 3 versions.

The following changes since commit 66f9af83e56bfa12964d251df9d60fb571579913:

  powerpc/eeh: Disable EEH on reboot (2014-02-17 11:19:39 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to e0cf957614976896111e676e5134ac98ee227d3d:

  powerpc/powernv: Fix indirect XSCOM unmangling (2014-02-28 19:15:49 +1100)

----------------------------------------------------------------
Benjamin Herrenschmidt (2):
      powerpc/powernv: Fix opal_xscom_{read,write} prototype
      powerpc/powernv: Fix indirect XSCOM unmangling

Gavin Shan (2):
      powerpc/powernv: Dump PHB diag-data immediately
      powerpc/powernv: Refactor PHB diag-data dump

Laurent Dufour (1):
      powerpc/crashdump : Fix page frame number check in copy_oldmem_page

Liu Ping Fan (1):
      powerpc/ftrace: bugfix for test_24bit_addr

Paul Mackerras (1):
      powerpc: Increase stack redzone for 64-bit userspace to 512 bytes

Tony Breeds (1):
      powerpc/le: Ensure that the 'stop-self' RTAS token is handled correctly

 arch/powerpc/include/asm/compat.h            |   5 +-
 arch/powerpc/include/asm/opal.h              |   4 +-
 arch/powerpc/include/asm/ptrace.h            |  16 +-
 arch/powerpc/kernel/crash_dump.c             |   8 +-
 arch/powerpc/kernel/ftrace.c                 |   1 +
 arch/powerpc/kernel/signal_64.c              |   4 +-
 arch/powerpc/platforms/powernv/eeh-ioda.c    |  96 ++++++------
 arch/powerpc/platforms/powernv/opal-xscom.c  |  21 +--
 arch/powerpc/platforms/powernv/pci.c         | 220 +++++++++++++++------------
 arch/powerpc/platforms/pseries/hotplug-cpu.c |  22 +--
 10 files changed, 219 insertions(+), 178 deletions(-)


