Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935169AbaGPTXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:23:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44520 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934984AbaGPTXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:23:44 -0400
Date: Wed, 16 Jul 2014 12:22:51 -0700
From: "tip-bot for xiaofeng.yan" <tipbot@zytor.com>
Message-ID: <tip-1b09d29bc00964d9032d80516f958044ac6b3805@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, xiaofeng.yan@huawei.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, xiaofeng.yan@huawei.com
In-Reply-To: <1404712744-16986-1-git-send-email-xiaofeng.yan@huawei.com>
References: <1404712744-16986-1-git-send-email-xiaofeng.yan@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/rt: Fix replenish_dl_entity()
  comments to match the current upstream code
Git-Commit-ID: 1b09d29bc00964d9032d80516f958044ac6b3805
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b09d29bc00964d9032d80516f958044ac6b3805
Gitweb:     http://git.kernel.org/tip/1b09d29bc00964d9032d80516f958044ac6b3805
Author:     xiaofeng.yan <xiaofeng.yan@huawei.com>
AuthorDate: Mon, 7 Jul 2014 05:59:04 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 13:38:20 +0200

sched/rt: Fix replenish_dl_entity() comments to match the current upstream code

Signed-off-by: xiaofeng.yan <xiaofeng.yan@huawei.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1404712744-16986-1-git-send-email-xiaofeng.yan@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/deadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index df0b77a..255ce13 100644
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
