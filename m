Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab3LEAuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:50:25 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:58679 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116Ab3LEAuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:50:22 -0500
From: Nishanth Menon <nm@ti.com>
To: Rob Herring <rob.herring@calxeda.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>
CC: Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Landley <rob@landley.net>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 2/2] ARM: OMAP2+: board-generic: update SoC compatibility strings
Date: Wed, 4 Dec 2013 18:49:37 -0600
Message-ID: <1386204578-6018-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386204578-6018-1-git-send-email-nm@ti.com>
References: <1386204578-6018-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have standardized SoC definitions, update the
compatibility strings in board machine descriptors. Eventually, we
should just have SoC compatiblity here and all board specific stuff
should disappear.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
NOTE: To prevent conflict, I have not added am3517 which is addressed in:
https://patchwork.kernel.org/patch/3279281/

 arch/arm/mach-omap2/board-generic.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/mach-omap2/board-generic.c b/arch/arm/mach-omap2/board-generic.c
index 19f1652..5356a29 100644
--- a/arch/arm/mach-omap2/board-generic.c
+++ b/arch/arm/mach-omap2/board-generic.c
@@ -78,6 +78,7 @@ MACHINE_END
 
 #ifdef CONFIG_ARCH_OMAP3
 static const char *omap3_boards_compat[] __initdata = {
+	"ti,omap3430",
 	"ti,omap3",
 	NULL,
 };
@@ -155,6 +156,8 @@ MACHINE_END
 
 #ifdef CONFIG_ARCH_OMAP4
 static const char *omap4_boards_compat[] __initdata = {
+	"ti,omap4460",
+	"ti,omap4430",
 	"ti,omap4",
 	NULL,
 };
@@ -175,6 +178,8 @@ MACHINE_END
 
 #ifdef CONFIG_SOC_OMAP5
 static const char *omap5_boards_compat[] __initdata = {
+	"ti,omap5432",
+	"ti,omap5430",
 	"ti,omap5",
 	NULL,
 };
@@ -195,6 +200,7 @@ MACHINE_END
 
 #ifdef CONFIG_SOC_AM43XX
 static const char *am43_boards_compat[] __initdata = {
+	"ti,am4372",
 	"ti,am43",
 	NULL,
 };
@@ -212,6 +218,7 @@ MACHINE_END
 
 #ifdef CONFIG_SOC_DRA7XX
 static const char *dra7xx_boards_compat[] __initdata = {
+	"ti,dra7xx",
 	"ti,dra7",
 	NULL,
 };
-- 
1.7.9.5

