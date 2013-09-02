Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab3IBOU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 10:20:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43477 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab3IBOU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 10:20:57 -0400
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH RFC 4/6] ARM: OMAP2+: AM43x/AM335x: have reset controller
Date: Mon, 2 Sep 2013 19:50:28 +0530
Message-ID: <54ef6f33272dfe2bbf3596da05579a7305fb0cff.1378129416.git.afzal@ti.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <cover.1378129416.git.afzal@ti.com>
References: <cover.1378129416.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AM43x, AM335x have reset block as part of prcm, let reset driver be
usable with these SoC's.

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---
 arch/arm/mach-omap2/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 3eed000..fa28d1d 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -72,6 +72,7 @@ config SOC_AM33XX
 	select CPU_V7
 	select MULTI_IRQ_HANDLER
 	select COMMON_CLK
+	select ARCH_HAS_RESET_CONTROLLER
 
 config SOC_AM43XX
 	bool "TI AM43x"
@@ -82,6 +83,7 @@ config SOC_AM43XX
 	select ARM_GIC
 	select COMMON_CLK
 	select MACH_OMAP_GENERIC
+	select ARCH_HAS_RESET_CONTROLLER
 
 config ARCH_OMAP2PLUS
 	bool
-- 
1.8.3.4

