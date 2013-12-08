Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3LHGPL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 01:15:11 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:40531 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab3LHGPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 01:15:07 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 02/12] sched/numa: drop idx field of task_numa_env struct
Date: Sun,  8 Dec 2013 14:14:43 +0800
Message-Id: <1386483293-15354-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1386483293-15354-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386483293-15354-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120806-3864-0000-0000-00000B6C12FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop unused idx field of task_numa_env struct.

Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fd773ad..ea3fd1e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1037,7 +1037,7 @@ struct task_numa_env {
 
 	struct numa_stats src_stats, dst_stats;
 
-	int imbalance_pct, idx;
+	int imbalance_pct;
 
 	struct task_struct *best_task;
 	long best_imp;
-- 
1.7.5.4

