Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab3CKJig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 05:38:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15789 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab3CKJic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 05:38:32 -0400
X-AuditID: cbfee68d-b7f786d000005188-d2-513da6066953
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/3] backlight: jornada720: use dev_err()/dev_info() instead of
 pr_err()/pr_info()
Date: Mon, 11 Mar 2013 18:38:13 +0900
Message-id: <00c901ce1e3c$26d976a0$748c63e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ePCa8v3pUfLowT1qxE3rZdWcGSg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t8zA122ZbaBBke2Slhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mab/b2Aq2alb8XPiPtYHximIXIyeHhICJxPdjq1khbDGJC/fW
	s3UxcnEICSxjlFjSs40FpmjRgfnMEIlFjBL7vv2CcmYzSaz8s4AdpIpNQE3iy5fDQDYHh4iA
	vkRbiwZImFmgVGLrg/dgg4QFUiT+/ljFBFLCIqAq0fTMBiTMK2Ar8WF2AzOELSjxY/I9FohW
	LYnN25pYIWx5ic1r3jKDtEoIqEs8+qsLsUhP4uBHe4gKEYl9L94xghwmIdDOLnF30muwkSwC
	AhLfJh9igWiVldh0gBniK0mJgytusExgFJuFZPEsJItnIVk8C8mKBYwsqxhFUwuSC4qT0osM
	9YoTc4tL89L1kvNzNzFCoqR3B+PtA9aHGJOB1k9klhJNzgdGWV5JvKGxmZGFqYmpsZG5pRlp
	wkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGLn0XbSN2Q9x1+xd3cwZlt6mIet7
	lm/ilW2sYbuudh90Yuqfq5zvc6v9hnvn/LpT8TIWravEIxZmJaT0aN2Wn/LH++se/2MB15yM
	1aesta28E2FXMOsB0/Zpjze/3FQv4NzzzkDi0GYLx7AP55l4pu/IXpnpN6V32w4Gw5i4ukXL
	9F832++cq8RSnJFoqMVcVJwIAM86yrqoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t9jAV22ZbaBBre2sllc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjGm/29gKtmpW/Fz4j7WB
	8YpiFyMnh4SAicSiA/OZIWwxiQv31rN1MXJxCAksYpTY9+0XM4Qzm0li5Z8F7CBVbAJqEl++
	HAayOThEBPQl2lo0QMLMAqUSWx+8ZwGxhQVSJP7+WMUEUsIioCrR9MwGJMwrYCvxYXYDM4Qt
	KPFj8j0WiFYtic3bmlghbHmJzWveMoO0SgioSzz6qwuxSE/i4Ed7iAoRiX0v3jFOYBSYhWTQ
	LCSDZiEZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwTH4TGoH48oGi0OMAhyM
	Sjy8E3RsA4VYE8uKK3MPMUpwMCuJ8K7cZBMoxJuSWFmVWpQfX1Sak1p8iDEZ6M2JzFKiyfnA
	9JBXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYw7Lxu7BOma
	7mButSpdxRt3azHDutNcDpMXLHab+ULu+RG9K1oLS54wHoo7dMrurKij+6TJ+Zt6GP4fTmxc
	x6rMvGGHZJAle4Tn4/SeS1OOV+m0R8Y1b3/lJPye9WrnPnNeAd0r665Ym86Z1mZwzUvzs5jh
	nG/xE6d0nXn4/N4Ri9xU//Tfq4KUWIozEg21mIuKEwF4u5CnBQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_err()/dev_info() are more preferred than pr_err()/pr_info().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/jornada720_bl.c  |   18 +++++++++---------
 drivers/video/backlight/jornada720_lcd.c |   21 ++++++++++-----------
 2 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/video/backlight/jornada720_bl.c b/drivers/video/backlight/jornada720_bl.c
index fef6ce4..3ccb893 100644
--- a/drivers/video/backlight/jornada720_bl.c
+++ b/drivers/video/backlight/jornada720_bl.c
@@ -9,8 +9,6 @@
  *
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/backlight.h>
 #include <linux/device.h>
 #include <linux/fb.h>
@@ -40,11 +38,13 @@ static int jornada_bl_get_brightness(struct backlight_device *bd)
 	ret = jornada_ssp_byte(GETBRIGHTNESS);
 
 	if (jornada_ssp_byte(GETBRIGHTNESS) != TXDUMMY) {
-		pr_err("get brightness timeout\n");
+		dev_err(&bd->dev, "get brightness timeout\n");
 		jornada_ssp_end();
 		return -ETIMEDOUT;
-	} else /* exchange txdummy for value */
+	} else {
+		/* exchange txdummy for value */
 		ret = jornada_ssp_byte(TXDUMMY);
+	}
 
 	jornada_ssp_end();
 
@@ -61,7 +61,7 @@ static int jornada_bl_update_status(struct backlight_device *bd)
 	if ((bd->props.power != FB_BLANK_UNBLANK) || (bd->props.fb_blank != FB_BLANK_UNBLANK)) {
 		ret = jornada_ssp_byte(BRIGHTNESSOFF);
 		if (ret != TXDUMMY) {
-			pr_info("brightness off timeout\n");
+			dev_info(&bd->dev, "brightness off timeout\n");
 			/* turn off backlight */
 			PPSR &= ~PPC_LDD1;
 			PPDR |= PPC_LDD1;
@@ -72,7 +72,7 @@ static int jornada_bl_update_status(struct backlight_device *bd)
 
 		/* send command to our mcu */
 		if (jornada_ssp_byte(SETBRIGHTNESS) != TXDUMMY) {
-			pr_info("failed to set brightness\n");
+			dev_info(&bd->dev, "failed to set brightness\n");
 			ret = -ETIMEDOUT;
 			goto out;
 		}
@@ -86,7 +86,7 @@ static int jornada_bl_update_status(struct backlight_device *bd)
 		 */
 		if (jornada_ssp_byte(BL_MAX_BRIGHT - bd->props.brightness)
 			!= TXDUMMY) {
-			pr_err("set brightness failed\n");
+			dev_err(&bd->dev, "set brightness failed\n");
 			ret = -ETIMEDOUT;
 		}
 
@@ -120,7 +120,7 @@ static int jornada_bl_probe(struct platform_device *pdev)
 
 	if (IS_ERR(bd)) {
 		ret = PTR_ERR(bd);
-		pr_err("failed to register device, err=%x\n", ret);
+		dev_err(&pdev->dev, "failed to register device, err=%x\n", ret);
 		return ret;
 	}
 
@@ -134,7 +134,7 @@ static int jornada_bl_probe(struct platform_device *pdev)
 	jornada_bl_update_status(bd);
 
 	platform_set_drvdata(pdev, bd);
-	pr_info("HP Jornada 700 series backlight driver\n");
+	dev_info(&pdev->dev, "HP Jornada 700 series backlight driver\n");
 
 	return 0;
 }
diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
index 635b305..b061413 100644
--- a/drivers/video/backlight/jornada720_lcd.c
+++ b/drivers/video/backlight/jornada720_lcd.c
@@ -9,8 +9,6 @@
  *
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/device.h>
 #include <linux/fb.h>
 #include <linux/kernel.h>
@@ -27,7 +25,7 @@
 #define LCD_MAX_CONTRAST	0xff
 #define LCD_DEF_CONTRAST	0x80
 
-static int jornada_lcd_get_power(struct lcd_device *dev)
+static int jornada_lcd_get_power(struct lcd_device *ld)
 {
 	/* LDD2 in PPC = LCD POWER */
 	if (PPSR & PPC_LDD2)
@@ -36,17 +34,17 @@ static int jornada_lcd_get_power(struct lcd_device *dev)
 		return FB_BLANK_POWERDOWN;	/* PW OFF */
 }
 
-static int jornada_lcd_get_contrast(struct lcd_device *dev)
+static int jornada_lcd_get_contrast(struct lcd_device *ld)
 {
 	int ret;
 
-	if (jornada_lcd_get_power(dev) != FB_BLANK_UNBLANK)
+	if (jornada_lcd_get_power(ld) != FB_BLANK_UNBLANK)
 		return 0;
 
 	jornada_ssp_start();
 
 	if (jornada_ssp_byte(GETCONTRAST) != TXDUMMY) {
-		pr_err("get contrast failed\n");
+		dev_err(&ld->dev, "get contrast failed\n");
 		jornada_ssp_end();
 		return -ETIMEDOUT;
 	} else {
@@ -56,7 +54,7 @@ static int jornada_lcd_get_contrast(struct lcd_device *dev)
 	}
 }
 
-static int jornada_lcd_set_contrast(struct lcd_device *dev, int value)
+static int jornada_lcd_set_contrast(struct lcd_device *ld, int value)
 {
 	int ret;
 
@@ -67,7 +65,7 @@ static int jornada_lcd_set_contrast(struct lcd_device *dev, int value)
 
 	/* push the new value */
 	if (jornada_ssp_byte(value) != TXDUMMY) {
-		pr_err("set contrast failed\n");
+		dev_err(&ld->dev, "set contrast failed\n");
 		jornada_ssp_end();
 		return -ETIMEDOUT;
 	}
@@ -78,13 +76,14 @@ static int jornada_lcd_set_contrast(struct lcd_device *dev, int value)
 	return 0;
 }
 
-static int jornada_lcd_set_power(struct lcd_device *dev, int power)
+static int jornada_lcd_set_power(struct lcd_device *ld, int power)
 {
 	if (power != FB_BLANK_UNBLANK) {
 		PPSR &= ~PPC_LDD2;
 		PPDR |= PPC_LDD2;
-	} else
+	} else {
 		PPSR |= PPC_LDD2;
+	}
 
 	return 0;
 }
@@ -105,7 +104,7 @@ static int jornada_lcd_probe(struct platform_device *pdev)
 
 	if (IS_ERR(lcd_device)) {
 		ret = PTR_ERR(lcd_device);
-		pr_err("failed to register device\n");
+		dev_err(&pdev->dev, "failed to register device\n");
 		return ret;
 	}
 
-- 
1.7.2.5


