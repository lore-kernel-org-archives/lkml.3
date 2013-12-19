Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3LSSdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:33:31 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:51556 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754392Ab3LSSd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:33:29 -0500
Date: Thu, 19 Dec 2013 18:33:08 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] arm64 ptrace fix for 3.13
Message-ID: <20131219183303.GA12876@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 patch below. Thanks.


The following changes since commit 319e2e3f63c348a9b66db4667efa73178e18b17d:

  Linux 3.13-rc4 (2013-12-15 12:31:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux tags/arm64-fixes

for you to fetch changes up to cdc27c27843248ae7eb0df5fc261dd004eaa5670:

  arm64: ptrace: avoid using HW_BREAKPOINT_EMPTY for disabled events (2013-12-19 17:41:25 +0000)

----------------------------------------------------------------
- arm64 ptrace fix.

----------------------------------------------------------------
Will Deacon (1):
      arm64: ptrace: avoid using HW_BREAKPOINT_EMPTY for disabled events

 arch/arm64/kernel/ptrace.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

-- 
Catalin
