Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387Ab3GZP4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:56:03 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50189 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759310Ab3GZP4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:56:00 -0400
Date: Fri, 26 Jul 2013 16:55:20 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] arm64 fixes for 3.11
Message-ID: <20130726155458.GA31613@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 fixes below. Thanks.


The following changes since commit 3b2f64d00c46e1e4e9bd0bb9bb12619adac27a4b:

  Linux 3.11-rc2 (2013-07-21 12:05:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-stable

for you to fetch changes up to 845ad05ec31e0f3872a321e10dbeaf872022632c:

  arm64: Change kernel stack size to 16K (2013-07-26 13:37:29 +0100)

----------------------------------------------------------------
- Stack size increased to 16K (similar to other 64-bit architectures)
- Additional cache flushing for secondary CPUs boot mode

----------------------------------------------------------------
Catalin Marinas (1):
      arm64: Fix definition of arm_pm_restart to match the declaration

Feng Kan (1):
      arm64: Change kernel stack size to 16K

Mark Rutland (1):
      arm64: virt: ensure visibility of __boot_cpu_mode

 arch/arm64/include/asm/thread_info.h |  4 ++--
 arch/arm64/include/asm/virt.h        | 13 +++++++++++++
 arch/arm64/kernel/entry.S            |  2 +-
 arch/arm64/kernel/process.c          |  2 +-
 4 files changed, 17 insertions(+), 4 deletions(-)

-- 
Catalin
