Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3L0Llg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 06:41:36 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:37018 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab3L0Lle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 06:41:34 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 4/5] sched, fair: fix the comment of select_task_rq_fair()
Date: Fri, 27 Dec 2013 19:41:03 +0800
Message-Id: <1388144464-28458-5-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1388144464-28458-1-git-send-email-zwu.kernel@gmail.com>
References: <1388144464-28458-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122711-6688-0000-0000-000004F53A45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index db23d71..eaa1e91 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4218,7 +4218,7 @@ done:
 }
 
 /*
- * sched_balance_self: balance the current task (running on cpu) in domains
+ * select_task_rq_fair: balance the current task (running on cpu) in domains
  * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
  * SD_BALANCE_EXEC.
  *
-- 
1.7.6.5

