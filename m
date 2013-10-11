Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab3JKGKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:10:38 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:55699 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab3JKGKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:10:37 -0400
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingn@redhat.com
Subject: [PATCH TRIVIAL] sched/fair: Remove description of balance from update_sd_lb_stats()
Date: Fri, 11 Oct 2013 11:40:31 +0530
Message-Id: <1381471831-17484-1-git-send-email-kamalesh@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.4.474.g128a96c
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101106-5564-0000-0000-00000A1D2E45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 23f0d2093c789 (sched: Factor out code to should_we_balance()),
we no longer pass balance as argument to update_sd_lb_stats().
So remove it's description.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 kernel/sched/fair.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 803e343d7c89..82746796578d 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5586,7 +5586,6 @@ static inline enum fbq_type fbq_classify_rq(struct rq *rq)
 /**
  * update_sd_lb_stats - Update sched_domain's statistics for load balancing.
  * @env: The load balancing environment.
- * @balance: Should we balance.
  * @sds: variable to hold the statistics for this sched_domain.
  */
 static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sds)
-- 
1.8.3.1

