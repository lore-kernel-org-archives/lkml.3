Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759308Ab3BMMEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:04:47 -0500
Received: from multi.imgtec.com ([194.200.65.239]:55503 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754441Ab3BMMEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:04:46 -0500
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 0/5] metag: second set of misc patches for v3.9
Date: Wed, 13 Feb 2013 12:03:44 +0000
Message-ID: <1360757029-28868-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_02_13_12_04_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the second set of miscellaneous metag patches that I'll be
adding to the tip of the metag tree for v3.9.

James Hogan (5):
  metag: export metag_code_cache_flush_all
  metag: export clear_page and copy_page
  metag: hugetlb: convert to vm_unmapped_area()
  genksyms: fix metag symbol prefix on crc symbols
  metag: move irq enable out of irqflags.h on SMP

 arch/metag/include/asm/irqflags.h |   11 +++----
 arch/metag/kernel/metag_ksyms.c   |    2 +
 arch/metag/kernel/traps.c         |   15 ++++++++++-
 arch/metag/mm/cache.c             |    1 +
 arch/metag/mm/hugetlbpage.c       |   52 +++++++-----------------------------
 scripts/genksyms/genksyms.c       |    3 +-
 6 files changed, 34 insertions(+), 50 deletions(-)

-- 
1.7.7.6


