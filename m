Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbaEHKsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:48:13 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:57880 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbaEHKsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:48:11 -0400
From: "xiaofeng.yan" <xiaofeng.yan@huawei.com>
To: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <peterz@infradead.org>
CC: <xiaofeng_yan2004@126.com>, "xiaofeng.yan" <xiaofeng.yan@huawei.com>
Subject: [PATCH] sched/rt: Fix a comment in struct sched_dl_entity
Date: Thu, 8 May 2014 10:31:20 +0000
Message-ID: <1399545080-17823-1-git-send-email-xiaofeng.yan@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change sched_setscheduler2() to sched_setscheduler() in the comments.
There isn't function sched_setscheduler2() in the main line.
The previous EDF version defines this function
before being merged into the main line.
User should use sched_setscheduler() instead of
sched_setscheduler2() now.

Signed-off-by: xiaofeng.yan <xiaofeng.yan@huawei.com>
---
 include/linux/sched.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 25f54c7..fe263e7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1123,8 +1123,8 @@ struct sched_dl_entity {
 
 	/*
 	 * Original scheduling parameters. Copied here from sched_attr
-	 * during sched_setscheduler2(), they will remain the same until
-	 * the next sched_setscheduler2().
+	 * during sched_setscheduler(), they will remain the same until
+	 * the next sched_setscheduler().
 	 */
 	u64 dl_runtime;		/* maximum runtime for each instance	*/
 	u64 dl_deadline;	/* relative deadline of each instance	*/
-- 
1.7.9.5

