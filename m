Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbbAWQon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 11:44:43 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:42068 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbbAWQol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 11:44:41 -0500
Date: Fri, 23 Jan 2015 16:44:32 +0000
From: Will Deacon <will.deacon@arm.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        catalin.marinas@arm.com, broonie@kernel.org, jungseoklee85@gmail.com
Subject: [GIT PULL] arm64: fixes for -rc6
Message-ID: <20150123164432.GA13772@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

arm64 fixes seem to come in pairs recently, so please pull these two for
-rc6. We've got a fix for removing device-tree blobs when doing a make
clean and another one addressing a missing include, which fixes build
failures in -next for allmodconfig (spotted by Mark's buildbot).

Hopefully, that's us done for 3.19.

Cheers,

Will

--->8

The following changes since commit ec6f34e5b552fb0a52e6aae1a5afbbb1605cc6cc:

  Linux 3.19-rc5 (2015-01-18 18:02:20 +1200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git tags/arm64-fixes

for you to fetch changes up to 284be28565efe262a81972d12e9264d4824a4ced:

  arm64: dump: Fix implicit inclusion of definition for PCI_IOBASE (2015-01-23 10:47:42 +0000)

----------------------------------------------------------------
arm64 fixes:
- Fix cleaning of .dtbs following directory restructuring
- Fix allmodconfig build breakage in -next due to missing include

----------------------------------------------------------------
Jungseok Lee (1):
      arm64: Add dtb files to archclean rule

Mark Brown (1):
      arm64: dump: Fix implicit inclusion of definition for PCI_IOBASE

 arch/arm64/Makefile          | 1 +
 arch/arm64/boot/dts/Makefile | 2 --
 arch/arm64/mm/dump.c         | 1 +
 3 files changed, 2 insertions(+), 2 deletions(-)
