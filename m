Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab3EaP03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:26:29 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:48959 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752859Ab3EaP0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:26:23 -0400
Date: Fri, 31 May 2013 16:25:39 +0100
From: Catalin Marinas <Catalin.Marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arm64 fixes for 3.10
Message-ID: <20130531152539.GE15551@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
user-agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 patches below. Thanks.

The following changes since commit c7788792a5e7b0d5d7f96d0766b4cb6112d47d75:

  Linux 3.10-rc2 (2013-05-20 14:37:38 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-stable

for you to fetch changes up to 9955ac47f4ba1c95ecb6092aeaefb40a22e99268:

  arm64: don't kill the kernel on a bad esr from el0 (2013-05-31 16:04:51 +0100)

----------------------------------------------------------------
- Module compilation issues (symbol not exported).
- Plug a hole where user space can bring the kernel down.

----------------------------------------------------------------
Catalin Marinas (1):
      arm64: Do not report user faults for handled signals

Chen Gang (1):
      arm64: kernel: compiling issue, need 'EXPORT_SYMBOL(clear_page)'

Mark Rutland (2):
      arm64: treat unhandled compat el0 traps as undef
      arm64: don't kill the kernel on a bad esr from el0

 arch/arm64/kernel/arm64ksyms.c |  1 +
 arch/arm64/kernel/entry.S      | 10 ++++++++++
 arch/arm64/kernel/traps.c      | 17 ++++++++++++-----
 arch/arm64/mm/fault.c          |  3 ++-
 4 files changed, 25 insertions(+), 6 deletions(-)
