Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbaBROOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:14:39 -0500
Received: from service87.mimecast.com ([91.220.42.44]:51745 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbaBROOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:14:38 -0500
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] sched: Fix select_task_rq_fair() description comments
Date: Tue, 18 Feb 2014 14:14:24 +0000
Message-Id: <1392732864-10927-1-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 18 Feb 2014 14:14:38.0567 (UTC) FILETIME=[C22F1F70:01CF2CB3]
X-MC-Unique: 114021814143600801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s1IEEhoU025886

Brings select_task_rq_fair() description comments up-to-date.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 kernel/sched/fair.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 966cc2b..fde412b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4211,13 +4211,14 @@ done:
 }
 
 /*
- * sched_balance_self: balance the current task (running on cpu) in domains
- * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
- * SD_BALANCE_EXEC.
+ * select_task_rq_fair: Select target runqueue for the waking task in domains
+ * that have the 'sd_flag' flag set. In practice, this is SD_BALANCE_WAKE,
+ * SD_BALANCE_FORK, or SD_BALANCE_EXEC.
  *
- * Balance, ie. select the least loaded group.
+ * Balances load by selecting the idlest cpu in the idlest group, or under
+ * certain conditions an idle sibling cpu if the domain has SD_WAKE_AFFINE set.
  *
- * Returns the target CPU number, or the same CPU if no balancing is needed.
+ * Returns the target cpu number.
  *
  * preempt must be disabled.
  */
-- 
1.7.9.5


