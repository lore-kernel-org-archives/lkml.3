Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaAHBoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 20:44:46 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37352 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbaAHBoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 20:44:37 -0500
From: John Tobias <john.tobias.ph@gmail.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: John Tobias <john.tobias.ph@gmail.com>
Subject: [PATCH] ARM: imx: select ARCH_HAS_CPUFREQ for iMX6SL
Date: Tue,  7 Jan 2014 17:44:04 -0800
Message-Id: <1389145444-61816-1-git-send-email-john.tobias.ph@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iMX6SL now supported the cpufreq scaling by re-using the imx6q-cpufreq driver.
By adding it, the user has the capability to select the said driver without
depending it to SOC_IMX6Q.

Signed-off-by: John Tobias <john.tobias.ph@gmail.com>
---
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

