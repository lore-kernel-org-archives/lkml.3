Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab3JNFlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 01:41:16 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:24793 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3JNFlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 01:41:02 -0400
From: Bo Shen <voice.shen@atmel.com>
To: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 1/5] ARM: at91: add at91sam9n12 ssc clock in look up table
Date: Mon, 14 Oct 2013 13:38:29 +0800
Message-Id: <1381729113-29714-2-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381729113-29714-1-git-send-email-voice.shen@atmel.com>
References: <1381729113-29714-1-git-send-email-voice.shen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add at91sam9n12 ssc clock in look up table

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
 arch/arm/mach-at91/at91sam9n12.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-at91/at91sam9n12.c b/arch/arm/mach-at91/at91sam9n12.c
index c7d670d..2d895a2 100644
--- a/arch/arm/mach-at91/at91sam9n12.c
+++ b/arch/arm/mach-at91/at91sam9n12.c
@@ -169,6 +169,7 @@ static struct clk_lookup periph_clocks_lookups[] = {
 	CLKDEV_CON_DEV_ID("t0_clk", "f8008000.timer", &tcb_clk),
 	CLKDEV_CON_DEV_ID("t0_clk", "f800c000.timer", &tcb_clk),
 	CLKDEV_CON_DEV_ID("mci_clk", "f0008000.mmc", &mmc_clk),
+	CLKDEV_CON_DEV_ID(NULL, "f0010000.ssc", &ssc_clk),
 	CLKDEV_CON_DEV_ID("dma_clk", "ffffec00.dma-controller", &dma_clk),
 	CLKDEV_CON_DEV_ID(NULL, "f8010000.i2c", &twi0_clk),
 	CLKDEV_CON_DEV_ID(NULL, "f8014000.i2c", &twi1_clk),
-- 
1.7.9.5

