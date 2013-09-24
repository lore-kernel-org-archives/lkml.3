Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab3IXJSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:18:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25212 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab3IXJSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:18:31 -0400
X-AuditID: cbfee68e-b7f756d000004512-9a-524158e01004
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 18/22] backlight: max8925_bl: use
 devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:18:24 +0900
Message-id: <005801ceb907$054ff980$0fefec80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAAe44g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zA90HEY5BBk0TzC3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsEroz3/6ey
	Fmzmq1j4UKSBcQZPFyMnh4SAicTbvVuZIGwxiQv31rN1MXJxCAksY5Q4fWA6I0zRpBeHmSES
	0xklzk4/zgLh/GKU6P3wnR2kik1ATeLLl8NANgeHiIC+RFuLBkiYWSBH4v6TWWAlQgK2Eus+
	zAazOQXsJE4tPcMGYgsLhEis3jEdzGYRUJWY/nAjM4jNC1R/4NNsVghbUOLH5HssEDO1JDZv
	a2KFsOUlNq95ywyyVkJAXeLRX12QsIiAkcSX9xugSkQk9r14xwhysoTAKXaJX2dXQO0SkPg2
	+RALRK+sxKYDzBD/SkocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyUXmSkV5yY
	W1yal66XnJ+7iRESk307GG8esD7EmAy0fiKzlGhyPjCm80riDY3NjCxMTUyNjcwtzUgTVhLn
	VWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAaKloG7CpfZ7L/QtFD41rs3hmBwkledoa
	pslNMHH+3+D8XeHv5Oprwb9klO9FnBWa2nigluv206e/F799xPTCbK5rwaqNk5PkXlj8c7yn
	tlibJ7abXfDyea8+Y8PElwfeGUp5Becbd4TMfxBe1Lp18uGUDaYzSvZLFWyI7/Po3Wo4KdHc
	9/N3JZbijERDLeai4kQADalY3d8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQd0HEY5BBj1zjC3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaM9/+nshZs5qtY+FCkgXEGTxcjJ4eEgInEpBeHmSFsMYkL99az
	dTFycQgJTGeUODv9OAuE84tRovfDd3aQKjYBNYkvXw4D2RwcIgL6Em0tGiBhZoEciftPZoGV
	CAnYSqz7MBvM5hSwkzi19AwbiC0sECKxesd0MJtFQFVi+sONYIt5geoPfJrNCmELSvyYfI8F
	YqaWxOZtTawQtrzE5jVvmUHWSgioSzz6qwsSFhEwkvjyfgNUiYjEvhfvGCcwCs1CMmkWkkmz
	kEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgiH8mvYNxVYPFIUYBDkYlHt4L
	CQ5BQqyJZcWVuYcYJTiYlUR4b9g6BgnxpiRWVqUW5ccXleakFh9iTAZ6dCKzlGhyPjAZ5ZXE
	GxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo7N60rKGntJqb9bP
	57Q8T4iF31J3rF4aGTWPZdXrl79zw45MDuBYzxr0Lbdk2sJ3j4tmRLxfHyhh+0Ql9HJjxoFV
	uf+9OP8uT7zecLBus6PUzanvjT/IZ7979lL8Y4LL+p0tAtJiR9UOnjBv9TkUmHy0Tkwyf51Y
	pTNrVjbPjMkP8thOFE84pcRSnJFoqMVcVJwIABDcFyg8AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/max8925_bl.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
index 886e797..66fa08c 100644
--- a/drivers/video/backlight/max8925_bl.c
+++ b/drivers/video/backlight/max8925_bl.c
@@ -163,7 +163,8 @@ static int max8925_backlight_probe(struct platform_device *pdev)
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = MAX_BRIGHTNESS;
-	bl = backlight_device_register("max8925-backlight", &pdev->dev, data,
+	bl = devm_backlight_device_register(&pdev->dev, "max8925-backlight",
+					&pdev->dev, data,
 					&max8925_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
@@ -188,20 +189,9 @@ static int max8925_backlight_probe(struct platform_device *pdev)
 	}
 	ret = max8925_set_bits(chip->i2c, data->reg_mode_cntl, 0xfe, value);
 	if (ret < 0)
-		goto out_brt;
+		return ret;
 	backlight_update_status(bl);
 	return 0;
-out_brt:
-	backlight_device_unregister(bl);
-	return ret;
-}
-
-static int max8925_backlight_remove(struct platform_device *pdev)
-{
-	struct backlight_device *bl = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(bl);
-	return 0;
 }
 
 static struct platform_driver max8925_backlight_driver = {
@@ -210,7 +200,6 @@ static struct platform_driver max8925_backlight_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= max8925_backlight_probe,
-	.remove		= max8925_backlight_remove,
 };
 
 module_platform_driver(max8925_backlight_driver);
-- 
1.7.10.4


