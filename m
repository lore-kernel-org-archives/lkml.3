Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3CONzO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:55:14 -0400
Received: from multi.imgtec.com ([194.200.65.239]:35783 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410Ab3CONzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:55:12 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 0/3] metag: smp / cache changes
Date: Fri, 15 Mar 2013 13:55:00 +0000
Message-ID: <1363355703-23654-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_15_13_55_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are a few Meta SMP and cache changes I have for v3.10. The first
one removes the need to have an SMP specific bootloader to configure the
cache partitions and coherency for the hardware threads that will run
SMP, and the other two are very minor fixes.

James Hogan (3):
  metag: smp: copy cache partition and enable GCOn
  metag: cachepart: take into account small cache bits
  metag: cachepart: fix get_global_dcache_size() typo

 arch/metag/include/asm/metag_mem.h |   3 +
 arch/metag/kernel/cachepart.c      |  16 ++++--
 arch/metag/kernel/head.S           |   8 +++
 arch/metag/kernel/smp.c            | 115 +++++++++++++++++++++++++++++++++++++
 4 files changed, 137 insertions(+), 5 deletions(-)

-- 
1.8.1.2


