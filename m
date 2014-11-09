Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaKIJok (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 04:44:40 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:55096 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaKIJoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 04:44:38 -0500
Date: Sun, 9 Nov 2014 09:44:30 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [GIT PULL] arm64 fixes for 3.18
Message-ID: <20141109094422.GA14540@e104818-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 fixes below. Thanks.

The following changes since commit 3dec0fe48a8936528aae2fc3f904c2c9a34ba368:

  arm64: Fix memblock current_limit with 64K pages and 48-bit VA (2014-10-24 18:16:47 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-fixes

for you to fetch changes up to 2d39ad649eca1e8a993f4fda244fe17ecea7a38d:

  arm64: defconfig: update defconfig for 3.18 (2014-11-05 17:07:58 +0000)

----------------------------------------------------------------
arm64 fixes:

- enable bpf syscall for compat
- cpu_suspend fix when checking the idle state type
- defconfig update

----------------------------------------------------------------
Amit Daniel Kachhap (1):
      arm64: psci: fix cpu_suspend to check idle state type for index

Catalin Marinas (1):
      arm64: compat: Enable bpf syscall

Will Deacon (1):
      arm64: defconfig: update defconfig for 3.18

 arch/arm64/configs/defconfig      | 26 ++++++++++++++++++++++++--
 arch/arm64/include/asm/unistd32.h |  2 ++
 arch/arm64/kernel/psci.c          |  2 +-
 3 files changed, 27 insertions(+), 3 deletions(-)

-- 
Catalin
