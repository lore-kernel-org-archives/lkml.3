Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaIAIW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 04:22:28 -0400
Received: from www.linutronix.de ([62.245.132.108]:56247 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbaIAIWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 04:22:25 -0400
Date: Mon, 1 Sep 2014 10:22:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT Pull] x86 fixes for 3.17
Message-ID: <alpine.DEB.2.10.1409011020460.3333@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1827569170-1409559742=:3333"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1827569170-1409559742=:3333
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Linus,

please pull the latest irq-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq-urgent-for-linus

Just an export for an interrupt flow handler which is now used in gpio
modules.

Thanks,

	tglx

------------------>
Vincent Stehlé (1):
      irq: Export handle_fasteoi_irq


 kernel/irq/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index a2b28a2fd7b1..6223fab9a9d2 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -517,6 +517,7 @@ out:
 		chip->irq_eoi(&desc->irq_data);
 	raw_spin_unlock(&desc->lock);
 }
+EXPORT_SYMBOL_GPL(handle_fasteoi_irq);
 
 /**
  *	handle_edge_irq - edge type IRQ handler
--8323329-1827569170-1409559742=:3333--
