Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657Ab3L0LmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 06:42:10 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:55389 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab3L0Ll3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 06:41:29 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 3/5] sched, fair: fix the typo in select_idle_sibling()
Date: Fri, 27 Dec 2013 19:41:02 +0800
Message-Id: <1388144464-28458-4-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1388144464-28458-1-git-send-email-zwu.kernel@gmail.com>
References: <1388144464-28458-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122711-0928-0000-0000-000004DF1D06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a82ae0a..db23d71 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4191,7 +4191,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 		return i;
 
 	/*
-	 * Otherwise, iterate the domains and find an elegible idle cpu.
+	 * Otherwise, iterate the domains and find an eligible idle cpu.
 	 */
 	sd = rcu_dereference(per_cpu(sd_llc, target));
 	for_each_lower_domain(sd) {
-- 
1.7.6.5

