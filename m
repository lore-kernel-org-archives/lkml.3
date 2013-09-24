Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab3IXJZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:25:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:30688 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab3IXJZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:25:03 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-69-52415a6ee427
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <006201ceb907$87256e90$95704bb0$%han@samsung.com>
In-reply-to: <006201ceb907$87256e90$95704bb0$%han@samsung.com>
Subject: [PATCH 6/8] backlight: ltv350qv: use devm_lcd_device_register()
Date: Tue, 24 Sep 2013 18:25:01 +0900
Message-id: <006701ceb907$f2360820$d6a21860$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65B4cS+dNU2Dj7TgWyLrp1FJz2pQAAFnXg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zfd28KMcggwPLeSzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsErowjR76x
	F+zjqmg/s5CpgfECRxcjJ4eEgInEr0d72CFsMYkL99azdTFycQgJLGOUOLVrGlMXIwdY0drN
	mhDxRYwSS341sEM4vxglfq3vZgbpZhNQk/jy5TA7SIOIgL5EW4sGSJhZIEfi/pNZYAuEBGwl
	Vs+8CmZzCthJvJ96hgXEFhbwkGhZtYYJxGYRUJW4PX8uK4jNC1S/5MBzRghbUOLH5HssEDO1
	JDZva2KFsOUlNq95ywxxp7rEo7+6IGERASOJpTu/M0GUiEjse/GOEeRkCYFz7BIH9n1hhdgl
	IPFt8iEWiF5ZiU0HmCHhIClxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGp
	XnFibnFpXrpecn7uJkZITE7cwXj/gPUhxmSg9ROZpUST84ExnVcSb2hsZmRhamJqbGRuaUaa
	sJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxlXc+zoCXvPufDDhf+YlvmmFghMe
	1MiV7/lyqHbh9XzJPRNW7l68j81MKM45PqRQdsJyOw4mG5+zM5VZvl26NMH+WeDkDo/bzP8+
	Jz/aZjOjm8VUxvyEwuNirc3fyv7mn2057xVY/vjca4lTVcaRWbfi2Hnc8hmSxQov1DvtOJ3z
	TzaQ8X/7WiWW4oxEQy3mouJEAEsfZ9ffAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd28KMcggxXnOSzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMI0e+sRfs46poP7OQqYHxAkcXIweHhICJxNrNml2MnECmmMSF
	e+vZuhi5OIQEFjFKLPnVwA7h/GKU+LW+mxmkik1ATeLLl8PsIM0iAvoSbS0aIGFmgRyJ+09m
	sYPYQgK2EqtnXgWzOQXsJN5PPcMCYgsLeEi0rFrDBGKzCKhK3J4/lxXE5gWqX3LgOSOELSjx
	Y/I9FoiZWhKbtzWxQtjyEpvXvGWGuFld4tFfXZCwiICRxNKd35kgSkQk9r14xziBUWgWkkmz
	kEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER/wzqR2MKxssDjEKcDAq
	8fDu8HYIEmJNLCuuzD3EKMHBrCTCe8PWMUiINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84HJ
	KK8k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGKOPPpt66m3f
	q58x7EHnvqosjORaY1brdiJB+jF3mGG/xBpXt8xpaXfZJj79lPJ6u4qK622Hh8nGzGkSM2US
	j/U6rfyfJvDZ8W6q7IJT7V7VD754fz0/zaFvcahSi+LXpWL1BeY54mmzRF5bXVoXVZS4+oLb
	le/BmudaIoTXfOb7l5Fx/I+fgxJLcUaioRZzUXEiALuTEj88AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_lcd_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ltv350qv.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/video/backlight/ltv350qv.c b/drivers/video/backlight/ltv350qv.c
index ed1b392..383f550 100644
--- a/drivers/video/backlight/ltv350qv.c
+++ b/drivers/video/backlight/ltv350qv.c
@@ -242,7 +242,8 @@ static int ltv350qv_probe(struct spi_device *spi)
 	if (!lcd->buffer)
 		return -ENOMEM;
 
-	ld = lcd_device_register("ltv350qv", &spi->dev, lcd, &ltv_ops);
+	ld = devm_lcd_device_register(&spi->dev, "ltv350qv", &spi->dev, lcd,
+					&ltv_ops);
 	if (IS_ERR(ld))
 		return PTR_ERR(ld);
 
@@ -250,15 +251,11 @@ static int ltv350qv_probe(struct spi_device *spi)
 
 	ret = ltv350qv_power(lcd, FB_BLANK_UNBLANK);
 	if (ret)
-		goto out_unregister;
+		return ret;
 
 	spi_set_drvdata(spi, lcd);
 
 	return 0;
-
-out_unregister:
-	lcd_device_unregister(ld);
-	return ret;
 }
 
 static int ltv350qv_remove(struct spi_device *spi)
@@ -266,8 +263,6 @@ static int ltv350qv_remove(struct spi_device *spi)
 	struct ltv350qv *lcd = spi_get_drvdata(spi);
 
 	ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
-	lcd_device_unregister(lcd->ld);
-
 	return 0;
 }
 
-- 
1.7.10.4


