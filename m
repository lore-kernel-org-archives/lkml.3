Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3GAIkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:40:08 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48261 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab3GAIkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:40:04 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [RFC PATCH 03/13] ARM: at91: DTS: sam9x5: add clock for SSC DT entry
Date: Mon,  1 Jul 2013 10:39:28 +0200
Message-Id: <1372667978-4718-4-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
References: <1372667978-4718-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
---
 arch/arm/mach-at91/at91sam9x5.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-at91/at91sam9x5.c b/arch/arm/mach-at91/at91sam9x5.c
index 2abee66..191eb4b 100644
--- a/arch/arm/mach-at91/at91sam9x5.c
+++ b/arch/arm/mach-at91/at91sam9x5.c
@@ -233,6 +233,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("mci_clk", "f000c000.mmc", &mmc1_clk),
 	CLKDEV_CON_DEV_ID("dma_clk", "ffffec00.dma-controller", &dma0_clk),
 	CLKDEV_CON_DEV_ID("dma_clk", "ffffee00.dma-controller", &dma1_clk),
+	CLKDEV_CON_DEV_ID("pclk", "at91sam9g45_ssc.0", &ssc_clk),
 	CLKDEV_CON_DEV_ID("pclk", "f0010000.ssc", &ssc_clk),
 	CLKDEV_CON_DEV_ID(NULL, "f8010000.i2c", &twi0_clk),
 	CLKDEV_CON_DEV_ID(NULL, "f8014000.i2c", &twi1_clk),
-- 
1.7.10.4

