Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936273Ab3DHOYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:24:03 -0400
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:55993 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935411Ab3DHOYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:24:01 -0400
Message-ID: <1365431039.1830.102.camel@x61.thuisdomein>
Subject: [PATCH] ARM: imx: remove configs ARCH_MX5 and ARCH_MX51
From: Paul Bolle <pebolle@tiscali.nl>
To: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 16:23:59 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Apr 2013 14:23:59.0226 (UTC) FILETIME=[B5D3E5A0:01CE3464]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbols ARCH_MX5 and ARCH_MX51 are unused since v3.3. They
can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep" only.

 arch/arm/mach-imx/Kconfig | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 6d9ae09..cbd6942 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -92,12 +92,6 @@ config ARCH_MX25
 config MACH_MX27
 	bool
 
-config ARCH_MX5
-	bool
-
-config ARCH_MX51
-	bool
-
 config ARCH_MX53
 	bool
 
@@ -155,7 +149,6 @@ config SOC_IMX35
 config SOC_IMX5
 	bool
 	select ARCH_HAS_CPUFREQ
-	select ARCH_MX5
 	select ARCH_MXC_IOMUX_V3
 	select COMMON_CLK
 	select CPU_V7
@@ -163,8 +156,6 @@ config SOC_IMX5
 
 config	SOC_IMX51
 	bool
-	select ARCH_MX5
-	select ARCH_MX51
 	select PINCTRL
 	select PINCTRL_IMX51
 	select SOC_IMX5
@@ -787,7 +778,6 @@ comment "Device tree only"
 
 config	SOC_IMX53
 	bool "i.MX53 support"
-	select ARCH_MX5
 	select ARCH_MX53
 	select HAVE_CAN_FLEXCAN if CAN
 	select IMX_HAVE_PLATFORM_IMX2_WDT
-- 
1.7.11.7

