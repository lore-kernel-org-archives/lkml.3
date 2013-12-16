Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab3LPEH6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 23:07:58 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23109 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab3LPEH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 23:07:56 -0500
From: Allen Pais <allen.pais@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: sparclinux@vger.kernel.org, bigeasy@linutronix.de,
        Allen Pais <allen.pais@oracle.com>
Subject: [PATCH 0/3]  PREEMPT_RT support for Sparc64
Date: Mon, 16 Dec 2013 09:37:30 +0530
Message-Id: <1387166853-10782-1-git-send-email-allen.pais@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PREEMPT_RT support for Sparc64. 
I have tested it on UltraSparc T4 (Niagara4).

Allen Pais (3):
  sparc64: use generic rwsem spinlocks rt
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

