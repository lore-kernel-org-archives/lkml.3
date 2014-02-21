Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaBUGmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 01:42:06 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:57194 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaBUGmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 01:42:01 -0500
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-pm@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] video: da8xx-fb: fix typos
Date: Fri, 21 Feb 2014 12:11:04 +0530
Message-Id: <1392964864-25371-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch fixes couple of typos in the comments
for da8xx-fb.c file.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/video/da8xx-fb.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index a1d74dd..dced43a 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -265,7 +265,7 @@ static void lcd_enable_raster(void)
 		lcdc_write(0, LCD_CLK_RESET_REG);
 	mdelay(1);
 
-	/* Above reset sequence doesnot reset register context */
+	/* Above reset sequence does not reset register context */
 	reg = lcdc_read(LCD_RASTER_CTRL_REG);
 	if (!(reg & LCD_RASTER_ENABLE))
 		lcdc_write(reg | LCD_RASTER_ENABLE, LCD_RASTER_CTRL_REG);
@@ -357,7 +357,7 @@ static void lcd_blit(int load_mode, struct da8xx_fb_par *par)
 	lcd_enable_raster();
 }
 
-/* Configure the Burst Size and fifo threhold of DMA */
+/* Configure the Burst Size and fifo threshold of DMA */
 static int lcd_cfg_dma(int burst_size, int fifo_th)
 {
 	u32 reg;
@@ -393,7 +393,7 @@ static void lcd_cfg_ac_bias(int period, int transitions_per_int)
 {
 	u32 reg;
 
-	/* Set the AC Bias Period and Number of Transisitons per Interrupt */
+	/* Set the AC Bias Period and Number of Transitions per Interrupt */
 	reg = lcdc_read(LCD_RASTER_TIMING_2_REG) & 0xFFF00000;
 	reg |= LCD_AC_BIAS_FREQUENCY(period) |
 		LCD_AC_BIAS_TRANSITIONS_PER_INT(transitions_per_int);
-- 
1.7.9.5

