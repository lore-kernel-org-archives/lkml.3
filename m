Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab3IXJEK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:04:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26220 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab3IXJEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:04:07 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-21-524155831127
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 01/22] backlight: 88pm860x_bl: use
 devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:04:03 +0900
Message-id: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zQ93mUMcgg2vHtC3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsEroxXD3QK
	+vgqHjZPYmlg/MrdxcjJISFgIvF81SFWCFtM4sK99WxdjFwcQgLLGCVe9HYywxR9v3KWESKx
	iFGi5cx3KOcXo8SaM/fA2tkE1CS+fDnM3sXIwSEioC/R1qIBEmYWyJG4/2QWO4gtLBAqMfvK
	ESYQm0VAVeL4uyksIDavgK1Ey4oljBC2oMSPyfdYIHq1JDZva2KFsOUlNq95ywwyXkJAXeLR
	X12QsIiAnkTH8cVMECUiEvtevAM7TUJgG7vE/s/XWCF2CUh8m3yIBaJXVmLTAai/JCUOrrjB
	MoFRbBaSzbOQbJ6FZPMsJCsWMLKsYhRNLUguKE5KLzLRK07MLS7NS9dLzs/dxAiJsQk7GO8d
	sD7EmAy0fiKzlGhyPjBG80riDY3NjCxMTUyNjcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYov
	Ks1JLT7EyMTBKdXAuOioquzb7e+msE24d+LTeaNpxaXfLvebNUYKnlO21rHz/9ZvPU2K/dTD
	goBLdaHCBlGaK9nKSiRmxq7U0H+7+WtY1QW9kOcKXyRWecXYHUl09z1f15+zLc9i7sNYoVU1
	1quSt83y8+mXfsIUVh1gueeIzt07qnslY5aX7zi3nee4XdgGhxNLlFiKMxINtZiLihMBO1/V
	8McCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd3mUMcgg1kX1C3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMVw90Cvr4Kh42T2JpYPzK3cXIySEhYCLx/cpZRghbTOLCvfVs
	XYxcHEICixglWs58Z4RwfjFKrDlzjxWkik1ATeLLl8PsXYwcHCIC+hJtLRogYWaBHIn7T2ax
	g9jCAqESs68cYQKxWQRUJY6/m8ICYvMK2Eq0rFjCCGELSvyYfI8FoldLYvO2JlYIW15i85q3
	zCDjJQTUJR791QUJiwjoSXQcX8wEUSIise/FO8YJjAKzkEyahWTSLCSTZiFpWcDIsopRNLUg
	uaA4KT3XSK84Mbe4NC9dLzk/dxMjOIKfSe9gXNVgcYhRgINRiYf3QoJDkBBrYllxZe4hRgkO
	ZiUR3hu2jkFCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9MLnkl8YbGJmZGlkZmFkYm5uak
	CSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwDi/ZqXv2jIDQeWanhmve70rG6VabVXNmI6Y
	iaSn5LleUi2yEariyDJhm67CvW5Wyff8lceuS+Y0Km25LbuuqK1qXR6XeKpR7meZ7R1Ty9bw
	/vAK9c15fNrbZb9tcc0j80knF7xlOSOjXf9rY2hwQBPb/UOzt7PP2fCi6KDG8n/NOid0ba8a
	KLEUZyQaajEXFScCALLyATEkAwAA
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
 drivers/video/backlight/88pm860x_bl.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index a84a12a..7db5234 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -243,7 +243,7 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = MAX_BRIGHTNESS;
-	bl = backlight_device_register(name, &pdev->dev, data,
+	bl = devm_backlight_device_register(&pdev->dev, name, &pdev->dev, data,
 					&pm860x_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
@@ -256,21 +256,10 @@ static int pm860x_backlight_probe(struct platform_device *pdev)
 	/* read current backlight */
 	ret = pm860x_backlight_get_brightness(bl);
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
-static int pm860x_backlight_remove(struct platform_device *pdev)
-{
-	struct backlight_device *bl = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(bl);
-	return 0;
 }
 
 static struct platform_driver pm860x_backlight_driver = {
@@ -279,7 +268,6 @@ static struct platform_driver pm860x_backlight_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= pm860x_backlight_probe,
-	.remove		= pm860x_backlight_remove,
 };
 
 module_platform_driver(pm860x_backlight_driver);
-- 
1.7.10.4


