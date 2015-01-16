Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbbAPRQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 12:16:54 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36410 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbbAPRQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 12:16:53 -0500
Date: Fri, 16 Jan 2015 17:16:48 +0000
From: Will Deacon <will.deacon@arm.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        catalin.marinas@arm.com
Subject: [GIT PULL] arm64: fixes for -rc5
Message-ID: <20150116171648.GC7091@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Just a couple of stragglers for arm64 here: wiring up compat_sys_execveat,
since arch/arm/ got that at -rc4 and a revert of a patch that broke our
handling of the device-tree blob with certain memory layouts.

Please pull.

Thanks,

Will

--->8

The following changes since commit eaa27f34e91a14cdceed26ed6c6793ec1d186115:

  linux 3.19-rc4 (2015-01-11 12:44:53 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git tags/arm64-fixes

for you to fetch changes up to 0145058c3d30b4319d747f64caa16a9cb15f0581:

  arm64: partially revert "ARM: 8167/1: extend the reserved memory for initrd to be page aligned" (2015-01-16 13:57:33 +0000)

----------------------------------------------------------------
arm64 fixes:
- Wire up compat_sys_execveat for compat (AArch32) tasks
- Revert 421520ba9829, as this breaks our side of the boot protocol

----------------------------------------------------------------
Catalin Marinas (1):
      arm64: partially revert "ARM: 8167/1: extend the reserved memory for initrd to be page aligned"

Will Deacon (1):
      arm64: compat: wire up compat_sys_execveat

 arch/arm64/include/asm/unistd.h   | 2 +-
 arch/arm64/include/asm/unistd32.h | 2 ++
 arch/arm64/mm/init.c              | 8 +-------
 3 files changed, 4 insertions(+), 8 deletions(-)
