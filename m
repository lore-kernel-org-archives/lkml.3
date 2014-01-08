Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaAHCa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 21:30:26 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40870 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbaAHCaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 21:30:18 -0500
From: John Tobias <john.tobias.ph@gmail.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: shawn.guo@linaro.org, John Tobias <john.tobias.ph@gmail.com>
Subject: [PATCH v2] ARM: imx: select ARCH_HAS_CPUFREQ for iMX6SL
Date: Tue,  7 Jan 2014 18:29:23 -0800
Message-Id: <1389148163-5243-1-git-send-email-john.tobias.ph@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iMX6SL now supports the cpufreq scaling by re-using the imx6q-cpufreq driver.
By adding it, the user has the capability to select the said driver without
depending it to SOC_IMX6Q.

Signed-off-by: John Tobias <john.tobias.ph@gmail.com>
---
Changes since v1:
- Fix typo in commit log
- Added Shawn Guo on Cc

 arch/arm/mach-imx/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 7a6e6f7..704e5ae 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -808,6 +808,7 @@ config SOC_IMX6Q
 
 config SOC_IMX6SL
 	bool "i.MX6 SoloLite support"
+	select ARCH_HAS_CPUFREQ
 	select ARM_ERRATA_754322
 	select ARM_ERRATA_775420
 	select ARM_GIC
-- 
1.8.3.2

