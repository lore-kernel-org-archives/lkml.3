Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab3FLSzj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 14:55:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38095 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757916Ab3FLSzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 14:55:37 -0400
Message-ID: <1371063336.2069.22.camel@joe-AO722>
Subject: [PATCH] sched: core: Don't mix use of typedef ctl_table and struct
 ctl_table
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 12 Jun 2013 11:55:36 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just use struct ctl_table.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/sched/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 58453b8..17315d7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5080,7 +5080,7 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 	return table;
 }
 
-static ctl_table *sd_alloc_ctl_cpu_table(int cpu)
+static struct ctl_table *sd_alloc_ctl_cpu_table(int cpu)
 {
 	struct ctl_table *entry, *table;
 	struct sched_domain *sd;


