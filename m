Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaBJIXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 03:23:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:43078 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbaBJIXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 03:23:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,816,1384329600"; 
   d="scan'208";a="480776407"
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, Chuansheng Liu <chuansheng.liu@intel.com>
Subject: [PATCH 2/2] genirq: Fix one typo chasnge
Date: Mon, 10 Feb 2014 16:13:57 +0800
Message-Id: <1392020037-5484-2-git-send-email-chuansheng.liu@intel.com>
X-Mailer: git-send-email 1.9.rc0
In-Reply-To: <1392020037-5484-1-git-send-email-chuansheng.liu@intel.com>
References: <y>
 <1392020037-5484-1-git-send-email-chuansheng.liu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the comment "chasnge" to "change".

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
---
 kernel/irq/manage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 481a13c..4802295 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -727,7 +727,7 @@ out_unlock:
 
 #ifdef CONFIG_SMP
 /*
- * Check whether we need to chasnge the affinity of the interrupt thread.
+ * Check whether we need to change the affinity of the interrupt thread.
  */
 static void
 irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
-- 
1.9.rc0

