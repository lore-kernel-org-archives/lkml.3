Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaBLKKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:10:23 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:43279 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbaBLKKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:10:16 -0500
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, b.brezillon@overkiz.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregory.clement@free-electrons.com,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: [PATCH v4 8/8] ARM: at91: move sam9261 SoC to common clk
Date: Wed, 12 Feb 2014 11:06:47 +0100
Message-Id: <1392199607-27452-9-git-send-email-jjhiblot@traphandler.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
References: <1392199607-27452-1-git-send-email-jjhiblot@traphandler.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the selection of AT91_USE_OLD_CLK when selecting
sam9261 SoCs support. This will automatically enable COMMON_CLK_AT91 option
and add support for at91 common clk implementation.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
---
 arch/arm/mach-at91/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
index 4f0e800..5af3f07 100644
--- a/arch/arm/mach-at91/Kconfig
+++ b/arch/arm/mach-at91/Kconfig
@@ -119,7 +119,6 @@ config SOC_AT91SAM9261
 	select HAVE_AT91_DBGU0
 	select HAVE_FB_ATMEL
 	select SOC_AT91SAM9
-	select AT91_USE_OLD_CLK
 	select HAVE_AT91_USB_CLK
 	help
 	  Select this if you are using one of Atmel's AT91SAM9261 or AT91SAM9G10 SoC.
-- 
1.8.5.3

