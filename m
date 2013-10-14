Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab3JNJee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 05:34:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51369 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754571Ab3JNJed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 05:34:33 -0400
Date: Mon, 14 Oct 2013 02:34:08 -0700
From: tip-bot for Kamalesh Babulal <tipbot@zytor.com>
Message-ID: <tip-ed1b7732868035990f07aeb532b1d86272ea909e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kamalesh@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kamalesh@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <1381685775-3544-1-git-send-email-kamalesh@linux.vnet.ibm.com>
References: <1381685775-3544-1-git-send-email-kamalesh@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/fair: Fix trivial typos in comments
Git-Commit-ID: ed1b7732868035990f07aeb532b1d86272ea909e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 02:34:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ed1b7732868035990f07aeb532b1d86272ea909e
Gitweb:     http://git.kernel.org/tip/ed1b7732868035990f07aeb532b1d86272ea909e
Author:     Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
AuthorDate: Sun, 13 Oct 2013 23:06:15 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 14 Oct 2013 09:22:55 +0200

sched/fair: Fix trivial typos in comments

 - 'load_icx' => 'load_idx'
 - 'calculcate_imbalance' => 'calculate_imbalance'

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/1381685775-3544-1-git-send-email-kamalesh@linux.vnet.ibm.com
[ Also, don't capitalize 'idle' unnecessarily. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8274679..4aa0b10 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5206,7 +5206,7 @@ static inline void init_sd_lb_stats(struct sd_lb_stats *sds)
 /**
  * get_sd_load_idx - Obtain the load index for a given sched domain.
  * @sd: The sched_domain whose load_idx is to be obtained.
- * @idle: The Idle status of the CPU for whose sd load_icx is obtained.
+ * @idle: The idle status of the CPU for whose sd load_idx is obtained.
  *
  * Return: The load index.
  */
@@ -5412,7 +5412,7 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
  * moving tasks due to affinity constraints.
  *
  * When this is so detected; this group becomes a candidate for busiest; see
- * update_sd_pick_busiest(). And calculcate_imbalance() and
+ * update_sd_pick_busiest(). And calculate_imbalance() and
  * find_busiest_group() avoid some of the usual balance conditions to allow it
  * to create an effective group imbalance.
  *
