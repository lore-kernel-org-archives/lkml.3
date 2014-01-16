Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaAPS4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:56:14 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:11186 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751071AbaAPS4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:56:10 -0500
Date: Thu, 16 Jan 2014 18:55:39 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 revert for 3.13
Message-ID: <20140116185533.GA16442@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

If there's still time for 3.13, could you please pull the one-line
revert below? We noticed that it breaks ioremap (and earlyprintk) with
64K page configuration. Thanks.

The following changes since commit cdc27c27843248ae7eb0df5fc261dd004eaa5670:

  arm64: ptrace: avoid using HW_BREAKPOINT_EMPTY for disabled events (2013-12-19 17:41:25 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-fixes

for you to fetch changes up to 4ce00dfcf19c473f3dbf23d5b1372639f0c334f6:

  Revert "arm64: Fix memory shareability attribute for ioremap_wc/cache" (2014-01-16 18:32:25 +0000)

----------------------------------------------------------------
Revert "arm64: Fix memory shareability attribute for ioremap_wc/cache"

----------------------------------------------------------------
Catalin Marinas (1):
      Revert "arm64: Fix memory shareability attribute for ioremap_wc/cache"

 arch/arm64/include/asm/io.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
