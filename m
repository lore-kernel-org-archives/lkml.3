Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab3LJJ3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:29:24 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:38658 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3LJJTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:19:49 -0500
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v4 02/12] sched/numa: drop idx field of task_numa_env struct
Date: Tue, 10 Dec 2013 17:19:25 +0800
Message-Id: <1386667175-19952-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1386667175-19952-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386667175-19952-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121009-5490-0000-0000-000004A02948
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
1.7.7.6

