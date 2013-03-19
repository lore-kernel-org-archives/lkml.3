Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933660Ab3CSSUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 14:20:00 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:47341 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933258Ab3CSST7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 14:19:59 -0400
Date: Tue, 19 Mar 2013 18:19:40 +0000
From: Catalin Marinas <Catalin.Marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arm64 patches for 3.9
Message-ID: <20130319181939.GD9321@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
user-agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 fixes below. Thanks.

The following changes since commit a937536b868b8369b98967929045f1df54234323:

  Linux 3.9-rc3 (2013-03-17 15:59:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-fixes

for you to fetch changes up to 792072066d30372772137be9ee2f4d72d77329f9:

  arm64: Kconfig.debug: Remove unused CONFIG_DEBUG_ERRORS (2013-03-19 16:19:19 +0000)

----------------------------------------------------------------
- Fix !SMP build error.
- Fix padding computation in struct ucontext (no ABI change).
- Minor clean-up after the signal patches (unused var).
- Two old Kconfig options clean-up.

----------------------------------------------------------------
Andreas Schwab (1):
      arm64: fix padding computation in struct ucontext

Catalin Marinas (2):
      arm64: Removed unused variable in compat_setup_rt_frame()
      arm64: Fix build error with !SMP

Paul Bolle (2):
      arm64: Do not select GENERIC_HARDIRQS_NO_DEPRECATED
      arm64: Kconfig.debug: Remove unused CONFIG_DEBUG_ERRORS

 arch/arm64/Kconfig                |  1 -
 arch/arm64/Kconfig.debug          | 11 -----------
 arch/arm64/configs/defconfig      |  1 -
 arch/arm64/include/asm/ucontext.h |  2 +-
 arch/arm64/kernel/arm64ksyms.c    |  2 ++
 arch/arm64/kernel/signal32.c      |  1 -
 6 files changed, 3 insertions(+), 15 deletions(-)
