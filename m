Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbaGOR1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:27:52 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:41632 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbaGORCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:07 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 07/94] clk: samsung: add more aliases for s3c24xx
Date: Tue, 15 Jul 2014 20:00:22 +0300
Message-Id: <1405443709-15288-7-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasily Khoruzhick <anarsoul@gmail.com>

Without these aliases clock lookup fails in s3c2410fb,
s3cmci, s3c2410-nand, s3c24xx-i2s, and i2c-s3c2410 drivers.

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/clk/samsung/clk-s3c2410.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clk/samsung/clk-s3c2410.c b/drivers/clk/samsung/clk-s3c2410.c
index bd9a873..140f473 100644
--- a/drivers/clk/samsung/clk-s3c2410.c
+++ b/drivers/clk/samsung/clk-s3c2410.c
@@ -152,6 +152,11 @@ struct samsung_clock_alias s3c2410_common_aliases[] __initdata = {
 	ALIAS(HCLK, NULL, "hclk"),
 	ALIAS(MPLL, NULL, "mpll"),
 	ALIAS(FCLK, NULL, "fclk"),
+	ALIAS(PCLK, NULL, "watchdog"),
+	ALIAS(PCLK_SDI, NULL, "sdi"),
+	ALIAS(HCLK_NAND, NULL, "nand"),
+	ALIAS(PCLK_I2S, NULL, "iis"),
+	ALIAS(PCLK_I2C, NULL, "i2c"),
 };
 
 /* S3C2410 specific clocks */
-- 
1.7.10.4

