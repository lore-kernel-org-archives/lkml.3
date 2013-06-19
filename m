Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964939Ab3FSSl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:41:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40193 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964923Ab3FSSly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:41:54 -0400
Date: Wed, 19 Jun 2013 11:41:20 -0700
From: tip-bot for Joe Perches <tipbot@zytor.com>
Message-ID: <tip-be7002e6c613d22976f2b8d4bae6121a5fc0433a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        joe@perches.com, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joe@perches.com, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1371063336.2069.22.camel@joe-AO722>
References: <1371063336.2069.22.camel@joe-AO722>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Don'
 t mix use of typedef ctl_table and struct ctl_table
Git-Commit-ID: be7002e6c613d22976f2b8d4bae6121a5fc0433a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:41:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  be7002e6c613d22976f2b8d4bae6121a5fc0433a
Gitweb:     http://git.kernel.org/tip/be7002e6c613d22976f2b8d4bae6121a5fc0433a
Author:     Joe Perches <joe@perches.com>
AuthorDate: Wed, 12 Jun 2013 11:55:36 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:58:48 +0200

sched: Don't mix use of typedef ctl_table and struct ctl_table

Just use struct ctl_table.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1371063336.2069.22.camel@joe-AO722
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 21b1403..ceeaf0f 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4533,7 +4533,7 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 	return table;
 }
 
-static ctl_table *sd_alloc_ctl_cpu_table(int cpu)
+static struct ctl_table *sd_alloc_ctl_cpu_table(int cpu)
 {
 	struct ctl_table *entry, *table;
 	struct sched_domain *sd;
