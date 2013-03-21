Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab3CULZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:25:46 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:55063 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752479Ab3CULZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:25:44 -0400
Message-ID: <1363865141.1390.120.camel@x61.thuisdomein>
Subject: [PATCH] ARM: SAMSUNG: Remove useless Samsung GPIO related CONFIG
From: Paul Bolle <pebolle@tiscali.nl>
To: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Mar 2013 12:25:41 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Mar 2013 11:25:42.0248 (UTC) FILETIME=[D27F1680:01CE2626]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry for S3C_GPIO_CFG_S3C64XX was missed by commit
5ec7414494ed1204c9e2ed0b8232b29860d0986f ("ARM: SAMSUNG: Remove useless
Samsung GPIO related CONFIGs"). Remove it now.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

 arch/arm/plat-samsung/Kconfig | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
index 663c54f..91c2d72 100644
--- a/arch/arm/plat-samsung/Kconfig
+++ b/arch/arm/plat-samsung/Kconfig
@@ -117,12 +117,6 @@ config SAMSUNG_GPIOLIB_4BIT
 	  configuration. GPIOlib shall be compiled only for S3C64XX and S5P
 	  series of processors.
 
-config S3C_GPIO_CFG_S3C64XX
-	bool
-	help
-	  Internal configuration to enable S3C64XX style GPIO configuration
-	  functions.
-
 config S5P_GPIO_DRVSTR
 	bool
 	help
-- 
1.7.11.7

