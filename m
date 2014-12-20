Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaLTBbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 20:31:25 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46677 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbaLTBbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 20:31:24 -0500
Date: Fri, 19 Dec 2014 19:31:17 -0600
From: rkuo <rkuo@codeaurora.org>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-hexagon@vger.kernel.org
Subject: [GIT PULL] Hexagon changes for v3.19
Message-ID: <20141220013117.GC21871@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for the Hexagon architecture.  It
includes build cleanup and a few misc fixes.

Thanks,
Richard Kuo


The following changes since commit b2776bf7149bddd1f4161f14f79520f17fc1d71d:

  Linux 3.18 (2014-12-07 14:21:05 -0800)

are available in the git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/rkuo/linux-hexagon-kernel.git for-linus

for you to fetch changes up to 8914d7e857807e1e60975000cba3750c9b2643e8:

  Hexagon: fix signal delivery for debug traps (2014-12-16 13:27:39 -0600)

----------------------------------------------------------------
Guenter Roeck (1):
      hexagon: Fix build failures in linux-next

Richard Kuo (3):
      Hexagon: fix alignment of init_task in RW_DATA_SECTION
      Hexagon: set ARCH_DMA_MINALIGN
      Hexagon: fix signal delivery for debug traps

 arch/hexagon/include/asm/cache.h      |  4 +++-
 arch/hexagon/include/asm/cacheflush.h | 36 ++++++++++++++++++-----------------
 arch/hexagon/include/asm/io.h         |  5 -----
 arch/hexagon/kernel/setup.c           |  1 +
 arch/hexagon/kernel/traps.c           |  4 ++--
 arch/hexagon/kernel/vmlinux.lds.S     |  4 ++--
 arch/hexagon/mm/cache.c               | 10 ++++++++++
 arch/hexagon/mm/ioremap.c             |  1 +
 8 files changed, 38 insertions(+), 27 deletions(-)


-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, 
a Linux Foundation Collaborative Project
