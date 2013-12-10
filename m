Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3LJJXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:23:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3LJJXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:23:21 -0500
Date: Tue, 10 Dec 2013 01:22:25 -0800
From: tip-bot for Wanpeng Li <tipbot@zytor.com>
Message-ID: <tip-40ea2b42d7c44386cf81d5636d574193da2c8df2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        liwanp@linux.vnet.ibm.com, peterz@infradead.org,
        n-horiguchi@ah.jp.nec.com, riel@redhat.com, mgorman@suse.de,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        liwanp@linux.vnet.ibm.com, peterz@infradead.org,
        n-horiguchi@ah.jp.nec.com, riel@redhat.com, mgorman@suse.de,
        tglx@linutronix.de
In-Reply-To: <1386241817-5051-2-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386241817-5051-2-git-send-email-liwanp@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa:
  Drop idx field of task_numa_env struct
Git-Commit-ID: 40ea2b42d7c44386cf81d5636d574193da2c8df2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:22:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  40ea2b42d7c44386cf81d5636d574193da2c8df2
Gitweb:     http://git.kernel.org/tip/40ea2b42d7c44386cf81d5636d574193da2c8df2
Author:     Wanpeng Li <liwanp@linux.vnet.ibm.com>
AuthorDate: Thu, 5 Dec 2013 19:10:17 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Dec 2013 13:38:36 +0100

sched/numa: Drop idx field of task_numa_env struct

Drop unused idx field of task_numa_env struct.

Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org
Link: http://lkml.kernel.org/r/1386241817-5051-2-git-send-email-liwanp@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a566c07..49aa01f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1037,7 +1037,7 @@ struct task_numa_env {
 
 	struct numa_stats src_stats, dst_stats;
 
-	int imbalance_pct, idx;
+	int imbalance_pct;
 
 	struct task_struct *best_task;
 	long best_imp;
