Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab3IXJWF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:22:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30144 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3IXJWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:22:03 -0400
X-AuditID: cbfee68e-b7f756d000004512-36-524159ba5248
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/8] backlight: hx8357: use devm_lcd_device_register()
Date: Tue, 24 Sep 2013 18:22:02 +0900
Message-id: <006201ceb907$87256e90$95704bb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65B4cS+dNU2Dj7TgWyLrp1FJz2pQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zI91dkY5BBg8eK1nMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBlrVh1m
	L2jiqbi+byNTA+Mrzi5GTg4JAROJ+ZemMkLYYhIX7q1n62Lk4hASWMYoMeHyWlaYop+dK5lB
	bCGB6YwSXzYoQBT9YpRYM2cRWIJNQE3iy5fD7F2MHBwiAvoSbS0aIGFmgRyJ+09mgYWFBdwk
	/p8OBQmzCKhK7HvQxA5i8wrYSlzdvwvKFpT4MfkeC0SrlsTmbU2sELa8xOY1b5lBxkgIqEs8
	+qsLsUhP4uHiNIgKEYl9L94xghwmIbCJXWLf5oVsEKsEJL5NPsQC0SorsekAM8RTkhIHV9xg
	mcAoNgvJ4llIFs9CsngWkhULGFlWMYqmFiQXFCelFxnpFSfmFpfmpesl5+duYoTEV98OxpsH
	rA8xJgOtn8gsJZqcD4zPvJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KL
	SnNSiw8xMnFwSjUwBjMlv3hsdOHs3Nc7f02uOH5U0rn750/t/7eO8E3/qpv4QEXmVXj0edsU
	Ncb4PWd29hXyvXrGZXCOK75rhWuQxystS0tRkd293qazrxa1/5Ngd91v8Nsl52WQnnL7vsb5
	f9NKrirNKImqEkhm/sp/g//v/9SFc4w3MUucXS/ut+zL4g6PswapSizFGYmGWsxFxYkA89GO
	J8UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xoO6uSMcgg8MT5C3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMNasOsxc08VRc37eRqYHxFWcXIyeHhICJxM/OlcwQtpjEhXvr
	2UBsIYHpjBJfNih0MXIB2b8YJdbMWQRWxCagJvHly2H2LkYODhEBfYm2Fg2QMLNAjsT9J7PA
	wsICbhL/T4eChFkEVCX2PWhiB7F5BWwlru7fBWULSvyYfI8FolVLYvO2JlYIW15i85q3zCBj
	JATUJR791YVYpCfxcHEaRIWIxL4X7xgnMArMQjJoFpJBs5AMmoWkZQEjyypG0dSC5ILipPRc
	Q73ixNzi0rx0veT83E2M4Oh9JrWDcWWDxSFGAQ5GJR7eHd4OQUKsiWXFlbmHGCU4mJVEeG/Y
	OgYJ8aYkVlalFuXHF5XmpBYfYkwG+nMis5Rocj4wseSVxBsam5gZWRqZWRiZmJuTJqwkznug
	1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2Pina2z50RGC1QL7H4Ys0qKYU7EAb7jga+Vr70x3aOX
	8ytfdbHzTrbi/H+f/DK/y1ysPVoi4tT/Xmb5Ry2pdoYW8U1ybBwPZy2V0Frp8eyCVHVezVmW
	f1IyvzX+fJvlvzJvzbn4kMYs7Tl8EpmTun4XWB5oNbSu93l/tefcwpwHzzKTvyw/Ga/EUpyR
	aKjFXFScCADynK0qIgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_lcd_device_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/hx8357.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/video/backlight/hx8357.c b/drivers/video/backlight/hx8357.c
index c7af8c4..0d252e7 100644
--- a/drivers/video/backlight/hx8357.c
+++ b/drivers/video/backlight/hx8357.c
@@ -648,7 +648,8 @@ static int hx8357_probe(struct spi_device *spi)
 		lcd->use_im_pins = 0;
 	}
 
-	lcdev = lcd_device_register("mxsfb", &spi->dev, lcd, &hx8357_ops);
+	lcdev = devm_lcd_device_register(&spi->dev, "mxsfb", &spi->dev, lcd,
+					&hx8357_ops);
 	if (IS_ERR(lcdev)) {
 		ret = PTR_ERR(lcdev);
 		return ret;
@@ -660,29 +661,16 @@ static int hx8357_probe(struct spi_device *spi)
 	ret = ((int (*)(struct lcd_device *))match->data)(lcdev);
 	if (ret) {
 		dev_err(&spi->dev, "Couldn't initialize panel\n");
-		goto init_error;
+		return ret;
 	}
 
 	dev_info(&spi->dev, "Panel probed\n");
 
 	return 0;
-
-init_error:
-	lcd_device_unregister(lcdev);
-	return ret;
-}
-
-static int hx8357_remove(struct spi_device *spi)
-{
-	struct lcd_device *lcdev = spi_get_drvdata(spi);
-
-	lcd_device_unregister(lcdev);
-	return 0;
 }
 
 static struct spi_driver hx8357_driver = {
 	.probe  = hx8357_probe,
-	.remove = hx8357_remove,
 	.driver = {
 		.name = "hx8357",
 		.of_match_table = of_match_ptr(hx8357_dt_ids),
-- 
1.7.10.4


