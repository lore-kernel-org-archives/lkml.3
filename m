Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab3FXNkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:40:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55190 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab3FXNkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:40:45 -0400
Date: Mon, 24 Jun 2013 06:40:19 -0700
From: tip-bot for James Hogan <tipbot@zytor.com>
Message-ID: <tip-6fff8314046276331314ae32cea34c6d11c440d2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, hpa@zytor.com,
        mingo@kernel.org, james.hogan@imgtec.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, james.hogan@imgtec.com,
        tglx@linutronix.de
In-Reply-To: <1371564513-4327-1-git-send-email-james.hogan@imgtec.com>
References: <1371564513-4327-1-git-send-email-james.hogan@imgtec.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Irqchip:
  document gcflags arg of irq_alloc_domain_generic_chips
Git-Commit-ID: 6fff8314046276331314ae32cea34c6d11c440d2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 24 Jun 2013 06:40:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6fff8314046276331314ae32cea34c6d11c440d2
Gitweb:     http://git.kernel.org/tip/6fff8314046276331314ae32cea34c6d11c440d2
Author:     James Hogan <james.hogan@imgtec.com>
AuthorDate: Tue, 18 Jun 2013 15:08:33 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 24 Jun 2013 15:38:12 +0200

genirq: Irqchip: document gcflags arg of irq_alloc_domain_generic_chips

Commit 088f40b7b027dad6519712ff224a5798dd62a204 ("genirq: Generic chip:
Add linear irq domain support") missed kerneldoc for the gcflags
argument of irq_alloc_domain_generic_chips(). Add it now.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Link: http://lkml.kernel.org/r/1371564513-4327-1-git-send-email-james.hogan@imgtec.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/generic-chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index 95575d8..a746a8f 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -254,6 +254,7 @@ irq_gc_init_mask_cache(struct irq_chip_generic *gc, enum irq_gc_flags flags)
  * @handler:		Default flow handler associated with these chips
  * @clr:		IRQ_* bits to clear in the mapping function
  * @set:		IRQ_* bits to set in the mapping function
+ * @gcflags:		Generic chip specific setup flags
  */
 int irq_alloc_domain_generic_chips(struct irq_domain *d, int irqs_per_chip,
 				   int num_ct, const char *name,
