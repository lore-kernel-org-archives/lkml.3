Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbaH1H4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 03:56:55 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:35840 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129AbaH1H4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 03:56:54 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] MAINTAINERS: Add irqchip DT bindings doc path to IRQCHIP DRIVERS section
Date: Thu, 28 Aug 2014 09:56:47 +0200
Message-Id: <1409212607-4021-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 704be0f07f86..f76af4d18ee5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4989,6 +4989,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git irq/core
 T:	git git://git.infradead.org/users/jcooper/linux.git irqchip/core
+F:	Documentation/devicetree/bindings/interrupt-controller/
 F:	drivers/irqchip/
 
 IRQ DOMAINS (IRQ NUMBER MAPPING LIBRARY)
-- 
1.9.1

