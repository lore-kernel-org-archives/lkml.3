Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaG1Dqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 23:46:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:57729 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbaG1Dqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 23:46:31 -0400
Message-ID: <1406519179.4935.37.camel@pasglop>
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Date: Mon, 28 Jul 2014 13:46:19 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are 3 more small powerpc fixes that should still go into .16.
One is a recent regression (MMCR2 business), the other is a trivial
endian fix without which FW updates won't work on LE in IBM machines,
and the 3rd one turns a BUG_ON into a WARN_ON which is definitely
a LOT more friendly especially when the whole thing is about retrieving
error logs ...

Cheers,
Ben.

The following changes since commit 6f5405bc2ee0102bb3856e2cdea64ff415db2e0c:

  powerpc: use _GLOBAL_TOC for memmove (2014-07-22 15:56:04 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

for you to fetch changes up to 396a34340cdf7373c00e3977db27d1a20ea65ebc:

  powerpc: Fix endianness of flash_block_list in rtas_flash (2014-07-28 11:30:54 +1000)

----------------------------------------------------------------
Michael Ellerman (1):
      powerpc/perf: Fix MMCR2 handling for EBB

Thomas Falcon (1):
      powerpc: Fix endianness of flash_block_list in rtas_flash

Vasant Hegde (1):
      powerpc/powernv: Change BUG_ON to WARN_ON in elog code

 arch/powerpc/kernel/rtas_flash.c           | 6 ++++--
 arch/powerpc/perf/core-book3s.c            | 6 +++---
 arch/powerpc/platforms/powernv/opal-elog.c | 4 ++--
 3 files changed, 9 insertions(+), 7 deletions(-)


