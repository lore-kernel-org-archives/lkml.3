Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaAFDzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 22:55:38 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18050 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbaAFDzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 22:55:36 -0500
From: Allen Pais <allen.pais@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: sparclinux@vger.kernel.org, davem@davemloft.net, bigeasy@linutronix.de,
        Allen Pais <allen.pais@oracle.com>
Subject: [PATCH 0/4] PREEMPT_RT support for sparc64
Date: Mon,  6 Jan 2014 09:25:06 +0530
Message-Id: <1388980510-10190-1-git-send-email-allen.pais@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have tested it on UltraSparc T4 (Niagara4). 

Allen Pais (4):
  sparc64: use generic rwsem spinlocks rt
  sparc64: allow forced irq threading
  sparc64: convert spinlock_t to raw_spinlock_t in mmu_context_t
  sparc64: convert ctx_alloc_lock raw_spinlock_t

 arch/sparc/Kconfig                      |    7 +++----
 arch/sparc/include/asm/mmu_64.h         |    2 +-
 arch/sparc/include/asm/mmu_context_64.h |   10 +++++-----
 arch/sparc/kernel/smp_64.c              |    4 ++--
 arch/sparc/mm/init_64.c                 |   14 +++++++-------
 arch/sparc/mm/tsb.c                     |   20 ++++++++++----------
 6 files changed, 28 insertions(+), 29 deletions(-)

-- 
1.7.10.4

