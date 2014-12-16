Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaLPRug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 12:50:36 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:50759 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaLPRuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 12:50:35 -0500
Date: Tue, 16 Dec 2014 17:50:19 +0000
From: Will Deacon <will.deacon@arm.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        catalin.marinas@arm.com
Subject: [GIT PULL] arm64: fixes for -rc1
Message-ID: <20141216175019.GC2260@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Given that my availability next week is likely to be poor, here are three
arm64 fixes to resolve some issues introduced by features merged last
week. I was going to wait until -rc1, but it doesn't make much sense to
sit on fixes. Please pull.

Thanks,

Will

--->8

The following changes since commit eb8a653137b7e74f7cdc01f814eb9d094a65aed9:

  arm64: remove the unnecessary arm64_swiotlb_init() (2014-12-05 12:19:52 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git tags/arm64-fixes

for you to fetch changes up to fb59d007a0e44e2304e4fc8cf5c20b6fda7890f3:

  arm64: mm: dump: don't skip final region (2014-12-11 12:08:07 +0000)

----------------------------------------------------------------
arm64 fixes:

Fix some fallout introduced during the merge window:
 - Build failure when PM_SLEEP is disabled but CPU_IDLE is enabled
 - Compiler warning from page table dumper w/ 48-bit VAs
 - Erroneous page table truncation in reported dump

----------------------------------------------------------------
Krzysztof Kozlowski (1):
      arm64: psci: Fix build breakage without PM_SLEEP

Mark Rutland (2):
      arm64: mm: dump: fix shift warning
      arm64: mm: dump: don't skip final region

 arch/arm64/kernel/psci.c | 2 ++
 arch/arm64/mm/dump.c     | 5 +----
 2 files changed, 3 insertions(+), 4 deletions(-)
