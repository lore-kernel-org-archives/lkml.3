Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab3DALO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 07:14:26 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:7989 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab3DALOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 07:14:25 -0400
From: Libin <huawei.libin@huawei.com>
To: <peterz@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
        Libin <huawei.libin@huawei.com>
Subject: [PATCH] sched: Fix comment of function rebalance_domains
Date: Mon, 1 Apr 2013 19:14:01 +0800
Message-ID: <1364814841-49156-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment of function rebalance_domains mentions arch_init_sched_domains,
but this function don't exist. The proper function is init_sched_domains.

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a33e59..3a0d40b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5468,7 +5468,7 @@ void update_max_interval(void)
  * It checks each scheduling domain to see if it is due to be balanced,
  * and initiates a balancing operation if so.
  *
- * Balancing parameters are set up in arch_init_sched_domains.
+ * Balancing parameters are set up in init_sched_domains.
  */
 static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 {
-- 
1.6.0.2


