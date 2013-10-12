Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab3JLRX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 13:23:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37565 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab3JLRXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 13:23:25 -0400
Date: Sat, 12 Oct 2013 10:22:06 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-62e947cb0cd27c392aabe732c64f5023e272cf0e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, iamjoonsoo.kim@lge.com, artagnon@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, artagnon@gmail.com,
        iamjoonsoo.kim@lge.com
In-Reply-To: <1381400433-2030-1-git-send-email-artagnon@gmail.com>
References: <1381400433-2030-1-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Remove bogus parameter in structured comment
Git-Commit-ID: 62e947cb0cd27c392aabe732c64f5023e272cf0e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 12 Oct 2013 10:22:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62e947cb0cd27c392aabe732c64f5023e272cf0e
Gitweb:     http://git.kernel.org/tip/62e947cb0cd27c392aabe732c64f5023e272cf0e
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Thu, 10 Oct 2013 15:50:33 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 12 Oct 2013 19:01:24 +0200

sched: Remove bogus parameter in structured comment

The balance parameter was removed by 23f0d20 ("sched: Factor out
code to should_we_balance()", 2013-08-06).

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1381400433-2030-1-git-send-email-artagnon@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 803e343..8274679 100644
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
