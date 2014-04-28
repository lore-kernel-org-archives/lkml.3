Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaD1EDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 00:03:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44421 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaD1EDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 00:03:17 -0400
Message-ID: <535DD2FD.7030804@infradead.org>
Date: Sun, 27 Apr 2014 21:03:09 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] linux/interrupt.h:  fix new kernel-doc warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix new kernel-doc warnings in <linux/interrupt.h>:

Warning(include/linux/interrupt.h:219): No description found for parameter 'cpumask'
Warning(include/linux/interrupt.h:219): Excess function parameter 'mask' description in 'irq_set_affinity'
Warning(include/linux/interrupt.h:236): No description found for parameter 'cpumask'
Warning(include/linux/interrupt.h:236): Excess function parameter 'mask' description in 'irq_force_affinity'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 include/linux/interrupt.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx-315-rc3.orig/include/linux/interrupt.h
+++ lnx-315-rc3/include/linux/interrupt.h
@@ -210,7 +210,7 @@ extern int __irq_set_affinity(unsigned i
 /**
  * irq_set_affinity - Set the irq affinity of a given irq
  * @irq:	Interrupt to set affinity
- * @mask:	cpumask
+ * @cpumask:	cpumask
  *
  * Fails if cpumask does not contain an online CPU
  */
@@ -223,7 +223,7 @@ irq_set_affinity(unsigned int irq, const
 /**
  * irq_force_affinity - Force the irq affinity of a given irq
  * @irq:	Interrupt to set affinity
- * @mask:	cpumask
+ * @cpumask:	cpumask
  *
  * Same as irq_set_affinity, but without checking the mask against
  * online cpus.
