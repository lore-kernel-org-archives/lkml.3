Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793Ab3HPFde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 01:33:34 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:62007 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3HPFdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 01:33:33 -0400
From: Libin <huawei.libin@huawei.com>
To: <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <guohanjun@huawei.com>,
        <wangyijing@huawei.com>
Subject: [PATCH] workqueue: Comment correction in file header
Date: Fri, 16 Aug 2013 13:32:44 +0800
Message-ID: <1376631164-11836-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change. There are two worker pools for each cpu in
current implementation(one for normal work items and the other for
high priority ones).

Signed-off-by: Libin <huawei.libin@huawei.com>
---
 kernel/workqueue.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e8ee7a4..904ec00 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -16,8 +16,9 @@
  *
  * This is the generic async execution mechanism.  Work items as are
  * executed in process context.  The worker pool is shared and
- * automatically managed.  There is one worker pool for each CPU and
- * one extra for works which are better served by workers which are
+ * automatically managed.  There are two worker pools for each CPU(one
+ * for normal work items and the other for high priority ones) and
+ * two extra for works which are better served by workers which are
  * not bound to any specific CPU.
  *
  * Please read Documentation/workqueue.txt for details.
-- 
1.8.2.1


