Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab3FLMYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 08:24:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46649 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3FLMYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 08:24:22 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Jun 2013 14:24:12 +0200
Message-Id: <1371039852-19499-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1371031591-10038-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1371031591-10038-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ukl@pengutronix.de
Subject: [PATCH] irq/generic-chip: fix a few kernel-doc entries
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

this is a resend, because I messed up lkml's email address in the first submission. Please ignore the first mail.

Thanks
Uwe

 kernel/irq/generic-chip.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 9512762..b9322eb 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -45,7 +45,7 @@ void irq_gc_mask_disable_reg(struct irq_data *d)
 }
 
 /**
- * irq_gc_mask_set_mask_bit - Mask chip via setting bit in mask register
+ * irq_gc_mask_set_bit - Mask irq via setting bit in mask register
  * @d: irq_data
  *
  * Chip has a single mask register. Values of this register are cached
@@ -64,7 +64,7 @@ void irq_gc_mask_set_bit(struct irq_data *d)
 }
 
 /**
- * irq_gc_mask_set_mask_bit - Mask chip via clearing bit in mask register
+ * irq_gc_mask_clr_bit - Mask chip via clearing bit in mask register
  * @d: irq_data
  *
  * Chip has a single mask register. Values of this register are cached
@@ -132,7 +132,7 @@ void irq_gc_ack_clr_bit(struct irq_data *d)
 }
 
 /**
- * irq_gc_mask_disable_reg_and_ack- Mask and ack pending interrupt
+ * irq_gc_mask_disable_reg_and_ack - Mask and ack pending interrupt
  * @d: irq_data
  */
 void irq_gc_mask_disable_reg_and_ack(struct irq_data *d)
-- 
1.8.3

