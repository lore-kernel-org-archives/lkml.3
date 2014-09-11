Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbaIKMyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:54:33 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57473 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbaIKMy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:54:28 -0400
X-AuditID: cbfee68f-f797f6d000001173-92-54119b82b097
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v4 1/4] mfd: max77693: Initialize haptic register map
Date: Thu, 11 Sep 2014 21:54:19 +0900
Message-id: <1410440062-19963-2-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1410440062-19963-1-git-send-email-jaewon02.kim@samsung.com>
References: <1410440062-19963-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWyRsSkWLdptmCIwbZfhhbXvzxntTi86AWj
	xY6GI6wW978eZbS4+ekbq8XlXXPYLE53szqwe+ycdZfd4861PWwe804GevRtWcXo8XmTXABr
	FJdNSmpOZllqkb5dAlfGjZ4bzAXThStOzjzC2sD4n7+LkZNDQsBE4veLR2wQtpjEhXvrgWwu
	DiGBpYwSb55dZoUpmrTgNliRkMAiRokPy90hitqYJLpW/QZLsAloS3xfvxisQUSgUqK/+wUr
	SBGzQA+jxNJVS9lBEsICrhLPTrwEauDgYBFQlXj+RAskzCvgIXFjzzewsISAgsScSTYgYU4B
	T4lb3XPYIfZ6SJzrWckCcc9kdonOWR4gNouAgMS3yYdYIFplJTYdYIYokZQ4uOIGywRG4QWM
	DKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxAsP79L9n/TsY7x6wPsQowMGoxMNbwSIYIsSa
	WFZcmXuI0RRow0RmKdHkfGAU5ZXEGxqbGVmYmpgaG5lbmimJ8y6U+hksJJCeWJKanZpakFoU
	X1Sak1p8iJGJg1OqgVHsO9PllwrqoX3yLV9OBN57MSslZrlk5cndC9gTpLxubd3dIbIzlS/s
	qaHun8Us8v4F8048/WE8Mzv/ebPssrc1L3MW6Rklij+YFr9WMXjOAhOLbSbLqqSLX7l9yQsw
	WMOU05RsVlAQ4nbmkNP7TelxX9v4l1geYVgw4fyOoFNFftPY771+oKrEUpyRaKjFXFScCAAh
	9hFOagIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jAd2m2YIhBgeeallc//Kc1eLwoheM
	FjsajrBa3P96lNHi5qdvrBaXd81hszjdzerA7rFz1l12jzvX9rB5zDsZ6NG3ZRWjx+dNcgGs
	UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
	lCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM2703GAumC5ccXLmEdYGxv/8
	XYycHBICJhKTFtxmg7DFJC7cWw9mCwksYpT4sNy9i5ELyG5jkuha9RsswSagLfF9/WJWEFtE
	oFKiv/sFK0gRs0APo8TSVUvZQRLCAq4Sz068BGrg4GARUJV4/kQLJMwr4CFxY883sLCEgILE
	nEk2IGFOAU+JW91z2CH2ekic61nJMoGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M
	4Ph5JrWDcWWDxSFGAQ5GJR7eChbBECHWxLLiytxDjBIczEoivDemA4V4UxIrq1KL8uOLSnNS
	iw8xmgLdNJFZSjQ5HxjbeSXxhsYmZkaWRuaGFkbG5krivAdarQOFBNITS1KzU1MLUotg+pg4
	OKUaGHe4dPxQra3gNwl4J1RaL7W/fvJG0ZNqL6SUp23Nmy/v/3m2maqHFsexlZ+zt//xT5SS
	bdgqVXzAKrSC0WHvVmX2f27fVMsDJuzWDxK6x6qweNOyqV2ylVM8v8TO9TdSmjGhkqH7dafU
	PwMLxr8ZClsnZz/8fXDP4e/X3F3bF6bPLWOKK0/oVWIpzkg01GIuKk4EAIoWRLu1AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add regmap_haptic initialization to use haptic register map
in haptic device driver.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/max77693.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index 249c139..fbfed56 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -144,6 +144,12 @@ static const struct regmap_irq_chip max77693_muic_irq_chip = {
 	.num_irqs		= ARRAY_SIZE(max77693_muic_irqs),
 };
 
+static const struct regmap_config max77693_regmap_haptic_config = {
+	.reg_bits = 8,
+	.val_bits = 8,
+	.max_register = MAX77693_HAPTIC_REG_END,
+};
+
 static int max77693_i2c_probe(struct i2c_client *i2c,
 			      const struct i2c_device_id *id)
 {
@@ -193,6 +199,15 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 	}
 	i2c_set_clientdata(max77693->haptic, max77693);
 
+	max77693->regmap_haptic = devm_regmap_init_i2c(max77693->haptic,
+					&max77693_regmap_haptic_config);
+	if (IS_ERR(max77693->regmap_haptic)) {
+		ret = PTR_ERR(max77693->regmap_haptic);
+		dev_err(max77693->dev,
+			"failed to initialize haptic register map: %d\n", ret);
+		goto err_regmap;
+	}
+
 	/*
 	 * Initialize register map for MUIC device because use regmap-muic
 	 * instance of MUIC device when irq of max77693 is initialized
@@ -204,7 +219,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 		ret = PTR_ERR(max77693->regmap_muic);
 		dev_err(max77693->dev,
 			"failed to allocate register map: %d\n", ret);
-		goto err_regmap_muic;
+		goto err_regmap;
 	}
 
 	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
@@ -214,7 +229,7 @@ static int max77693_i2c_probe(struct i2c_client *i2c,
 				&max77693->irq_data_led);
 	if (ret) {
 		dev_err(max77693->dev, "failed to add irq chip: %d\n", ret);
-		goto err_regmap_muic;
+		goto err_regmap;
 	}
 
 	ret = regmap_add_irq_chip(max77693->regmap, max77693->irq,
@@ -265,7 +280,7 @@ err_irq_charger:
 	regmap_del_irq_chip(max77693->irq, max77693->irq_data_topsys);
 err_irq_topsys:
 	regmap_del_irq_chip(max77693->irq, max77693->irq_data_led);
-err_regmap_muic:
+err_regmap:
 	i2c_unregister_device(max77693->haptic);
 err_i2c_haptic:
 	i2c_unregister_device(max77693->muic);
-- 
1.7.9.5

