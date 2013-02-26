Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3BZLEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 06:04:10 -0500
Received: from multi.imgtec.com ([194.200.65.239]:58351 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab3BZLEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 06:04:08 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 0/5] metag: minor fixes after stuff in -next
Date: Tue, 26 Feb 2013 11:03:57 +0000
Message-ID: <1361876642-10247-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_26_11_04_07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few trivial fixes to arch/metag/. All except the first patch
depend on stuff in -next. Except arch/metag, only the last patch depends
on something not yet in mainline.

James Hogan (5):
  metag: Provide dma_get_sgtable()
  metag: remove GENERIC_SIGALTSTACK
  metag: remove select CONFIG_HAVE_IRQ_WORK
  metag: remove CONFIG_EXPERIMENTAL from defconfigs
  metag: remove unused ARCH_NO_VIRT_TO_BUS

 arch/metag/Kconfig                     | 5 -----
 arch/metag/configs/meta1_defconfig     | 1 -
 arch/metag/configs/meta2_defconfig     | 1 -
 arch/metag/configs/meta2_smp_defconfig | 1 -
 arch/metag/include/asm/dma-mapping.h   | 7 +++++++
 5 files changed, 7 insertions(+), 8 deletions(-)

-- 
1.8.1.2


