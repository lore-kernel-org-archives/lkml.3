Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbaBSQ2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:28:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56614 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbaBSQ2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:28:06 -0500
Date: Wed, 19 Feb 2014 08:27:52 -0800
From: tip-bot for Chuansheng Liu <tipbot@zytor.com>
Message-ID: <tip-b04c644e670f79417f1728e6be310cfd8e6a921b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, chuansheng.liu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, chuansheng.liu@intel.com
In-Reply-To: <1392020037-5484-2-git-send-email-chuansheng.liu@intel.com>
References: <1392020037-5484-2-git-send-email-chuansheng.liu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Update the a comment typo
Git-Commit-ID: b04c644e670f79417f1728e6be310cfd8e6a921b
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

Commit-ID:  b04c644e670f79417f1728e6be310cfd8e6a921b
Gitweb:     http://git.kernel.org/tip/b04c644e670f79417f1728e6be310cfd8e6a921b
Author:     Chuansheng Liu <chuansheng.liu@intel.com>
AuthorDate: Mon, 10 Feb 2014 16:13:57 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 19 Feb 2014 17:26:34 +0100

genirq: Update the a comment typo

Change the comment "chasnge" to "change".

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Link: http://lkml.kernel.org/r/1392020037-5484-2-git-send-email-chuansheng.liu@intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 54eb5c9..ada0c54 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -757,7 +757,7 @@ out_unlock:
 
 #ifdef CONFIG_SMP
 /*
- * Check whether we need to chasnge the affinity of the interrupt thread.
+ * Check whether we need to change the affinity of the interrupt thread.
  */
 static void
 irq_thread_check_affinity(struct irq_desc *desc, struct irqaction *action)
