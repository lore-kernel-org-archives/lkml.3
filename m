Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3IXJJO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:09:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23140 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3IXJJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:09:12 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-08-524156b274da
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 06/22] backlight: as3711_bl: use
 devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:09:05 +0900
Message-id: <004c01ceb905$b853fc90$28fbf5b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAAIU1w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zA91NYY5BBn8nsVrMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBmHn6xn
	LbgkVLF6wha2BsYG/i5GTg4JAROJbdMfskLYYhIX7q1n62Lk4hASWMYo0b7sJTNM0dNDe5kg
	EosYJfq33WaHcH4xSlx48pIdpIpNQE3iy5fDQDYHh4iAvkRbiwZImFkgR+L+k1lgJUICthLr
	PswGszkF7CROLT3DBmILCwRLTJ0/kRmklUVAVWLjZzmQMC9Q+dYny1khbEGJH5PvsUCM1JLY
	vK2JFcKWl9i85i1Yq4SAusSjv7oQBxhJnHqpD1EhIrHvxTtGkIMlBE6xS/z43At2AYuAgMS3
	yYdYIFplJTYdgPpWUuLgihssExglZiFZPAvJ4llIFs9CsmIBI8sqRtHUguSC4qT0ImO94sTc
	4tK8dL3k/NxNjJCI7N/BePeA9SHGZKD1E5mlRJPzgRGdVxJvaGxmZGFqYmpsZG5pRpqwkjiv
	Wot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGDhbjNRzrbu1pOX1Pm+Eg501rpscH5vYv
	/bj0ZMDEY92CTVNbJbTurV6mIMfZOXNhbNMfyROiMu0ZIZLMDvd9Jtfd9DM9x1Qqt19wRd2G
	N9+NDoX1XJjEuaVJ/wrzpxWR4sIKETWpGdX1gldmc7McW+mx4MmXt01rPn/e8nlaTEPOUelm
	2cY0JZbijERDLeai4kQAOYzGzN4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAd1NYY5BBm0zGS3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaMw0/WsxZcEqpYPWELWwNjA38XIyeHhICJxNNDe5kgbDGJC/fW
	s3UxcnEICSxilOjfdpsdwvnFKHHhyUt2kCo2ATWJL18OA9kcHCIC+hJtLRogYWaBHIn7T2aB
	lQgJ2Eqs+zAbzOYUsJM4tfQMG4gtLBAsMXX+RGaQVhYBVYmNn+VAwrxA5VufLGeFsAUlfky+
	xwIxUkti87YmVghbXmLzmrdgrRIC6hKP/upCHGAkceqlPkSFiMS+F+8YJzAKzUIyaBaSQbOQ
	DJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOB4fya9g3FVg8UhRgEORiUe3gsJ
	DkFCrIllxZW5hxglOJiVRHhv2DoGCfGmJFZWpRblxxeV5qQWH2JMBnpzIrOUaHI+MBXllcQb
	GpuYGVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVANj6rG0nwmfuQIme587
	M99wQo5zmdEuVaEDu8I/xFct3TbFjEfw1tzF108ES+gJRvrMevqpeYXr2fSQMM0Xb5M17cJE
	J/hq6rwO+7qwkkPjubhtWNxuv7MH/N2m/WNjuahZ763Sv3ePZcD0lWstV5XcXnniq+jr770/
	Z21SZvkYoZ8V//7DQZdUJZbijERDLeai4kQArMb6yTsDAAA=
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
 drivers/video/backlight/as3711_bl.c |   26 +++++---------------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/video/backlight/as3711_bl.c b/drivers/video/backlight/as3711_bl.c
index 123887c..bb1fc45 100644
--- a/drivers/video/backlight/as3711_bl.c
+++ b/drivers/video/backlight/as3711_bl.c
@@ -240,7 +240,8 @@ static int as3711_bl_register(struct platform_device *pdev,
 	/* max tuning I = 31uA for voltage- and 38250uA for current-feedback */
 	props.max_brightness = max_brightness;
 
-	bl = backlight_device_register(su->type == AS3711_BL_SU1 ?
+	bl = devm_backlight_device_register(&pdev->dev,
+				       su->type == AS3711_BL_SU1 ?
 				       "as3711-su1" : "as3711-su2",
 				       &pdev->dev, su,
 				       &as3711_bl_ops, &props);
@@ -432,8 +433,7 @@ static int as3711_backlight_probe(struct platform_device *pdev)
 		case AS3711_SU2_LX_SD4:
 			break;
 		default:
-			ret = -EINVAL;
-			goto esu2;
+			return -EINVAL;
 		}
 
 		switch (pdata->su2_feedback) {
@@ -447,8 +447,7 @@ static int as3711_backlight_probe(struct platform_device *pdev)
 			max_brightness = min(pdata->su2_max_uA / 150, 255);
 			break;
 		default:
-			ret = -EINVAL;
-			goto esu2;
+			return -EINVAL;
 		}
 
 		ret = as3711_bl_init_su2(supply);
@@ -457,26 +456,12 @@ static int as3711_backlight_probe(struct platform_device *pdev)
 
 		ret = as3711_bl_register(pdev, max_brightness, su);
 		if (ret < 0)
-			goto esu2;
+			return ret;
 	}
 
 	platform_set_drvdata(pdev, supply);
 
 	return 0;
-
-esu2:
-	backlight_device_unregister(supply->su1.bl);
-	return ret;
-}
-
-static int as3711_backlight_remove(struct platform_device *pdev)
-{
-	struct as3711_bl_supply *supply = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(supply->su1.bl);
-	backlight_device_unregister(supply->su2.bl);
-
-	return 0;
 }
 
 static struct platform_driver as3711_backlight_driver = {
@@ -485,7 +470,6 @@ static struct platform_driver as3711_backlight_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= as3711_backlight_probe,
-	.remove		= as3711_backlight_remove,
 };
 
 module_platform_driver(as3711_backlight_driver);
-- 
1.7.10.4


