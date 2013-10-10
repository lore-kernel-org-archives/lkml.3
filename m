Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab3JJK12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:27:28 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58557 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab3JJK11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:27:27 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: remove bogus parameter in structured comment
Date: Thu, 10 Oct 2013 15:50:33 +0530
Message-Id: <1381400433-2030-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The balance parameter was removed by 23f0d20 (sched: Factor out code to
should_we_balance(), 2013-08-06).

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 kernel/sched/fair.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7c70201..d127dfe 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4696,7 +4696,6 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 /**
  * update_sd_lb_stats - Update sched_domain's statistics for load balancing.
  * @env: The load balancing environment.
- * @balance: Should we balance.
  * @sds: variable to hold the statistics for this sched_domain.
  */
 static inline void update_sd_lb_stats(struct lb_env *env,
-- 
1.8.4.477.g5d89aa9

