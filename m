Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319AbaE3BmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:42:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:50150 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaE3Bl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:41:59 -0400
X-AuditID: cbfee68e-b7fb96d000004bfc-b8-5387e1dd874f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@kernel.org>, Graeme Gregory <gg@slimlogic.co.uk>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] extcon: Set parent device of extcon device using prameter of
 devm_extcon_dev_allocate
Date: Fri, 30 May 2014 10:41:39 +0900
Message-id: <1401414099-10937-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWyRsSkQPfuw/Zgg80NqhZTHz5hs/g35Qa7
	xfUvz1kt+re4WLx+YWhx4WkPm8XZpjfsFpd3zWGzuN24gs2B02PTqk42j5cTf7N59G1Zxegx
	dcpfRo/jN7YzeXzeJBfAFsVlk5Kak1mWWqRvl8CVsfDnSraCT/IVTX/WMjYwrpbuYuTkkBAw
	kfi+fBI7hC0mceHeerYuRi4OIYGljBLXe08wwxQ9e7SQCSIxnVGiZ+kzNpCEkEATk8Tlu7Ig
	NpuAlsT+FzfA4iICChKbe5+xgjQwC+xikvg/fworSEJYIENix42LYDaLgKpE84wmMJtXwFVi
	77EeVohtchIf9jxiB2mWEJjOLvH38W52iAYBiW+TD7F0MXIAJWQlNh2Auk5S4uCKGywTGAUX
	MDKsYhRNLUguKE5KLzLSK07MLS7NS9dLzs/dxAgM6dP/nvXtYLx5wPoQYzLQuInMUqLJ+cCY
	yCuJNzQ2M7IwNTE1NjK3NCNNWEmcd9HDpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjG25
	rsENiasf8819dj5lbsT6uNmTd4WrlX1/y5DQc3+X1ecpjg4ixa/UV0fv+X/N7nJy1qQNfyQv
	63nKbT4rXGYpniZ4INneipEn1Oj4D/F750VreYul1j3RvdV34mUEc5TNwx/HTwudujFl613W
	ydw2u3Yu4Oj4xe3rLKZstCy3fu1kqakbvimxFGckGmoxFxUnAgDJ1UGNfwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t9jQd27D9uDDWYslbGY+vAJm8W/KTfY
	La5/ec5q0b/FxeL1C0OLC0972CzONr1ht7i8aw6bxe3GFWwOnB6bVnWyebyc+JvNo2/LKkaP
	qVP+Mnocv7GdyePzJrkAtqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8
	xNxUWyUXnwBdt8wcoKOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBkL
	f65kK/gkX9H0Zy1jA+Nq6S5GTg4JAROJZ48WMkHYYhIX7q1n62Lk4hASmM4o0bP0GRtIQkig
	iUni8l1ZEJtNQEti/4sbYHERAQWJzb3PWEEamAV2MUn8nz+FFSQhLJAhsePGRTCbRUBVonlG
	E5jNK+AqsfdYDyvENjmJD3sesU9g5F7AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzhi
	nknvYFzVYHGIUYCDUYmHd0J6e7AQa2JZcWXuIUYJDmYlEd6sB0Ah3pTEyqrUovz4otKc1OJD
	jMlA2ycyS4km5wOjOa8k3tDYxMzI0sjc0MLI2Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4
	OKUaGNcXFfMfcryrcMnK/zUD37Jw9xNl9uILHNgEC1Q29Ee+j3rxx2zDf69QN/V1lcvOX0//
	+uJNrEt6hmDEZfEb1/a/CNHdPWeKbUDVS/bw2XtK4jwt6hdKf/29z/v2+nlrjqZ07nl/q11r
	jnzqjad7xdV2r2e5+yDEWn2e21X2lDTN6Om7LqaJiyuxFGckGmoxFxUnAgDzWAqu3AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set the parent device of extcon device using first parameter of
devm_extco_dev_allocate() to remove duplicate code on all of extcon provider
drivers.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Reported-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Graeme Gregory <gg@slimlogic.co.uk>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-adc-jack.c | 1 -
 drivers/extcon/extcon-arizona.c  | 1 -
 drivers/extcon/extcon-class.c    | 2 ++
 drivers/extcon/extcon-gpio.c     | 1 -
 drivers/extcon/extcon-max77693.c | 1 -
 drivers/extcon/extcon-max8997.c  | 1 -
 drivers/extcon/extcon-palmas.c   | 1 -
 7 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/extcon/extcon-adc-jack.c b/drivers/extcon/extcon-adc-jack.c
index e18f95b..d860229 100644
--- a/drivers/extcon/extcon-adc-jack.c
+++ b/drivers/extcon/extcon-adc-jack.c
@@ -112,7 +112,6 @@ static int adc_jack_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "failed to allocate extcon device\n");
 		return -ENOMEM;
 	}
-	data->edev->dev.parent = &pdev->dev;
 	data->edev->name = pdata->name;
 
 	/* Check the length of array and set num_cables */
diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index c634796..d9bd3c3 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -1165,7 +1165,6 @@ static int arizona_extcon_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 	info->edev->name = "Headset Jack";
-	info->edev->dev.parent = arizona->dev;
 
 	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret < 0) {
diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 18d42c0..4c2f2c5 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -645,6 +645,8 @@ struct extcon_dev *devm_extcon_dev_allocate(struct device *dev,
 		return edev;
 	}
 
+	edev->dev.parent = dev;
+
 	*ptr = edev;
 	devres_add(dev, ptr);
 
diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 645b283..5b7ec27 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -105,7 +105,6 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 	extcon_data->edev->name = pdata->name;
-	extcon_data->edev->dev.parent = &pdev->dev;
 
 	extcon_data->gpio = pdata->gpio;
 	extcon_data->gpio_active_low = pdata->gpio_active_low;
diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 2c7c3e1..e9ec6ae 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1183,7 +1183,6 @@ static int max77693_muic_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 	info->edev->name = DEV_NAME;
-	info->edev->dev.parent = &pdev->dev;
 
 	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret) {
diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index d9f7f1b..d22c379 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -706,7 +706,6 @@ static int max8997_muic_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 	info->edev->name = DEV_NAME;
-	info->edev->dev.parent = &pdev->dev;
 
 	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret) {
diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 5efa96c..230e122 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -194,7 +194,6 @@ static int palmas_usb_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 	palmas_usb->edev->name = kstrdup(node->name, GFP_KERNEL);
-	palmas_usb->edev->dev.parent = palmas_usb->dev;
 	palmas_usb->edev->mutually_exclusive = mutually_exclusive;
 
 	status = devm_extcon_dev_register(&pdev->dev, palmas_usb->edev);
-- 
1.8.0

