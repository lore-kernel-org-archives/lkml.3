Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760330Ab3LICtC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 21:49:02 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:49642 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760184Ab3LICtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 21:49:01 -0500
From: Libin <huawei.libin@huawei.com>
To: Tejun Heo <tj@kernel.org>
CC: <guohanjun@huawei.com>, <wangyijing@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] workqueue: Fix comment typo for enum WQ_SYSFS
Date: Mon, 9 Dec 2013 10:44:37 +0800
Message-ID: <1386557077-9600-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Bin <huawei.libin@huawei.com>

s/wq_sysfs_register()/workqueue_sysfs_register()

Signed-off-by: Li Bin <huawei.libin@huawei.com>
---
 include/linux/workqueue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 594521b..88d1e12 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -306,7 +306,7 @@ enum {
 	WQ_MEM_RECLAIM		= 1 << 3, /* may be used for memory reclaim */
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
-	WQ_SYSFS		= 1 << 6, /* visible in sysfs, see wq_sysfs_register() */
+	WQ_SYSFS		= 1 << 6, /* visible in sysfs, see workqueue_sysfs_register() */
 
 	/*
 	 * Per-cpu workqueues are generally preferred because they tend to
-- 
1.8.2.2


