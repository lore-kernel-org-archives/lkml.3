Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaGGGRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 02:17:30 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:21113 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaGGGR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 02:17:29 -0400
From: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
To: <mingo@redhat.com>, <peterz@infradead.org>, <linux-kernel@vger.kernel.org>
CC: <xiaofeng.yan2012@gmail.com>, "xiaofeng.yan" <xiaofeng.yan@huawei.com>
Subject: [PATCH] sched/rt:Fix replenish_dl_entity() comments to match the current upstream code
Date: Mon, 7 Jul 2014 05:59:04 +0000
Message-ID: <1404712744-16986-1-git-send-email-xiaofeng.yan@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: xiaofeng.yan <xiaofeng.yan@huawei.com>
---
 kernel/sched/deadline.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index fc4f98b1..6541565 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -306,7 +306,7 @@ static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se,
  * the overrunning entity can't interfere with other entity in the system and
  * can't make them miss their deadlines. Reasons why this kind of overruns
  * could happen are, typically, a entity voluntarily trying to overcome its
- * runtime, or it just underestimated it during sched_setscheduler_ex().
+ * runtime, or it just underestimated it during sched_setattr().
  */
 static void replenish_dl_entity(struct sched_dl_entity *dl_se,
 				struct sched_dl_entity *pi_se)
-- 
1.7.9.5

