Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbaAaSFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 13:05:55 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:37010 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932170AbaAaSFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 13:05:54 -0500
Date: Fri, 31 Jan 2014 18:05:16 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] arm64 patches for 3.14
Message-ID: <20140131180510.GA20546@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 patches below. Thanks.


The following changes since commit 883c057367014d20a14b5054e4eb0d81ce3bea5c:

  arm64: fix typo in entry.S (2014-01-13 13:55:13 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-upstream

for you to fetch changes up to c2c93e5b7f3f42277ec25ff3746096abc0c0d0f7:

  arm64: mm: Introduce PTE_WRITE (2014-01-31 11:30:49 +0000)

----------------------------------------------------------------
- Build fix with DMA_CMA enabled
- Introduction of PTE_WRITE to distinguish between writable but clean
  and truly read-only pages
- FIQs enabling/disabling clean-up (they aren't used on arm64)
- CPU resume fix for the per-cpu offset restoring
- Code comment typos

----------------------------------------------------------------
Jingoo Han (3):
      arm64: mm: use ubfm for dcache_line_size
      arm64: mm: fix the function name in comment of __flush_dcache_area
      arm64: mm: fix the function name in comment of cpu_do_switch_mm

Lorenzo Pieralisi (1):
      arm64: kernel: fix per-cpu offset restore on resume

Nicolas Pitre (1):
      arm64: FIQs are unused

Pankaj Dubey (1):
      arm64: fix build error if DMA_CMA is enabled

Steve Capper (2):
      arm64: mm: Remove PTE_BIT_FUNC macro
      arm64: mm: Introduce PTE_WRITE

 arch/arm64/include/asm/dma-contiguous.h |  1 -
 arch/arm64/include/asm/pgtable.h        | 93 ++++++++++++++++++++++-----------
 arch/arm64/kernel/process.c             |  6 ---
 arch/arm64/kernel/smp.c                 |  2 -
 arch/arm64/kernel/suspend.c             |  8 +++
 arch/arm64/mm/cache.S                   |  2 +-
 arch/arm64/mm/proc-macros.S             |  3 +-
 arch/arm64/mm/proc.S                    |  2 +-
 8 files changed, 74 insertions(+), 43 deletions(-)

-- 
Catalin
