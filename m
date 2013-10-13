Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab3JMRgX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 13:36:23 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:44466 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754624Ab3JMRgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 13:36:22 -0400
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, peterz@infradead.org
Subject: [PATCH TRIVIAL] sched/fair: Fix a typo in comments of get_sd_load_idx()
Date: Sun, 13 Oct 2013 23:06:15 +0530
Message-Id: <1381685775-3544-1-git-send-email-kamalesh@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101317-5490-0000-0000-0000044DE2F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a trival typo in description of idle in comments of
get_sd_load_idx().

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 82746796578d..b234b869470f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5206,7 +5206,7 @@ static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
 /**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
- * @idle: The Idle status of the CPU for whose sd load_icx is obtained.
+ * @idle: The Idle status of the CPU for whose sd load_idx is obtained.
  *
  * Return: The load index.
  */
-- 
1.8.4.474.g128a96c

