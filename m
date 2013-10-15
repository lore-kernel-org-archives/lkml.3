Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455Ab3JOIUw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 04:20:52 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:18273 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3JOIUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 04:20:50 -0400
From: Libin <huawei.libin@huawei.com>
To: <davidlohr@hp.com>, <akpm@linux-foundation.org>,
        <manfred@colorfullife.com>
CC: <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>,
        <xiexiuqi@huawei.com>, <huawei.libin@huawei.com>
Subject: [PATCH] ipc/sem.c: fix small codingstyle
Date: Tue, 15 Oct 2013 16:19:43 +0800
Message-ID: <1381825183-49576-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Bin <huawei.libin@huawei.com>

small codingstyle fix: '*' should be adjacent to the data name.

Signed-off-by: Li Bin <huawei.libin@huawei.com>
---
 ipc/sem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 8c4f59b..7583fe8 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -2077,7 +2077,7 @@ void exit_sem(struct task_struct *tsk)
 
 		/* perform adjustments registered in un */
 		for (i = 0; i < sma->sem_nsems; i++) {
-			struct sem * semaphore = &sma->sem_base[i];
+			struct sem *semaphore = &sma->sem_base[i];
 			if (un->semadj[i]) {
 				semaphore->semval += un->semadj[i];
 				/*
-- 
1.8.2.1


