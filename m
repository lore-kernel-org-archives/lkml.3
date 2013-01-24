Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926Ab3AXLNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:13:40 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:47418 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab3AXLNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:13:11 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 65/71] ARC: [Review] Multi-platform image #5: NR_IRQS defined by ARC core
Date: Thu, 24 Jan 2013 16:36:25 +0530
Message-ID: <1359025589-22277-42-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
References: <1359025589-22277-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For now this will suffice for all platforms, later exotic ones needs to
get this from DeviceTree

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Arnd Bergmann <arnd@arndb.de>
---
 arch/arc/include/asm/irq.h               |    2 ++
 arch/arc/plat-arcfpga/include/plat/irq.h |    6 ------
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arc/include/asm/irq.h b/arch/arc/include/asm/irq.h
index 20aaab8..4c588f9 100644
--- a/arch/arc/include/asm/irq.h
+++ b/arch/arc/include/asm/irq.h
@@ -9,6 +9,8 @@
 #ifndef __ASM_ARC_IRQ_H
 #define __ASM_ARC_IRQ_H
 
+#define NR_IRQS		32
+
 /* Platform Independent IRQs */
 #define TIMER0_IRQ      3
 #define TIMER1_IRQ      4
diff --git a/arch/arc/plat-arcfpga/include/plat/irq.h b/arch/arc/plat-arcfpga/include/plat/irq.h
index 6515df2..41e3356 100644
--- a/arch/arc/plat-arcfpga/include/plat/irq.h
+++ b/arch/arc/plat-arcfpga/include/plat/irq.h
@@ -12,12 +12,6 @@
 #ifndef __PLAT_IRQ_H
 #define __PLAT_IRQ_H
 
-#ifdef CONFIG_SMP
-#define NR_IRQS 32
-#else
-#define NR_IRQS 16
-#endif
-
 #define UART0_IRQ	5
 #define UART1_IRQ	10
 #define UART2_IRQ	11
-- 
1.7.4.1

