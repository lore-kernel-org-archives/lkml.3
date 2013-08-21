Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab3HUAv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:51:26 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45019 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab3HUAvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:51:23 -0400
From: Libin <huawei.libin@huawei.com>
To: <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <wangyijing@huawei.com>,
        <guohanjun@huawei.com>
Subject: [PATCH v2 1/3] workqueue: Comment correction in file header
Date: Wed, 21 Aug 2013 08:50:39 +0800
Message-ID: <1377046241-18516-2-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1377046241-18516-1-git-send-email-huawei.libin@huawei.com>
References: <1377046241-18516-1-git-send-email-huawei.libin@huawei.com>
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
 kernel/workqueue.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7f5d4be..26644ce 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -16,9 +16,10 @@
  *
  * This is the generic async execution mechanism.  Work items as are
  * executed in process context.  The worker pool is shared and
- * automatically managed.  There is one worker pool for each CPU and
- * one extra for works which are better served by workers which are
- * not bound to any specific CPU.
+ * automatically managed.  There are two worker pools for each CPU(one
+ * for normal work items and the other for high priority ones) and
+ * some extra pools for workqueues which are not bound to any specific
+ * CPU - the number of these backing pools is dynamic.
  *
  * Please read Documentation/workqueue.txt for details.
  */
-- 
1.8.2.1


