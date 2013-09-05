Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935534Ab3IECor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 22:44:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:65118 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935517Ab3IECon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 22:44:43 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-06-5227f0101c78
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Milo Kim'" <milo.kim@ti.com>,
        "'Daniel Jeong'" <gshark.jeong@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002101cea9e1$34a38330$9dea8990$%han@samsung.com>
In-reply-to: <002101cea9e1$34a38330$9dea8990$%han@samsung.com>
Subject: [PATCH 6/6] backlight: use dev_get_platdata()
Date: Thu, 05 Sep 2013 11:44:32 +0900
Message-id: <002701cea9e1$d98bb2f0$8ca318d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6p4TRpKe++09SiQwq9N1m2ivIIowAAIfew
Content-language: ko
x-cr-hashedpuzzle: H+nr KwOP M/1V UFrI UQoj mv+V nnuW s1+z 3yfT 4Z3b +5CT /Bek
 /5In AAKLIw== AAlAwg==
 AAlhEw==;6;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGcAcwBoAGEAcgBrAC4AagBlAG8AbgBnAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AG0AaQBsAG8ALgBrAGkAbQBAAHQAaQAuAGMAbwBtADsAcgBwAHUAcgBkAGkAZQBAAHIAcABzAHkAcwAuAG4AZQB0AA==;Sosha1_v1;7;{606DABC7-6DF8-4F81-AF2E-3D8CA31805A9};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 05 Sep 2013 02:44:22
 GMT;WwBQAEEAVABDAEgAIAA2AC8ANgBdACAAYgBhAGMAawBsAGkAZwBoAHQAOgAgAHUAcwBlACAAZABlAHYAXwBnAGUAdABfAHAAbABhAHQAZABhAHQAYQAoACkA
x-cr-puzzleid: {606DABC7-6DF8-4F81-AF2E-3D8CA31805A9}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t8zQ12BD+pBBlP3KlvMWb+GzWLy7i5W
	i8sLLwGJXXPYLJb/WsdisXvXU1YHNo+ds+6ye5yY8ZvFY8/8H6wefVtWMXocv7GdyePzJrkA
	tigum5TUnMyy1CJ9uwSujJmbXjEWLN/GWLFi/wamBsam2YxdjJwcEgImEgv/vGOFsMUkLtxb
	z9bFyMUhJLCMUeLt4xdsMEUTlsxigkhMZ5T4P2kVK4Tzi1Hiz6x/zCBVbAJqEl++HGbvYuTg
	EBHQl2hr0QCpYRbYyiix+eNusBVCArYS55fMBpvKKWAn8enHXrAzhAXMJK5+eQA2h0VAVeLl
	1T9gNi9Q/fbvz1kgbEGJH5PvgdnMAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXZCwiICRxI/O
	34wQJSIS+168YwS5R0LgBqvE9473TBCfmUrcf7GSDSLRyyHx7fYJVogjBCS+TT7EAjFUVmLT
	AWaIekmJgytusExglJqF5KRZSE6aheSkWUh2L2BkWcUomlqQXFCclF5kqlecmFtcmpeul5yf
	u4kREvUTdzDeP2B9iDEZaP1EZinR5Hxg0sgriTc0NjOyMDUxNTYytzQjTVhJnFe9xTpQSCA9
	sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2N6a91pw0Ps+Z+L35c3T2G+KLPUQtDjXtiPQxtf3PsY
	fXOR5iNTrhMidaWaukd6Di7TUJP4uVn+rLxt5XPVD/M+rolXXOb2cqOAidak992nNTuaWZ58
	eF4z6+mNueza3A5zb3xZOdNiMh/jyglLtERazjwuMXdlWVsixRvHaO3tevPXzhVBU5uVWIoz
	Eg21mIuKEwFc3O5CEAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFKsWRmVeSWpSXmKPExsVy+t9jQV2BD+pBBt8my1jMWb+GzWLy7i5W
	i8sLLwGJXXPYLJb/WsdisXvXU1YHNo+ds+6ye5yY8ZvFY8/8H6wefVtWMXocv7GdyePzJrkA
	tqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDuU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBkzN71iLFi+jbFixf4NTA2M
	TbMZuxg5OSQETCQmLJnFBGGLSVy4t56ti5GLQ0hgOqPE/0mrWCGcX4wSf2b9YwapYhNQk/jy
	5TB7FyMHh4iAvkRbiwZIDbPAVkaJzR93s4LUCAnYSpxfMpsNxOYUsJP49GMv2DZhATOJq18e
	gM1hEVCVeHn1D5jNC1S//ftzFghbUOLH5HtgNrOAlsT6nceZIGx5ic1r3jKD7JUQUJd49FcX
	JCwiYCTxo/M3I0SJiMS+F+8YQe6RELjBKvG94z3UZ6YS91+sZJvAKDILyYpZSFbMQrJiFpJZ
	CxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEp5Rn0jsYVzVYHGIU4GBU4uFtMFYPEmJN
	LCuuzD3EKMHBrCTCa7ESKMSbklhZlVqUH19UmpNafIgxGRgCE5mlRJPzgekuryTe0NjEzMjS
	yMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYJx9YKOTWuHK388evC57FP1qe
	s8rFyZWJ+7duwcTbIbxvFLX8Qg4kdb45uDyV99XxNQ+CfG7OXFTP4xXrxXhxQds53RIbObv7
	n+d1Bc2Ld39q8L8+b8uePbWP+MIdq7rKZucU7lTZfXETZ7u635wFaqse2OmHFMhMfHa66r24
	4nuukxYZWgk/lViKMxINtZiLihMBLQZvtW0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/88pm860x_bl.c        |    2 +-
 drivers/video/backlight/aat2870_bl.c         |    2 +-
 drivers/video/backlight/adp5520_bl.c         |    2 +-
 drivers/video/backlight/adp8860_bl.c         |    6 +++---
 drivers/video/backlight/adp8870_bl.c         |    6 +++---
 drivers/video/backlight/ams369fg06.c         |    2 +-
 drivers/video/backlight/atmel-pwm-bl.c       |    2 +-
 drivers/video/backlight/bd6107.c             |    2 +-
 drivers/video/backlight/corgi_lcd.c          |    2 +-
 drivers/video/backlight/da903x_bl.c          |    2 +-
 drivers/video/backlight/generic_bl.c         |    2 +-
 drivers/video/backlight/gpio_backlight.c     |    3 ++-
 drivers/video/backlight/ili9320.c            |    2 +-
 drivers/video/backlight/kb3886_bl.c          |    2 +-
 drivers/video/backlight/l4f00242t03.c        |    6 +++---
 drivers/video/backlight/ld9040.c             |    2 +-
 drivers/video/backlight/lm3533_bl.c          |    2 +-
 drivers/video/backlight/lm3630a_bl.c         |    2 +-
 drivers/video/backlight/lm3639_bl.c          |    2 +-
 drivers/video/backlight/lms283gf05.c         |    4 ++--
 drivers/video/backlight/lms501kf03.c         |    2 +-
 drivers/video/backlight/lp855x_bl.c          |    4 ++--
 drivers/video/backlight/lv5207lp.c           |    2 +-
 drivers/video/backlight/omap1_bl.c           |    2 +-
 drivers/video/backlight/pcf50633-backlight.c |    2 +-
 drivers/video/backlight/platform_lcd.c       |    2 +-
 drivers/video/backlight/pwm_bl.c             |    2 +-
 drivers/video/backlight/s6e63m0.c            |    2 +-
 drivers/video/backlight/tdo24m.c             |    2 +-
 drivers/video/backlight/tosa_bl.c            |    2 +-
 drivers/video/backlight/tps65217_bl.c        |    5 ++---
 drivers/video/backlight/wm831x_bl.c          |    8 +++-----
 32 files changed, 44 insertions(+), 46 deletions(-)

diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index 2cd6350..a84a12a 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -196,7 +196,7 @@ static int pm860x_backlight_dt_init(struct platform_device *pdev,
 static int pm860x_backlight_probe(struct platform_device *pdev)
 {
 	struct pm860x_chip *chip = dev_get_drvdata(pdev->dev.parent);
-	struct pm860x_backlight_pdata *pdata = pdev->dev.platform_data;
+	struct pm860x_backlight_pdata *pdata = dev_get_platdata(&pdev->dev);
 	struct pm860x_backlight_data *data;
 	struct backlight_device *bl;
 	struct resource *res;
diff --git a/drivers/video/backlight/aat2870_bl.c b/drivers/video/backlight/aat2870_bl.c
index c6fc668..c68232b 100644
--- a/drivers/video/backlight/aat2870_bl.c
+++ b/drivers/video/backlight/aat2870_bl.c
@@ -127,7 +127,7 @@ static const struct backlight_ops aat2870_bl_ops = {
 
 static int aat2870_bl_probe(struct platform_device *pdev)
 {
-	struct aat2870_bl_platform_data *pdata = pdev->dev.platform_data;
+	struct aat2870_bl_platform_data *pdata = dev_get_platdata(&pdev->dev);
 	struct aat2870_bl_driver_data *aat2870_bl;
 	struct backlight_device *bd;
 	struct backlight_properties props;
diff --git a/drivers/video/backlight/adp5520_bl.c b/drivers/video/backlight/adp5520_bl.c
index c84701b..fe8e3d1 100644
--- a/drivers/video/backlight/adp5520_bl.c
+++ b/drivers/video/backlight/adp5520_bl.c
@@ -297,7 +297,7 @@ static int adp5520_bl_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	data->master = pdev->dev.parent;
-	data->pdata = pdev->dev.platform_data;
+	data->pdata = dev_get_platdata(&pdev->dev);
 
 	if (data->pdata  == NULL) {
 		dev_err(&pdev->dev, "missing platform data\n");
diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index 75b10f8..2f77f37 100644
--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -216,7 +216,7 @@ static int adp8860_led_setup(struct adp8860_led *led)
 static int adp8860_led_probe(struct i2c_client *client)
 {
 	struct adp8860_backlight_platform_data *pdata =
-		client->dev.platform_data;
+		dev_get_platdata(&client->dev);
 	struct adp8860_bl *data = i2c_get_clientdata(client);
 	struct adp8860_led *led, *led_dat;
 	struct led_info *cur_led;
@@ -300,7 +300,7 @@ static int adp8860_led_probe(struct i2c_client *client)
 static int adp8860_led_remove(struct i2c_client *client)
 {
 	struct adp8860_backlight_platform_data *pdata =
-		client->dev.platform_data;
+		dev_get_platdata(&client->dev);
 	struct adp8860_bl *data = i2c_get_clientdata(client);
 	int i;
 
@@ -658,7 +658,7 @@ static int adp8860_probe(struct i2c_client *client,
 	struct backlight_device *bl;
 	struct adp8860_bl *data;
 	struct adp8860_backlight_platform_data *pdata =
-		client->dev.platform_data;
+		dev_get_platdata(&client->dev);
 	struct backlight_properties props;
 	uint8_t reg_val;
 	int ret;
diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
index 90049d7..9eee69f 100644
--- a/drivers/video/backlight/adp8870_bl.c
+++ b/drivers/video/backlight/adp8870_bl.c
@@ -238,7 +238,7 @@ static int adp8870_led_setup(struct adp8870_led *led)
 static int adp8870_led_probe(struct i2c_client *client)
 {
 	struct adp8870_backlight_platform_data *pdata =
-		client->dev.platform_data;
+		dev_get_platdata(&client->dev);
 	struct adp8870_bl *data = i2c_get_clientdata(client);
 	struct adp8870_led *led, *led_dat;
 	struct led_info *cur_led;
@@ -325,7 +325,7 @@ static int adp8870_led_probe(struct i2c_client *client)
 static int adp8870_led_remove(struct i2c_client *client)
 {
 	struct adp8870_backlight_platform_data *pdata =
-		client->dev.platform_data;
+		dev_get_platdata(&client->dev);
 	struct adp8870_bl *data = i2c_get_clientdata(client);
 	int i;
 
@@ -848,7 +848,7 @@ static int adp8870_probe(struct i2c_client *client,
 	struct backlight_device *bl;
 	struct adp8870_bl *data;
 	struct adp8870_backlight_platform_data *pdata =
-		client->dev.platform_data;
+		dev_get_platdata(&client->dev);
 	uint8_t reg_val;
 	int ret;
 
diff --git a/drivers/video/backlight/ams369fg06.c b/drivers/video/backlight/ams369fg06.c
index 319fef6..df5507b 100644
--- a/drivers/video/backlight/ams369fg06.c
+++ b/drivers/video/backlight/ams369fg06.c
@@ -471,7 +471,7 @@ static int ams369fg06_probe(struct spi_device *spi)
 	lcd->spi = spi;
 	lcd->dev = &spi->dev;
 
-	lcd->lcd_pd = spi->dev.platform_data;
+	lcd->lcd_pd = dev_get_platdata(&spi->dev);
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL\n");
 		return -EINVAL;
diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index 0393d82..8900da7 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -133,7 +133,7 @@ static int __init atmel_pwm_bl_probe(struct platform_device *pdev)
 
 	pwmbl->pdev = pdev;
 
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 	if (!pdata) {
 		retval = -ENODEV;
 		goto err_free_mem;
diff --git a/drivers/video/backlight/bd6107.c b/drivers/video/backlight/bd6107.c
index 15e3294..43c434e 100644
--- a/drivers/video/backlight/bd6107.c
+++ b/drivers/video/backlight/bd6107.c
@@ -128,7 +128,7 @@ static const struct backlight_ops bd6107_backlight_ops = {
 static int bd6107_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
-	struct bd6107_platform_data *pdata = client->dev.platform_data;
+	struct bd6107_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct backlight_device *backlight;
 	struct backlight_properties props;
 	struct bd6107 *bd;
diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index c97867a..be56cfe 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -533,7 +533,7 @@ static int setup_gpio_backlight(struct corgi_lcd *lcd,
 static int corgi_lcd_probe(struct spi_device *spi)
 {
 	struct backlight_properties props;
-	struct corgi_lcd_platform_data *pdata = spi->dev.platform_data;
+	struct corgi_lcd_platform_data *pdata = dev_get_platdata(&spi->dev);
 	struct corgi_lcd *lcd;
 	int ret = 0;
 
diff --git a/drivers/video/backlight/da903x_bl.c b/drivers/video/backlight/da903x_bl.c
index 67cadd3..bbad5c2 100644
--- a/drivers/video/backlight/da903x_bl.c
+++ b/drivers/video/backlight/da903x_bl.c
@@ -109,7 +109,7 @@ static const struct backlight_ops da903x_backlight_ops = {
 
 static int da903x_backlight_probe(struct platform_device *pdev)
 {
-	struct da9034_backlight_pdata *pdata = pdev->dev.platform_data;
+	struct da9034_backlight_pdata *pdata = dev_get_platdata(&pdev->dev);
 	struct da903x_backlight_data *data;
 	struct backlight_device *bl;
 	struct backlight_properties props;
diff --git a/drivers/video/backlight/generic_bl.c b/drivers/video/backlight/generic_bl.c
index 19e393b..48fa914 100644
--- a/drivers/video/backlight/generic_bl.c
+++ b/drivers/video/backlight/generic_bl.c
@@ -79,7 +79,7 @@ static const struct backlight_ops genericbl_ops = {
 static int genericbl_probe(struct platform_device *pdev)
 {
 	struct backlight_properties props;
-	struct generic_bl_info *machinfo = pdev->dev.platform_data;
+	struct generic_bl_info *machinfo = dev_get_platdata(&pdev->dev);
 	const char *name = "generic-bl";
 	struct backlight_device *bd;
 
diff --git a/drivers/video/backlight/gpio_backlight.c b/drivers/video/backlight/gpio_backlight.c
index 5fa217f..118da0c 100644
--- a/drivers/video/backlight/gpio_backlight.c
+++ b/drivers/video/backlight/gpio_backlight.c
@@ -62,7 +62,8 @@ static const struct backlight_ops gpio_backlight_ops = {
 
 static int gpio_backlight_probe(struct platform_device *pdev)
 {
-	struct gpio_backlight_platform_data *pdata = pdev->dev.platform_data;
+	struct gpio_backlight_platform_data *pdata =
+		dev_get_platdata(&pdev->dev);
 	struct backlight_properties props;
 	struct backlight_device *bl;
 	struct gpio_backlight *gbl;
diff --git a/drivers/video/backlight/ili9320.c b/drivers/video/backlight/ili9320.c
index f8be90c..4dd43e0 100644
--- a/drivers/video/backlight/ili9320.c
+++ b/drivers/video/backlight/ili9320.c
@@ -198,7 +198,7 @@ static void ili9320_setup_spi(struct ili9320 *ili,
 int ili9320_probe_spi(struct spi_device *spi,
 				struct ili9320_client *client)
 {
-	struct ili9320_platdata *cfg = spi->dev.platform_data;
+	struct ili9320_platdata *cfg = dev_get_platdata(&spi->dev);
 	struct device *dev = &spi->dev;
 	struct ili9320 *ili;
 	struct lcd_device *lcd;
diff --git a/drivers/video/backlight/kb3886_bl.c b/drivers/video/backlight/kb3886_bl.c
index bca6ccc..5bacabb 100644
--- a/drivers/video/backlight/kb3886_bl.c
+++ b/drivers/video/backlight/kb3886_bl.c
@@ -141,7 +141,7 @@ static const struct backlight_ops kb3886bl_ops = {
 static int kb3886bl_probe(struct platform_device *pdev)
 {
 	struct backlight_properties props;
-	struct kb3886bl_machinfo *machinfo = pdev->dev.platform_data;
+	struct kb3886bl_machinfo *machinfo = dev_get_platdata(&pdev->dev);
 
 	bl_machinfo = machinfo;
 	if (!machinfo->limit_mask)
diff --git a/drivers/video/backlight/l4f00242t03.c b/drivers/video/backlight/l4f00242t03.c
index a35a38c..923eae2 100644
--- a/drivers/video/backlight/l4f00242t03.c
+++ b/drivers/video/backlight/l4f00242t03.c
@@ -48,7 +48,7 @@ static void l4f00242t03_reset(unsigned int gpio)
 
 static void l4f00242t03_lcd_init(struct spi_device *spi)
 {
-	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
+	struct l4f00242t03_pdata *pdata = dev_get_platdata(&spi->dev);
 	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
 	const u16 cmd[] = { 0x36, param(0), 0x3A, param(0x60) };
 	int ret;
@@ -88,7 +88,7 @@ static void l4f00242t03_lcd_init(struct spi_device *spi)
 
 static void l4f00242t03_lcd_powerdown(struct spi_device *spi)
 {
-	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
+	struct l4f00242t03_pdata *pdata = dev_get_platdata(&spi->dev);
 	struct l4f00242t03_priv *priv = spi_get_drvdata(spi);
 
 	dev_dbg(&spi->dev, "Powering down LCD\n");
@@ -171,7 +171,7 @@ static struct lcd_ops l4f_ops = {
 static int l4f00242t03_probe(struct spi_device *spi)
 {
 	struct l4f00242t03_priv *priv;
-	struct l4f00242t03_pdata *pdata = spi->dev.platform_data;
+	struct l4f00242t03_pdata *pdata = dev_get_platdata(&spi->dev);
 	int ret;
 
 	if (pdata == NULL) {
diff --git a/drivers/video/backlight/ld9040.c b/drivers/video/backlight/ld9040.c
index 1e0a309..26d5139 100644
--- a/drivers/video/backlight/ld9040.c
+++ b/drivers/video/backlight/ld9040.c
@@ -702,7 +702,7 @@ static int ld9040_probe(struct spi_device *spi)
 	lcd->spi = spi;
 	lcd->dev = &spi->dev;
 
-	lcd->lcd_pd = spi->dev.platform_data;
+	lcd->lcd_pd = dev_get_platdata(&spi->dev);
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL.\n");
 		return -EINVAL;
diff --git a/drivers/video/backlight/lm3533_bl.c b/drivers/video/backlight/lm3533_bl.c
index 1d1dbfb..93eea65 100644
--- a/drivers/video/backlight/lm3533_bl.c
+++ b/drivers/video/backlight/lm3533_bl.c
@@ -284,7 +284,7 @@ static int lm3533_bl_probe(struct platform_device *pdev)
 	if (!lm3533)
 		return -EINVAL;
 
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data\n");
 		return -EINVAL;
diff --git a/drivers/video/backlight/lm3630a_bl.c b/drivers/video/backlight/lm3630a_bl.c
index cf40cc8..c63f918 100644
--- a/drivers/video/backlight/lm3630a_bl.c
+++ b/drivers/video/backlight/lm3630a_bl.c
@@ -365,7 +365,7 @@ static const struct regmap_config lm3630a_regmap = {
 static int lm3630a_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
-	struct lm3630a_platform_data *pdata = client->dev.platform_data;
+	struct lm3630a_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct lm3630a_chip *pchip;
 	int rval;
 
diff --git a/drivers/video/backlight/lm3639_bl.c b/drivers/video/backlight/lm3639_bl.c
index 6c888e3..6fd60ad 100644
--- a/drivers/video/backlight/lm3639_bl.c
+++ b/drivers/video/backlight/lm3639_bl.c
@@ -307,7 +307,7 @@ static int lm3639_probe(struct i2c_client *client,
 {
 	int ret;
 	struct lm3639_chip_data *pchip;
-	struct lm3639_platform_data *pdata = client->dev.platform_data;
+	struct lm3639_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct backlight_properties props;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
diff --git a/drivers/video/backlight/lms283gf05.c b/drivers/video/backlight/lms283gf05.c
index 4eec472..80b5929 100644
--- a/drivers/video/backlight/lms283gf05.c
+++ b/drivers/video/backlight/lms283gf05.c
@@ -128,7 +128,7 @@ static int lms283gf05_power_set(struct lcd_device *ld, int power)
 {
 	struct lms283gf05_state *st = lcd_get_data(ld);
 	struct spi_device *spi = st->spi;
-	struct lms283gf05_pdata *pdata = spi->dev.platform_data;
+	struct lms283gf05_pdata *pdata = dev_get_platdata(&spi->dev);
 
 	if (power <= FB_BLANK_NORMAL) {
 		if (pdata)
@@ -153,7 +153,7 @@ static struct lcd_ops lms_ops = {
 static int lms283gf05_probe(struct spi_device *spi)
 {
 	struct lms283gf05_state *st;
-	struct lms283gf05_pdata *pdata = spi->dev.platform_data;
+	struct lms283gf05_pdata *pdata = dev_get_platdata(&spi->dev);
 	struct lcd_device *ld;
 	int ret = 0;
 
diff --git a/drivers/video/backlight/lms501kf03.c b/drivers/video/backlight/lms501kf03.c
index cf01b9a..ff46e19 100644
--- a/drivers/video/backlight/lms501kf03.c
+++ b/drivers/video/backlight/lms501kf03.c
@@ -344,7 +344,7 @@ static int lms501kf03_probe(struct spi_device *spi)
 	lcd->spi = spi;
 	lcd->dev = &spi->dev;
 
-	lcd->lcd_pd = spi->dev.platform_data;
+	lcd->lcd_pd = dev_get_platdata(&spi->dev);
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL\n");
 		return -EINVAL;
diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index c952175..57f005a 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -405,7 +405,7 @@ static int lp855x_parse_dt(struct device *dev, struct device_node *node)
 static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 {
 	struct lp855x *lp;
-	struct lp855x_platform_data *pdata = cl->dev.platform_data;
+	struct lp855x_platform_data *pdata = dev_get_platdata(&cl->dev);
 	struct device_node *node = cl->dev.of_node;
 	int ret;
 
@@ -414,7 +414,7 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 		if (ret < 0)
 			return ret;
 
-		pdata = cl->dev.platform_data;
+		pdata = dev_get_platdata(&cl->dev);
 	}
 
 	if (!i2c_check_functionality(cl->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
diff --git a/drivers/video/backlight/lv5207lp.c b/drivers/video/backlight/lv5207lp.c
index 498fd73..8091a28 100644
--- a/drivers/video/backlight/lv5207lp.c
+++ b/drivers/video/backlight/lv5207lp.c
@@ -93,7 +93,7 @@ static const struct backlight_ops lv5207lp_backlight_ops = {
 static int lv5207lp_probe(struct i2c_client *client,
 			  const struct i2c_device_id *id)
 {
-	struct lv5207lp_platform_data *pdata = client->dev.platform_data;
+	struct lv5207lp_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct backlight_device *backlight;
 	struct backlight_properties props;
 	struct lv5207lp *lv;
diff --git a/drivers/video/backlight/omap1_bl.c b/drivers/video/backlight/omap1_bl.c
index 812e22e..ac11a46 100644
--- a/drivers/video/backlight/omap1_bl.c
+++ b/drivers/video/backlight/omap1_bl.c
@@ -133,7 +133,7 @@ static int omapbl_probe(struct platform_device *pdev)
 	struct backlight_properties props;
 	struct backlight_device *dev;
 	struct omap_backlight *bl;
-	struct omap_backlight_config *pdata = pdev->dev.platform_data;
+	struct omap_backlight_config *pdata = dev_get_platdata(&pdev->dev);
 
 	if (!pdata)
 		return -ENXIO;
diff --git a/drivers/video/backlight/pcf50633-backlight.c b/drivers/video/backlight/pcf50633-backlight.c
index 6ed76be..b2184cf 100644
--- a/drivers/video/backlight/pcf50633-backlight.c
+++ b/drivers/video/backlight/pcf50633-backlight.c
@@ -103,7 +103,7 @@ static int pcf50633_bl_probe(struct platform_device *pdev)
 {
 	struct pcf50633_bl *pcf_bl;
 	struct device *parent = pdev->dev.parent;
-	struct pcf50633_platform_data *pcf50633_data = parent->platform_data;
+	struct pcf50633_platform_data *pcf50633_data = dev_get_platdata(parent);
 	struct pcf50633_bl_platform_data *pdata = pcf50633_data->backlight_data;
 	struct backlight_properties bl_props;
 
diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c
index 0568367..cc0f067 100644
--- a/drivers/video/backlight/platform_lcd.c
+++ b/drivers/video/backlight/platform_lcd.c
@@ -80,7 +80,7 @@ static int platform_lcd_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	int err;
 
-	pdata = pdev->dev.platform_data;
+	pdata = dev_get_platdata(&pdev->dev);
 	if (!pdata) {
 		dev_err(dev, "no platform data supplied\n");
 		return -EINVAL;
diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 1fea627..36db5d9 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -163,7 +163,7 @@ static int pwm_backlight_parse_dt(struct device *dev,
 
 static int pwm_backlight_probe(struct platform_device *pdev)
 {
-	struct platform_pwm_backlight_data *data = pdev->dev.platform_data;
+	struct platform_pwm_backlight_data *data = dev_get_platdata(&pdev->dev);
 	struct platform_pwm_backlight_data defdata;
 	struct backlight_properties props;
 	struct backlight_device *bl;
diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index b37bb18..4e339ad 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -735,7 +735,7 @@ static int s6e63m0_probe(struct spi_device *spi)
 	lcd->spi = spi;
 	lcd->dev = &spi->dev;
 
-	lcd->lcd_pd = spi->dev.platform_data;
+	lcd->lcd_pd = dev_get_platdata(&spi->dev);
 	if (!lcd->lcd_pd) {
 		dev_err(&spi->dev, "platform data is NULL.\n");
 		return -EINVAL;
diff --git a/drivers/video/backlight/tdo24m.c b/drivers/video/backlight/tdo24m.c
index 18cdf46..2ccfa46 100644
--- a/drivers/video/backlight/tdo24m.c
+++ b/drivers/video/backlight/tdo24m.c
@@ -338,7 +338,7 @@ static int tdo24m_probe(struct spi_device *spi)
 	enum tdo24m_model model;
 	int err;
 
-	pdata = spi->dev.platform_data;
+	pdata = dev_get_platdata(&spi->dev);
 	if (pdata)
 		model = pdata->model;
 	else
diff --git a/drivers/video/backlight/tosa_bl.c b/drivers/video/backlight/tosa_bl.c
index 9df66ac..b8db933 100644
--- a/drivers/video/backlight/tosa_bl.c
+++ b/drivers/video/backlight/tosa_bl.c
@@ -38,7 +38,7 @@ struct tosa_bl_data {
 
 static void tosa_bl_set_backlight(struct tosa_bl_data *data, int brightness)
 {
-	struct spi_device *spi = data->i2c->dev.platform_data;
+	struct spi_device *spi = dev_get_platdata(&data->i2c->dev);
 
 	i2c_smbus_write_byte_data(data->i2c, DAC_CH1, data->comadj);
 
diff --git a/drivers/video/backlight/tps65217_bl.c b/drivers/video/backlight/tps65217_bl.c
index 0578231..4ea2039 100644
--- a/drivers/video/backlight/tps65217_bl.c
+++ b/drivers/video/backlight/tps65217_bl.c
@@ -287,12 +287,11 @@ static int tps65217_bl_probe(struct platform_device *pdev)
 		if (IS_ERR(pdata))
 			return PTR_ERR(pdata);
 	} else {
-		if (!pdev->dev.platform_data) {
+		pdata = dev_get_platdata(&pdev->dev);
+		if (!pdata) {
 			dev_err(&pdev->dev, "no platform data provided\n");
 			return -EINVAL;
 		}
-
-		pdata = pdev->dev.platform_data;
 	}
 
 	tps65217_bl = devm_kzalloc(&pdev->dev, sizeof(*tps65217_bl),
diff --git a/drivers/video/backlight/wm831x_bl.c b/drivers/video/backlight/wm831x_bl.c
index 9e5517a..2ccf320 100644
--- a/drivers/video/backlight/wm831x_bl.c
+++ b/drivers/video/backlight/wm831x_bl.c
@@ -123,7 +123,7 @@ static const struct backlight_ops wm831x_backlight_ops = {
 static int wm831x_backlight_probe(struct platform_device *pdev)
 {
 	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
-	struct wm831x_pdata *wm831x_pdata;
+	struct wm831x_pdata *wm831x_pdata = dev_get_platdata(pdev->dev.parent);
 	struct wm831x_backlight_pdata *pdata;
 	struct wm831x_backlight_data *data;
 	struct backlight_device *bl;
@@ -131,12 +131,10 @@ static int wm831x_backlight_probe(struct platform_device *pdev)
 	int ret, i, max_isel, isink_reg, dcdc_cfg;
 
 	/* We need platform data */
-	if (pdev->dev.parent->platform_data) {
-		wm831x_pdata = pdev->dev.parent->platform_data;
+	if (wm831x_pdata)
 		pdata = wm831x_pdata->backlight;
-	} else {
+	else
 		pdata = NULL;
-	}
 
 	if (!pdata) {
 		dev_err(&pdev->dev, "No platform data supplied\n");
-- 
1.7.10.4


