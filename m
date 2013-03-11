Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3CKKDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 06:03:53 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:49026 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab3CKKDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 06:03:37 -0400
From: Andrei Epure <epure.andrei@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        Andrei Epure <epure.andrei@gmail.com>
Subject: [PATCH] kernel:sched hyphened compound adjective before noun
Date: Mon, 11 Mar 2013 12:03:20 +0200
Message-Id: <1362996200-2674-1-git-send-email-epure.andrei@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrei Epure <epure.andrei@gmail.com>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7a33e59..3220639 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -652,7 +652,7 @@ static u64 sched_slice(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 /*
- * We calculate the vruntime slice of a to be inserted task
+ * We calculate the vruntime slice of a to-be-inserted task.
  *
  * vs = s/w
  */
-- 
1.7.9.5

