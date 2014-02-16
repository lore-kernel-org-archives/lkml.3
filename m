Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaBPSDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 13:03:34 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:54767 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbaBPSDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 13:03:33 -0500
Message-ID: <1392573811.28866.22.camel@x220>
Subject: [PATCH] arm: imx: remove MACH_MXLADS
From: Paul Bolle <pebolle@tiscali.nl>
To: Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Sun, 16 Feb 2014 19:03:31 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2014 18:03:31.0933 (UTC) FILETIME=[6714F8D0:01CF2B41]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol MACH_MXLADS was added in v2.6.29. It has never been
used. Setting it has no effect. There are no calls for
machine_is_mxlads(). This symbol can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep".

 arch/arm/mach-imx/Kconfig | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 33567aa..f564be8 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -144,14 +144,10 @@ config	SOC_IMX51
 if ARCH_MULTI_V4T
 
 comment "MX1 platforms:"
-config MACH_MXLADS
-	bool
-
 config ARCH_MX1ADS
 	bool "MX1ADS platform"
 	select IMX_HAVE_PLATFORM_IMX_I2C
 	select IMX_HAVE_PLATFORM_IMX_UART
-	select MACH_MXLADS
 	select SOC_IMX1
 	help
 	  Say Y here if you are using Motorola MX1ADS/MXLADS boards
-- 
1.8.5.3

