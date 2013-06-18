Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab3FROJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:09:04 -0400
Received: from multi.imgtec.com ([194.200.65.239]:44868 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932859Ab3FROJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:09:03 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>
Subject: [PATCH] genirq: irqchip: document gcflags arg of irq_alloc_domain_generic_chips
Date: Tue, 18 Jun 2013 15:08:33 +0100
Message-ID: <1371564513-4327-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_18_15_09_02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 088f40b7b027dad6519712ff224a5798dd62a204 ("genirq: Generic chip:
Add linear irq domain support") missed kerneldoc for the gcflags
argument of irq_alloc_domain_generic_chips(). Add it now.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/generic-chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 95575d8..a746a8f 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -251,12 +251,13 @@ irq_gc_init_mask_cache(struct irq_chip_generic *gc, enum irq_gc_flags flags)
  * @irqs_per_chip:	Number of interrupts each chip handles
  * @num_ct:		Number of irq_chip_type instances associated with this
  * @name:		Name of the irq chip
  * @handler:		Default flow handler associated with these chips
  * @clr:		IRQ_* bits to clear in the mapping function
  * @set:		IRQ_* bits to set in the mapping function
+ * @gcflags:		Generic chip specific setup flags
  */
 int irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
 				   int num_ct, const char *name,
 				   irq_flow_handler_t handler,
 				   unsigned int clr, unsigned int set,
 				   enum irq_gc_flags gcflags)
-- 
1.8.1.2


