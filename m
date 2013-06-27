Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3F0Fy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 01:54:27 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:37580 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab3F0FyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 01:54:25 -0400
Date: Thu, 27 Jun 2013 11:24:18 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@kernel.org, kamalesh@linux.vnet.ibm.com
Subject: [PATCH TRIVIAL] sched/fair: Fix typo describing flags in
 enqueue_entity
Message-ID: <20130627055418.GA18582@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062705-8256-0000-0000-00000819651E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix spelling of 'calling' in description of se flags in enqueue_entity().

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c0ac2c3..04517bb 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1730,7 +1730,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
 	/*
 	 * Update the normalized vruntime before updating min_vruntime
-	 * through callig update_curr().
+	 * through calling update_curr().
 	 */
 	if (!(flags & ENQUEUE_WAKEUP) || (flags & ENQUEUE_WAKING))
 		se->vruntime += cfs_rq->min_vruntime;
--
1.7.11.6

