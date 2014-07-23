Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbaGWQhi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 12:37:38 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:13681 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756244AbaGWQhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 12:37:37 -0400
Date: Wed, 23 Jul 2014 17:37:18 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: [GIT PULL] arm64 fix for 3.16
Message-ID: <20140723163713.GA31311@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 patch below. Thanks.


The following changes since commit fa2ec3ea10bd377f9d55772b1dab65178425a1a2:

  arm64: implement TASK_SIZE_OF (2014-07-08 17:30:59 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-fixes

for you to fetch changes up to d50314a6b0702c630c35b88148c1acb76d2e4ede:

  arm64: Create non-empty ZONE_DMA when DRAM starts above 4GB (2014-07-23 11:23:58 +0100)

----------------------------------------------------------------
Fix arm64 regression introduced by limiting the CMA buffer to ZONE_DMA
on platforms where RAM starts above 4GB (and ZONE_DMA becoming 0).

----------------------------------------------------------------
Catalin Marinas (1):
      arm64: Create non-empty ZONE_DMA when DRAM starts above 4GB

 arch/arm64/mm/init.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)
