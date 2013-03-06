Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab3CFOf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:35:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44246 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab3CFOfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:35:25 -0500
Date: Wed, 6 Mar 2013 06:34:08 -0800
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-090b582f27ac7b6714661020033160130e5297bd@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <5135A75F.4070202@huawei.com>
References: <5135A75F.4070202@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove test_sd_parent()
Git-Commit-ID: 090b582f27ac7b6714661020033160130e5297bd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Mar 2013 06:34:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  090b582f27ac7b6714661020033160130e5297bd
Gitweb:     http://git.kernel.org/tip/090b582f27ac7b6714661020033160130e5297bd
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Tue, 5 Mar 2013 16:05:51 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Mar 2013 11:24:29 +0100

sched: Remove test_sd_parent()

It's unused.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5135A75F.4070202@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2715fbb..e880d7d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -959,15 +959,6 @@ extern void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 cpumask_var_t *alloc_sched_domains(unsigned int ndoms);
 void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms);
 
-/* Test a flag in parent sched domain */
-static inline int test_sd_parent(struct sched_domain *sd, int flag)
-{
-	if (sd->parent && (sd->parent->flags & flag))
-		return 1;
-
-	return 0;
-}
-
 unsigned long default_scale_freq_power(struct sched_domain *sd, int cpu);
 unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu);
 
