Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935583Ab3DQBE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:04:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56703 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab3DQBE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:04:57 -0400
X-AuditID: cbfee690-b7f656d0000007e3-42-516df5376049
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002d01ce3b07$4d838d80$e88aa880$%han@samsung.com>
In-reply-to: <002d01ce3b07$4d838d80$e88aa880$%han@samsung.com>
Subject: [PATCH RESEND 3/3] backlight: vgg2432a4: convert vgg2432a4_driver to
 dev_pm_ops
Date: Wed, 17 Apr 2013 10:04:54 +0900
Message-id: <002f01ce3b07$9274efb0$b75ecf10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac47B00Xwwr4eF6YRha9Jkf5kKWYlAAADejg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zA13zr7mBBi92CFnMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBln5k9g
	KTglU9F3fyFrA+MP8S5GDg4JAROJxpXaXYycQKaYxIV769m6GLk4hASWMUqcPL+GGSJhIvFj
	8xNGiMQiRok7R09DOb8YJTZOnsAIUsUmoCbx5cthdpCpIgL6Em0tGiBhZoFSia0P3rOA2EIC
	thJPj78DG8opYCex/ddtMFtYIEpiVvNuNhCbRUBV4sy7uWD1vED1b04sY4ewBSV+TL7HAjFT
	S2L9zuNMELa8xOY1b5khnlGXePRXF+ICI4nrp2ogKkQk9r14B3axhMApdonLGzcwQqwSkPg2
	+RALRKusxKYDUO9KShxccYNlAqPELCSLZyFZPAvJ4llIVixgZFnFKJpakFxQnJReZKJXnJhb
	XJqXrpecn7uJERKRE3Yw3jtgfYgxGWj9RGYp0eR8YETnlcQbGpsZWZiamBobmVuakSasJM6r
	3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFxnuauBLWyCVyGf9blyGybJ3vhz84btQ95
	Wg4srVkj/dn7xLfJ8r3OfxXPn1DXTj19+KvlwcbGBX48FuZGa9o4Y151NBtve666Pm3/JxOB
	S2sjOFbdrHu4L1RDzib1wbknG9seBjao/ioylWi2DVjY9eCBIGdb/4+Fvkeaj1gs3rDM7/++
	p9OvKbEUZyQaajEXFScCADwmGe3eAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAV3zr7mBBm+n81nMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZZ+ZPYCk4JVPRd38hawPjD/EuRk4OCQETiR+bnzBC2GISF+6t
	Z+ti5OIQEljEKHHn6GlGCOcXo8TGyRPAqtgE1CS+fDnM3sXIwSEioC/R1qIBEmYWKJXY+uA9
	C4gtJGAr8fT4O2YQm1PATmL7r9tgtrBAlMSs5t1sIDaLgKrEmXdzwep5gerfnFjGDmELSvyY
	fI8FYqaWxPqdx5kgbHmJzWveMoOslRBQl3j0VxfiAiOJ66dqICpEJPa9eMc4gVFoFpJBs5AM
	moVk0CwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEf8M+kdjKsaLA4xCnAwKvHw
	XijIDRRiTSwrrsw9xCjBwawkwqu4CijEm5JYWZValB9fVJqTWnyIMRnoz4nMUqLJ+cBklFcS
	b2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjPGWM4Rddugx3ShS
	3Pq3V7Z1pivjFsUiR/mAXTwsEd3Jv0IW3X7Yp7P7xGO1TE+eOWwcwfa/2pKvf6tTi94dqH/3
	9pbun2IrLtTP7MlbljdvWo+tWuVnlQ3/ZTtPt2n/43tin5B3x8Cpd3agQP6vdQ0Bup916+t6
	Hy4uLYzxuHQp/uNUl58SSizFGYmGWsxFxYkA8l4SIjwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management. Also, use of
pm_message_t is deprecated. Thus, it is removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ili9320.c   |   24 +++++++++---------------
 drivers/video/backlight/ili9320.h   |    2 +-
 drivers/video/backlight/vgg2432a4.c |   18 ++++++++----------
 3 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/drivers/video/backlight/ili9320.c b/drivers/video/backlight/ili9320.c
index c3a5299..f8be90c 100644
--- a/drivers/video/backlight/ili9320.c
+++ b/drivers/video/backlight/ili9320.c
@@ -270,27 +270,21 @@ int ili9320_remove(struct ili9320 *ili)
 }
 EXPORT_SYMBOL_GPL(ili9320_remove);
 
-#ifdef CONFIG_PM
-int ili9320_suspend(struct ili9320 *lcd, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+int ili9320_suspend(struct ili9320 *lcd)
 {
 	int ret;
 
-	dev_dbg(lcd->dev, "%s: event %d\n", __func__, state.event);
+	ret = ili9320_power(lcd, FB_BLANK_POWERDOWN);
 
-	if (state.event == PM_EVENT_SUSPEND) {
-		ret = ili9320_power(lcd, FB_BLANK_POWERDOWN);
-
-		if (lcd->platdata->suspend == ILI9320_SUSPEND_DEEP) {
-			ili9320_write(lcd, ILI9320_POWER1, lcd->power1 |
-				      ILI9320_POWER1_SLP |
-				      ILI9320_POWER1_DSTB);
-			lcd->initialised = 0;
-		}
-
-		return ret;
+	if (lcd->platdata->suspend == ILI9320_SUSPEND_DEEP) {
+		ili9320_write(lcd, ILI9320_POWER1, lcd->power1 |
+			      ILI9320_POWER1_SLP |
+			      ILI9320_POWER1_DSTB);
+		lcd->initialised = 0;
 	}
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(ili9320_suspend);
 
diff --git a/drivers/video/backlight/ili9320.h b/drivers/video/backlight/ili9320.h
index e0db738..42329e7 100644
--- a/drivers/video/backlight/ili9320.h
+++ b/drivers/video/backlight/ili9320.h
@@ -76,5 +76,5 @@ extern void ili9320_shutdown(struct ili9320 *lcd);
 
 /* PM */
 
-extern int ili9320_suspend(struct ili9320 *lcd, pm_message_t state);
+extern int ili9320_suspend(struct ili9320 *lcd);
 extern int ili9320_resume(struct ili9320 *lcd);
diff --git a/drivers/video/backlight/vgg2432a4.c b/drivers/video/backlight/vgg2432a4.c
index 84d582f..d538947 100644
--- a/drivers/video/backlight/vgg2432a4.c
+++ b/drivers/video/backlight/vgg2432a4.c
@@ -205,18 +205,15 @@ static int vgg2432a4_lcd_init(struct ili9320 *lcd,
 	return ret;
 }
 
-#ifdef CONFIG_PM
-static int vgg2432a4_suspend(struct spi_device *spi, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int vgg2432a4_suspend(struct device *dev)
 {
-	return ili9320_suspend(spi_get_drvdata(spi), state);
+	return ili9320_suspend(dev_get_drvdata(dev));
 }
-static int vgg2432a4_resume(struct spi_device *spi)
+static int vgg2432a4_resume(struct device *dev)
 {
-	return ili9320_resume(spi_get_drvdata(spi));
+	return ili9320_resume(dev_get_drvdata(dev));
 }
-#else
-#define vgg2432a4_suspend	NULL
-#define vgg2432a4_resume	NULL
 #endif
 
 static struct ili9320_client vgg2432a4_client = {
@@ -249,16 +246,17 @@ static void vgg2432a4_shutdown(struct spi_device *spi)
 	ili9320_shutdown(spi_get_drvdata(spi));
 }
 
+static SIMPLE_DEV_PM_OPS(vgg2432a4_pm_ops, vgg2432a4_suspend, vgg2432a4_resume);
+
 static struct spi_driver vgg2432a4_driver = {
 	.driver = {
 		.name		= "VGG2432A4",
 		.owner		= THIS_MODULE,
+		.pm		= &vgg2432a4_pm_ops,
 	},
 	.probe		= vgg2432a4_probe,
 	.remove		= vgg2432a4_remove,
 	.shutdown	= vgg2432a4_shutdown,
-	.suspend	= vgg2432a4_suspend,
-	.resume		= vgg2432a4_resume,
 };
 
 module_spi_driver(vgg2432a4_driver);
-- 
1.7.2.5


