Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab3E0OgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:36:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57201 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932587Ab3E0OgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:36:06 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: [PATCH v2 02/14] ARM: OMAP2+: AM43x: Kconfig
Date: Mon, 27 May 2013 20:05:31 +0530
Message-ID: <7642e0c701680ea94a8cc84059ff19e500813bf1.1369658705.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1369658705.git.afzal@ti.com>
References: <cover.1369658705.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig for AM43x (Cortex A9) family of SoC's.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---

v2: Remove reliance on SMP, TWD, select MACH_OMAP_GENERIC

 arch/arm/mach-omap2/Kconfig | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index f49cd51..8f555f8 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -149,6 +149,16 @@ config SOC_AM33XX
 	select MULTI_IRQ_HANDLER
 	select COMMON_CLK
 
+config SOC_AM43XX
+	bool "TI AM43x"
+	depends on ARCH_OMAP2PLUS
+	default y
+	select CPU_V7
+	select MULTI_IRQ_HANDLER
+	select ARM_GIC
+	select COMMON_CLK
+	select MACH_OMAP_GENERIC
+
 config OMAP_PACKAGE_ZAF
        bool
 
-- 
1.7.12

