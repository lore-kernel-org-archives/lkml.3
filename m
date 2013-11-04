Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3KDFTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 00:19:36 -0500
Received: from top.free-electrons.com ([176.31.233.9]:60430 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750722Ab3KDFTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 00:19:35 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: kernel@pengutronix.de, linux@arm.linux.org.uk
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] ARM: imx: removed unused MACH_MXLADS Kconfig parameter
Date: Mon,  4 Nov 2013 06:19:26 +0100
Message-Id: <1383542366-6270-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the MACH_MXLADS Kconfig parameter,
which was no longer used anywhere in the source code
and Makefiles.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/arm/mach-imx/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 29a8af6922a8..d84a772bbc68 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -158,14 +158,11 @@ config	SOC_IMX51
 if ARCH_MULTI_V4T
 
 comment "MX1 platforms:"
-config MACH_MXLADS
-	bool
 
 config ARCH_MX1ADS
 	bool "MX1ADS platform"
 	select IMX_HAVE_PLATFORM_IMX_I2C
 	select IMX_HAVE_PLATFORM_IMX_UART
-	select MACH_MXLADS
 	select SOC_IMX1
 	help
 	  Say Y here if you are using Motorola MX1ADS/MXLADS boards
-- 
1.8.1.2

