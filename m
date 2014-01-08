Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbaAHDSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 22:18:01 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52179 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbaAHDR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 22:17:56 -0500
From: John Tobias <john.tobias.ph@gmail.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: shawn.guo@linaro.org, John Tobias <john.tobias.ph@gmail.com>
Subject: [PATCH] ARM: imx: select PM_OPP for iMX6SL
Date: Tue,  7 Jan 2014 19:17:29 -0800
Message-Id: <1389151049-13451-1-git-send-email-john.tobias.ph@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PM_OPP is required if the user wants to use the imx6q-cpufreq driver.

Signed-off-by: John Tobias <john.tobias.ph@gmail.com>
---
 arch/arm/mach-imx/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 704e5ae..5e73596 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -823,6 +823,7 @@ config SOC_IMX6SL
 	select PL310_ERRATA_588369 if CACHE_PL310
 	select PL310_ERRATA_727915 if CACHE_PL310
 	select PL310_ERRATA_769419 if CACHE_PL310
+	select PM_OPP if PM
 
 	help
 	  This enables support for Freescale i.MX6 SoloLite processor.
-- 
1.8.3.2

