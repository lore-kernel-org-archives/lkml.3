Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933270Ab3HGPAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:00:44 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:60311 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757607Ab3HGO6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 10:58:46 -0400
Message-ID: <201308071458.r77Ewk2R013093@farm-0012.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Wed, 7 Aug 2013 10:34:10 -0400
Subject: [PATCH] tile: remove unnecessary backslashes in asm-offsets.c
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pointed out by checkpatch.  A few of the DEFINE() lines were
properly written without backslash continuation; fix the rest.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/asm-offsets.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/arch/tile/kernel/asm-offsets.c b/arch/tile/kernel/asm-offsets.c
index 01ddf19..8fff475 100644
--- a/arch/tile/kernel/asm-offsets.c
+++ b/arch/tile/kernel/asm-offsets.c
@@ -37,28 +37,28 @@
 
 void foo(void)
 {
-	DEFINE(SINGLESTEP_STATE_BUFFER_OFFSET, \
+	DEFINE(SINGLESTEP_STATE_BUFFER_OFFSET,
 	       offsetof(struct single_step_state, buffer));
-	DEFINE(SINGLESTEP_STATE_FLAGS_OFFSET, \
+	DEFINE(SINGLESTEP_STATE_FLAGS_OFFSET,
 	       offsetof(struct single_step_state, flags));
-	DEFINE(SINGLESTEP_STATE_ORIG_PC_OFFSET, \
+	DEFINE(SINGLESTEP_STATE_ORIG_PC_OFFSET,
 	       offsetof(struct single_step_state, orig_pc));
-	DEFINE(SINGLESTEP_STATE_NEXT_PC_OFFSET, \
+	DEFINE(SINGLESTEP_STATE_NEXT_PC_OFFSET,
 	       offsetof(struct single_step_state, next_pc));
-	DEFINE(SINGLESTEP_STATE_BRANCH_NEXT_PC_OFFSET, \
+	DEFINE(SINGLESTEP_STATE_BRANCH_NEXT_PC_OFFSET,
 	       offsetof(struct single_step_state, branch_next_pc));
-	DEFINE(SINGLESTEP_STATE_UPDATE_VALUE_OFFSET, \
+	DEFINE(SINGLESTEP_STATE_UPDATE_VALUE_OFFSET,
 	       offsetof(struct single_step_state, update_value));
 
-	DEFINE(THREAD_INFO_TASK_OFFSET, \
+	DEFINE(THREAD_INFO_TASK_OFFSET,
 	       offsetof(struct thread_info, task));
-	DEFINE(THREAD_INFO_FLAGS_OFFSET, \
+	DEFINE(THREAD_INFO_FLAGS_OFFSET,
 	       offsetof(struct thread_info, flags));
-	DEFINE(THREAD_INFO_STATUS_OFFSET, \
+	DEFINE(THREAD_INFO_STATUS_OFFSET,
 	       offsetof(struct thread_info, status));
-	DEFINE(THREAD_INFO_HOMECACHE_CPU_OFFSET, \
+	DEFINE(THREAD_INFO_HOMECACHE_CPU_OFFSET,
 	       offsetof(struct thread_info, homecache_cpu));
-	DEFINE(THREAD_INFO_STEP_STATE_OFFSET, \
+	DEFINE(THREAD_INFO_STEP_STATE_OFFSET,
 	       offsetof(struct thread_info, step_state));
 
 	DEFINE(TASK_STRUCT_THREAD_KSP_OFFSET,
@@ -66,11 +66,11 @@ void foo(void)
 	DEFINE(TASK_STRUCT_THREAD_PC_OFFSET,
 	       offsetof(struct task_struct, thread.pc));
 
-	DEFINE(HV_TOPOLOGY_WIDTH_OFFSET, \
+	DEFINE(HV_TOPOLOGY_WIDTH_OFFSET,
 	       offsetof(HV_Topology, width));
-	DEFINE(HV_TOPOLOGY_HEIGHT_OFFSET, \
+	DEFINE(HV_TOPOLOGY_HEIGHT_OFFSET,
 	       offsetof(HV_Topology, height));
 
-	DEFINE(IRQ_CPUSTAT_SYSCALL_COUNT_OFFSET, \
+	DEFINE(IRQ_CPUSTAT_SYSCALL_COUNT_OFFSET,
 	       offsetof(irq_cpustat_t, irq_syscall_count));
 }
-- 
1.8.3.1

