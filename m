Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab3F0JE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 05:04:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46105 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab3F0JDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 05:03:42 -0400
Date: Thu, 27 Jun 2013 02:03:25 -0700
From: tip-bot for Kamalesh Babulal <tipbot@zytor.com>
Message-ID: <tip-0fc576d592bd137437fdeb059738b789e642b744@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kamalesh@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kamalesh@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20130627055418.GA18582@linux.vnet.ibm.com>
References: <20130627055418.GA18582@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair:
  Fix typo describing flags in enqueue_entity
Git-Commit-ID: 0fc576d592bd137437fdeb059738b789e642b744
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 27 Jun 2013 02:03:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0fc576d592bd137437fdeb059738b789e642b744
Gitweb:     http://git.kernel.org/tip/0fc576d592bd137437fdeb059738b789e642b744
Author:     Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
AuthorDate: Thu, 27 Jun 2013 11:24:18 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 27 Jun 2013 10:18:25 +0200

sched/fair: Fix typo describing flags in enqueue_entity

Fix spelling of 'calling' in description of se flags in
enqueue_entity().

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/20130627055418.GA18582@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b43474a..f77f9c5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1760,7 +1760,7 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
 {
 	/*
 	 * Update the normalized vruntime before updating min_vruntime
-	 * through callig update_curr().
+	 * through calling update_curr().
 	 */
 	if (!(flags & ENQUEUE_WAKEUP) || (flags & ENQUEUE_WAKING))
 		se->vruntime += cfs_rq->min_vruntime;
