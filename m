Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3AOSUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:20:30 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:47456 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756774Ab3AOSU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:20:29 -0500
Date: Tue, 15 Jan 2013 18:20:06 +0000
From: Catalin Marinas <Catalin.Marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arm64 fixes for 3.8
Message-ID: <20130115182005.GI2011@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
user-agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 fixes below. Thanks.

The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-fixes

for you to fetch changes up to 72d0ac048f3ded4022cf1cc72f54073f6fcad72f:

  arm64: compat: add syscall table entries for new syscalls (2013-01-15 17:15:16 +0000)

----------------------------------------------------------------
- Page protection fixes, including proper PAGE_NONE handling
- Timezone vdso sequence counting fix
- Additional compat syscall wiring

----------------------------------------------------------------
Will Deacon (4):
      arm64: vdso: remove broken, redundant sequence counting for timezones
      arm64: mm: only wrprotect clean ptes if they are present
      arm64: mm: introduce present, faulting entries for PAGE_NONE
      arm64: compat: add syscall table entries for new syscalls

 arch/arm64/include/asm/pgtable.h      | 36 +++++++++++++++++++----------------
 arch/arm64/include/asm/unistd32.h     |  7 ++++++-
 arch/arm64/kernel/vdso.c              |  4 ----
 arch/arm64/kernel/vdso/gettimeofday.S |  2 --
 4 files changed, 26 insertions(+), 23 deletions(-)
