Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab3C1NAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 09:00:05 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:45700 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754922Ab3C1NAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 09:00:04 -0400
Date: Thu, 28 Mar 2013 12:59:59 +0000
From: Catalin Marinas <Catalin.Marinas@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arm64 patches for 3.9
Message-ID: <20130328125959.GC24039@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
user-agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the arm64 fix below. Thanks.

The following changes since commit a937536b868b8369b98967929045f1df54234323:

  Linux 3.9-rc3 (2013-03-17 15:59:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cmarinas/linux-aarch64.git tags/arm64-fixes

for you to fetch changes up to d17cfb34dc5eb527b98448f3999aac52311d438b:

  ARM64: early_printk: Fix check for CONFIG_ARM64_64K_PAGES (2013-03-25 17:59:57 +0000)

----------------------------------------------------------------
Fix IS_ENABLED() usage typo (missing CONFIG_ prefix).

----------------------------------------------------------------
Ben Hutchings (1):
      ARM64: early_printk: Fix check for CONFIG_ARM64_64K_PAGES

 arch/arm64/mm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
