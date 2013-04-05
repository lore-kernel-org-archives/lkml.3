Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab3DEK4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:56:55 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38401 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765961Ab3DEK4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:56:54 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        arvind.chauhan@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] sched: core: Fix spelling error inside comment
Date: Fri,  5 Apr 2013 16:26:46 +0530
Message-Id: <cd8084746ac932106d6fa6be388b8f2d6aa9617c.1365159023.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 05 Apr 2013 10:56:49.0851 (UTC) FILETIME=[461A88B0:01CE31EC]
X-MC-Unique: 113040511565200801
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r35Auuit008629

sched_domains_numa_distance is written as sched_domains_nume_distance inside one
of the comments. Fix it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 286066e..2e0de12 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6251,7 +6251,7 @@ static void sched_init_numa(void)
 	 * 'level' contains the number of unique distances, excluding the
 	 * identity distance node_distance(i,i).
 	 *
-	 * The sched_domains_nume_distance[] array includes the actual distance
+	 * The sched_domains_numa_distance[] array includes the actual distance
 	 * numbers.
 	 */
 
-- 
1.7.12.rc2.18.g61b472e


