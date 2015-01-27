Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbbA0Vqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:46:35 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:5700 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759835AbbA0VqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:46:19 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Ralf Baechle <ralf@linux-mips.org>, <linux-mips@linux-mips.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [PATCH 5/9] irqchip: mips-gic: Add missing definitions for FDC IRQ
Date: Tue, 27 Jan 2015 21:45:51 +0000
Message-ID: <1422395155-16511-6-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422395155-16511-1-git-send-email-james.hogan@imgtec.com>
References: <1422395155-16511-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.110]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing VPE_PEND, VPE_RMASK and VPE_SMASK definitions for the local
FDC interrupt.

These local interrupt definitions aren't directly used, but if they
exist they should be complete.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Bresticker <abrestic@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: linux-mips@linux-mips.org
---
 include/linux/irqchip/mips-gic.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/irqchip/mips-gic.h b/include/linux/irqchip/mips-gic.h
index 420f77b34d02..ff0e75f40ef5 100644
--- a/include/linux/irqchip/mips-gic.h
+++ b/include/linux/irqchip/mips-gic.h
@@ -165,6 +165,8 @@
 #define GIC_VPE_PEND_SWINT0_MSK		(MSK(1) << GIC_VPE_PEND_SWINT0_SHF)
 #define GIC_VPE_PEND_SWINT1_SHF		5
 #define GIC_VPE_PEND_SWINT1_MSK		(MSK(1) << GIC_VPE_PEND_SWINT1_SHF)
+#define GIC_VPE_PEND_FDC_SHF		6
+#define GIC_VPE_PEND_FDC_MSK		(MSK(1) << GIC_VPE_PEND_FDC_SHF)
 
 /* GIC_VPE_RMASK Masks */
 #define GIC_VPE_RMASK_WD_SHF		0
@@ -179,6 +181,8 @@
 #define GIC_VPE_RMASK_SWINT0_MSK	(MSK(1) << GIC_VPE_RMASK_SWINT0_SHF)
 #define GIC_VPE_RMASK_SWINT1_SHF	5
 #define GIC_VPE_RMASK_SWINT1_MSK	(MSK(1) << GIC_VPE_RMASK_SWINT1_SHF)
+#define GIC_VPE_RMASK_FDC_SHF		6
+#define GIC_VPE_RMASK_FDC_MSK		(MSK(1) << GIC_VPE_RMASK_FDC_SHF)
 
 /* GIC_VPE_SMASK Masks */
 #define GIC_VPE_SMASK_WD_SHF		0
@@ -193,6 +197,8 @@
 #define GIC_VPE_SMASK_SWINT0_MSK	(MSK(1) << GIC_VPE_SMASK_SWINT0_SHF)
 #define GIC_VPE_SMASK_SWINT1_SHF	5
 #define GIC_VPE_SMASK_SWINT1_MSK	(MSK(1) << GIC_VPE_SMASK_SWINT1_SHF)
+#define GIC_VPE_SMASK_FDC_SHF		6
+#define GIC_VPE_SMASK_FDC_MSK		(MSK(1) << GIC_VPE_SMASK_FDC_SHF)
 
 /* GIC nomenclature for Core Interrupt Pins. */
 #define GIC_CPU_INT0		0 /* Core Interrupt 2 */
-- 
2.0.5

