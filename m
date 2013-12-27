Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3L0Lla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 06:41:30 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53582 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab3L0Ll1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 06:41:27 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 2/5] sched, fair: fix the comment of move_tasks()
Date: Fri, 27 Dec 2013 19:41:01 +0800
Message-Id: <1388144464-28458-3-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1388144464-28458-1-git-send-email-zwu.kernel@gmail.com>
References: <1388144464-28458-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122711-5806-0000-0000-000023BFABB9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c7395d9..a82ae0a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4982,7 +4982,7 @@ static const unsigned int sched_nr_migrate_break = 32;
 /*
  * move_tasks tries to move up to imbalance weighted load from busiest to
  * this_rq, as part of a balancing operation within domain "sd".
- * Returns 1 if successful and 0 otherwise.
+ * Returns the number of moved tasks if successful and 0 otherwise.
  *
  * Called with both runqueues locked.
  */
-- 
1.7.6.5

