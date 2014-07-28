Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418AbaG1Di1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 23:38:27 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:55125 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaG1Di0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 23:38:26 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] sched/fair: Fix 'make xmldocs' warning caused by missing description
Date: Mon, 28 Jul 2014 12:38:06 +0900
Message-Id: <1406518686-7274-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix following warning caused by missing description
"overload" in kernel/sched/fair.c

Warning(.//kernel/sched/fair.c:5906): No description found for
parameter 'overload'

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 kernel/sched/fair.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 45943b2..bfa3c86 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5898,6 +5898,7 @@ static inline int sg_capacity_factor(struct lb_env *env, struct sched_group *gro
  * @load_idx: Load index of sched_domain of this_cpu for load calc.
  * @local_group: Does group contain this_cpu.
  * @sgs: variable to hold the statistics for this group.
+ * @overload: Indicate more than one runnable task for any CPU.
  */
 static inline void update_sg_lb_stats(struct lb_env *env,
 			struct sched_group *group, int load_idx,
-- 
2.1.0.rc0

