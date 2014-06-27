Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaF0MTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:19:12 -0400
Received: from smtprelay.synopsys.com ([198.182.60.111]:56286 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaF0MTL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:19:11 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        Anton Kolesov <Anton.Kolesov@synopsys.com>,
        Paul Bolle <pebolle@tiscali.nl>, Noam Camus <noamc@ezchip.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>
Subject: [GIT PULL] ARC Fixes for 3.16
Thread-Topic: [GIT PULL] ARC Fixes for 3.16
Thread-Index: Ac+SAfyejMifW8rqQv2r+mLGIisGcg==
Date: Fri, 27 Jun 2014 12:19:05 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230751A6BA363@IN01WEMBXA.internal.synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull ARC fixes for 3.16

Thx,
-Vineet

------------------>
The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:

  Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vgupta/arc.git/
tags/arc-fixes-for-3.16

for you to fetch changes up to 2328af0c9ce89d3ec121ba832c4e6faeff9e70ac:

  ARC: [SMP] Enable icache coherency (2014-06-26 11:59:01 +0530)

----------------------------------------------------------------
ARC fixes for 3.16

Some SMP changes, a ptrace request for NPTL debugging,
bunch of build breakages/warnings

----------------------------------------------------------------
Anton Kolesov (1):
      ARC: Implement ptrace(PTRACE_GET_THREAD_AREA)

Noam Camus (1):
      ARC: [SMP] Fix IPI IRQ registration

Paul Bolle (1):
      ARC: remove checks for CONFIG_ARC_MMU_V4

Vineet Gupta (4):
      ARC: fix build warning in devtree
      ARC: Fix build breakage for !CONFIG_ARC_DW2_UNWIND
      ARC: optimize kernel bss clearing in early boot code
      ARC: [SMP] Enable icache coherency

 arch/arc/include/asm/cache.h       |  4 ++--
 arch/arc/include/uapi/asm/ptrace.h |  1 +
 arch/arc/kernel/ctx_sw_asm.S       |  2 +-
 arch/arc/kernel/devtree.c          |  2 +-
 arch/arc/kernel/head.S             |  7 ++++---
 arch/arc/kernel/ptrace.c           |  4 ++++
 arch/arc/kernel/smp.c              | 15 +++++++++++++--
 arch/arc/kernel/vmlinux.lds.S      |  2 +-
 arch/arc/mm/cache_arc700.c         | 25 +++++++++++++++++++------
 9 files changed, 46 insertions(+), 16 deletions(-)
