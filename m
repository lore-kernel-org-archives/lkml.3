Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab3L3EiE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 23:38:04 -0500
Received: from gate.crashing.org ([63.228.1.57]:54148 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540Ab3L3EiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 23:38:02 -0500
Message-ID: <1388378259.4373.30.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 30 Dec 2013 15:37:39 +1100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are a few more powerpc fixes for 3.13. A bit more endian
problems found during testing of 3.13 and a few other simple fixes
and regressions fixes.

Cheers,
Ben.

The following changes since commit 803c2d2f84da9dc2619449994af34d27148ab20d:

  powerpc/powernv: Fix OPAL LPC access in Little Endian (2013-12-13 15:55:15 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to f991db1cf1bdca43675b5d2df0af991719727029:

  Merge remote-tracking branch 'agust/merge' into merge (2013-12-30 14:48:27 +1100)

----------------------------------------------------------------

Anton Blanchard (1):
      powerpc: Align p_end

Brian W Hart (2):
      powernv/eeh: Fix possible buffer overrun in ioda_eeh_phb_diag()
      powernv/eeh: Add buffer for P7IOC hub error data

Gerhard Sittig (1):
      powerpc/512x: dts: remove misplaced IRQ spec from 'soc' node (5125)

Matteo Facchinetti (1):
      powerpc/512x: dts: disable MPC5125 usb module

Michael Neuling (1):
      powerpc: Fix bad stack check in exception entry

Olof Johansson (1):
      powerpc: Fix alignment of secondary cpu spin vars

Paul E. McKenney (1):
      powerpc: Make 64-bit non-VMX __copy_tofrom_user bi-endian

Rajesh B Prathipati (1):
      powerpc: Make unaligned accesses endian-safe for powerpc

 arch/powerpc/boot/dts/mpc5125twr.dts      |  6 +++-
 arch/powerpc/include/asm/exception-64s.h  |  2 +-
 arch/powerpc/include/asm/unaligned.h      |  7 +++-
 arch/powerpc/kernel/head_64.S             |  2 ++
 arch/powerpc/lib/copyuser_64.S            | 53 ++++++++++++++++++++++---------
 arch/powerpc/platforms/powernv/eeh-ioda.c | 20 +++---------
 arch/powerpc/platforms/powernv/pci.h      |  4 ++-
 7 files changed, 60 insertions(+), 34 deletions(-)


