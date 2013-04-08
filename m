Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936435Ab3DHPe0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:34:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37909 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936306Ab3DHPeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:34:24 -0400
Date: Mon, 8 Apr 2013 08:34:12 -0700
From: tip-bot for Viresh Kumar <tipbot@zytor.com>
Message-ID: <tip-28b4a521f618d9722bc780ea38b44718ce0fe283@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        viresh.kumar@linaro.org, tglx@linutronix.de
In-Reply-To: <cd8084746ac932106d6fa6be388b8f2d6aa9617c.1365159023.git.viresh.kumar@linaro.org>
References: <cd8084746ac932106d6fa6be388b8f2d6aa9617c.1365159023.git.viresh.kumar@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix typo inside comment
Git-Commit-ID: 28b4a521f618d9722bc780ea38b44718ce0fe283
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 08 Apr 2013 08:34:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  28b4a521f618d9722bc780ea38b44718ce0fe283
Gitweb:     http://git.kernel.org/tip/28b4a521f618d9722bc780ea38b44718ce0fe283
Author:     Viresh Kumar <viresh.kumar@linaro.org>
AuthorDate: Fri, 5 Apr 2013 16:26:46 +0530
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 8 Apr 2013 13:55:39 +0200

sched: Fix typo inside comment

Fix typo:

 sched_domains_nume_distance ->
 sched_domains_numa_distance

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org
Cc: patches@linaro.org
Cc: robin.randhawa@arm.com
Cc: Steve.Bannister@arm.com
Cc: Liviu.Dudau@arm.com
Cc: charles.garcia-tobin@arm.com
Cc: arvind.chauhan@arm.com
Cc: peterz@infradead.org
Link: http://lkml.kernel.org/r/cd8084746ac932106d6fa6be388b8f2d6aa9617c.1365159023.git.viresh.kumar@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 849deb9..f5e1aa5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6252,7 +6252,7 @@ static void sched_init_numa(void)
 	 * 'level' contains the number of unique distances, excluding the
 	 * identity distance node_distance(i,i).
 	 *
-	 * The sched_domains_nume_distance[] array includes the actual distance
+	 * The sched_domains_numa_distance[] array includes the actual distance
 	 * numbers.
 	 */
 
