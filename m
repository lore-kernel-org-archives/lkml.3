Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839Ab3CJLSm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 07:18:42 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:38414 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3CJLSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 07:18:41 -0400
From: Kevin Wilson <wkevils@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, tglx@linutronix.de,
        Kevin Wilson <wkevils@gmail.com>
Subject: [PATCH] irq: fix typo in a header file.
Date: Sun, 10 Mar 2013 13:17:53 +0200
Message-Id: <1362914273-4291-1-git-send-email-wkevils@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a typo in include/linux/irq.h.

Signed-off-by: Kevin Wilson <wkevils@gmail.com>
---
 include/linux/irq.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index bc4e066..c2b7e51 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -68,7 +68,7 @@ typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
  *				  request/setup_irq()
  * IRQ_NO_BALANCING		- Interrupt cannot be balanced (affinity set)
  * IRQ_MOVE_PCNTXT		- Interrupt can be migrated from process context
- * IRQ_NESTED_TRHEAD		- Interrupt nests into another thread
+ * IRQ_NESTED_THREAD		- Interrupt nests into another thread
  * IRQ_PER_CPU_DEVID		- Dev_id is a per-cpu variable
  */
 enum {
-- 
1.8.1.4

