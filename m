Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbaBOT0d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 14:26:33 -0500
Received: from www.linutronix.de ([62.245.132.108]:47766 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbaBOT0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 14:26:32 -0500
Date: Sat, 15 Feb 2014 20:26:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT Pull] irq fixes for 3.14
Message-ID: <alpine.DEB.2.02.1402152021440.21991@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

A trivial oneliner adding the missing Kconfig dependency curing build
failures which have been discovered by several build robots.

Thanks,

	tglx

------------------>
Nitin A Kamble (1):
      genirq: Generic irq chip requires IRQ_DOMAIN


 kernel/irq/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/Kconfig b/kernel/irq/Kconfig
index 4a1fef0..07cbdfe 100644
--- a/kernel/irq/Kconfig
+++ b/kernel/irq/Kconfig
@@ -40,6 +40,7 @@ config IRQ_EDGE_EOI_HANDLER
 # Generic configurable interrupt chip implementation
 config GENERIC_IRQ_CHIP
        bool
+       select IRQ_DOMAIN
 
 # Generic irq_domain hw <--> linux irq number translation
 config IRQ_DOMAIN
