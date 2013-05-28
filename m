Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab3E1LxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 07:53:03 -0400
Received: from mail.skitlab.ru ([217.65.220.135]:50197 "EHLO mail.skitlab.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933225Ab3E1LxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 07:53:00 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 May 2013 07:52:59 EDT
From: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
To: linux-omap@vger.kernel.org
Cc: tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
Subject: [PATCH] ARM: OMAP: fix IVA2 module base address
Date: Tue, 28 May 2013 15:46:17 +0400
Message-Id: <1369741577-21984-1-git-send-email-aida.mynzhasova@skitlab.ru>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrects the base address of IVA2 module on omap3430.

Signed-off-by: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
---
 arch/arm/mach-omap2/prcm-common.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/prcm-common.h b/arch/arm/mach-omap2/prcm-common.h
index c7d355f..d5ec044 100644
--- a/arch/arm/mach-omap2/prcm-common.h
+++ b/arch/arm/mach-omap2/prcm-common.h
@@ -37,7 +37,7 @@
 #define OMAP2430_MDM_MOD				0xc00
 
 /* IVA2 module is < base on 3430 */
-#define OMAP3430_IVA2_MOD				-0x800
+#define OMAP3430_IVA2_MOD				0x800
 #define OMAP3430ES2_SGX_MOD				GFX_MOD
 #define OMAP3430_CCR_MOD				PLL_MOD
 #define OMAP3430_DSS_MOD				0x600
-- 
1.7.10.4

