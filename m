Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbaG1IaK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:30:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42838 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaG1IaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:30:08 -0400
Date: Mon, 28 Jul 2014 01:29:07 -0700
From: tip-bot for Masanari Iida <tipbot@zytor.com>
Message-ID: <tip-cd3bd4e628a6d57d66afe77835fe8d93ae3e41f8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, standby24x7@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, standby24x7@gmail.com
In-Reply-To: <1406518686-7274-1-git-send-email-standby24x7@gmail.com>
References: <1406518686-7274-1-git-send-email-standby24x7@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Fix 'make xmldocs'
  warning caused by missing description
Git-Commit-ID: cd3bd4e628a6d57d66afe77835fe8d93ae3e41f8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd3bd4e628a6d57d66afe77835fe8d93ae3e41f8
Gitweb:     http://git.kernel.org/tip/cd3bd4e628a6d57d66afe77835fe8d93ae3e41f8
Author:     Masanari Iida <standby24x7@gmail.com>
AuthorDate: Mon, 28 Jul 2014 12:38:06 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 28 Jul 2014 10:04:14 +0200

sched/fair: Fix 'make xmldocs' warning caused by missing description

This patch fix following warning caused by missing description
"overload" in kernel/sched/fair.c

Warning(.//kernel/sched/fair.c:5906): No description found for
parameter 'overload'

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1406518686-7274-1-git-send-email-standby24x7@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
