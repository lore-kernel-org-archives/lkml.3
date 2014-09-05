Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbaIELuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 07:50:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15509 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137AbaIELtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 07:49:02 -0400
X-AuditID: cbfee691-f79546d0000011a1-69-5409a32b9ecc
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v3 1/4] mfd: max77693: Initialize haptic register map
Date: Fri, 05 Sep 2014 20:48:19 +0900
Message-id: <1409917702-17009-2-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1409917702-17009-1-git-send-email-jaewon02.kim@samsung.com>
References: <1409917702-17009-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWyRsSkRFd7MWeIQcMMc4vrX56zWhxe9ILR
	YkfDEVaL+1+PMlrc/PSN1eLyrjlsFqe7WR3YPXbOusvucefaHjaPeScDPfq2rGL0+LxJLoA1
	issmJTUnsyy1SN8ugSvjRs8N5oLpwhUnZx5hbWD8z9/FyMkhIWAi0XXrOROELSZx4d56ti5G
	Lg4hgaWMEr/X7GSGKTre+ZMdIjGdUaJn8WmoqjYmicUHdrGBVLEJaEt8X7+YFcQWEaiU6O9+
	wQpSxCzQwyjxvX012ChhAVeJ72+Pgu1jEVCVOL1yLVgzr4CHxL4p/1i6GDmA1ilIzJlkAxLm
	FPCU2HX4ERtIWAio5Nk9CZCREgLT2SW+XpjKBjFGQOLb5ENQrbISmw5AHS0pcXDFDZYJjMIL
	GBlWMYqmFiQXFCelF5nqFSfmFpfmpesl5+duYgSG+Ol/zybuYLx/wPoQowAHoxIP74+vHCFC
	rIllxZW5hxhNgTZMZJYSTc4HRlJeSbyhsZmRhamJqbGRuaWZkjivjvTPYCGB9MSS1OzU1ILU
	ovii0pzU4kOMTBycUg2MaW4urr+FDCz0Di4wVuhPCj+68Ffg7lnZ+haeFlJBxgpPch9cWVqz
	clrE7EyWBOXyKZOdJ9XKLy2VDrWpfDzL/uK23u17Jsp55EiK5FjntM9xjNl93XpHd+mN61zz
	94vLSXO+cUwxKV5R/d5AIey81cKsOUtYIzuza2/rz+hqF3ibl/Ts/1ElluKMREMt5qLiRABu
	1lLTbAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t9jQV3txZwhBpv36Vtc//Kc1eLwoheM
	FjsajrBa3P96lNHi5qdvrBaXd81hszjdzerA7rFz1l12jzvX9rB5zDsZ6NG3ZRWjx+dNcgGs
	UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
	lCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM2703GAumC5ccXLmEdYGxv/8
	XYycHBICJhLHO3+yQ9hiEhfurWfrYuTiEBKYzijRs/g0lNPGJLH4wC42kCo2AW2J7+sXs4LY
	IgKVEv3dL1hBipgFehglvrevZgZJCAu4Snx/e5QJxGYRUJU4vXItWDOvgIfEvin/WLoYOYDW
	KUjMmWQDEuYU8JTYdfgRG0hYCKjk2T2JCYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefn
	bmIER9AzqR2MKxssDjEKcDAq8fAu+MwRIsSaWFZcmXuIUYKDWUmE130KZ4gQb0piZVVqUX58
	UWlOavEhRlOgmyYyS4km5wOjO68k3tDYxMzI0sjc0MLI2FxJnPdAq3WgkEB6YklqdmpqQWoR
	TB8TB6dUA+OyIJ9XLjfFRI64xdnvMnhTt0sg5pCXnoHD1Cb7eRGiz1Y/lQjtusm88DRbT3BK
	cqfGBqMgzbtR1frrl5hG90eecz9u9lvrZXLHg7zA858Sf88ui9skXH+9c/nXZ2VuT6zncS11
	Oeh0b35VgGWsdtUthU4z9ocenhNidxRw3WF8Fs3cFLkzQImlOCPRUIu5qDgRAM29woy2AgAA
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

