Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3JMRwj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 13:52:39 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:33420 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3JMRwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 13:52:38 -0400
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, peterz@infradead.org
Subject: [PATCH TRIVIAL] sched/fair: Fix a typo in comments of sg_imbalanced()
Date: Sun, 13 Oct 2013 23:22:30 +0530
Message-Id: <1381686750-3951-1-git-send-email-kamalesh@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101317-8878-0000-0000-0000093A20D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

calculcate_imbalance should be calculate_imbalance in the
comments of sg_imbalanced().

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b234b869470f..e24d238cb8cf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5412,7 +5412,7 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
  * moving tasks due to affinity constraints.
  *
  * When this is so detected; this group becomes a candidate for busiest; see
- * update_sd_pick_busiest(). And calculcate_imbalance() and
+ * update_sd_pick_busiest(). And calculate_imbalance() and
  * find_busiest_group() avoid some of the usual balance conditions to allow it
  * to create an effective group imbalance.
  *
-- 
1.8.4.474.g128a96c

