Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbaIQQmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:42:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36239 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbaIQQkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:40:45 -0400
X-AuditID: cbfee691-f79546d0000011a1-d2-5419b9898f0f
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH v5 1/3] mfd: max77693: Initialize haptic register map
Date: Thu, 18 Sep 2014 01:40:24 +0900
Message-id: <1410972026-25189-2-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1410972026-25189-1-git-send-email-jaewon02.kim@samsung.com>
References: <1410972026-25189-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsWyRsSkULdzp2SIwbQnOhbXvzxntdjRcITV
	4v7Xo4wWl3fNYXNg8bhzbQ+bR9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGXc6LnBXDBduOLk
	zCOsDYz/+bsYOTkkBEwk2l+uZ4GwxSQu3FvP1sXIxSEksJRR4s7+AywwRd8OfGOESCxilDhz
	/xYrhNPGJDHz/jZWkCo2AW2J7+sXA9kcHCICKhLn3piDmMwC+RL/N5mBVAgLuEr0vjvLBmKz
	CKhKTG09BTafV8BD4sOUl8wg5RICChJzJtmAhDkFPCUa1l5hBLGFgEoOTvvOBLJVQuA7m8SR
	mc0sEHMEJL5NPsQC0SsrsekAM8TJkhIHV9xgmcAovICRYRWjaGpBckFxUnqRqV5xYm5xaV66
	XnJ+7iZGYMCe/vds4g7G+wesDzEKcDAq8fBuuCwRIsSaWFZcmXuI0RRow0RmKdHkfGBc5JXE
	GxqbGVmYmpgaG5lbmimJ8+pI/wwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwCh/fEmhS6rs
	vJxeS4ObunlfyucJNm8y2DPBSOpVcboqk+uEF2zK3o8vNBfFqbDxxCr/2PJ1i0P/0Zk7TdS4
	pvDeKF0UtDg70unCjC3a8h9UtCZ8ci740Royf5Oz41uO7xLWTK5efj51cWnH7r5QtZqz07BM
	OsruH8+ZpAKr89uaPrbzxscdUWIpzkg01GIuKk4EAAYSIJhTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xgG7nTskQg03XVC2uf3nOarGj4Qir
	xf2vRxktLu+aw+bA4nHn2h42j74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHMuNFzg7lgunDFyZlHWBsY//N3MXJySAiYSHw78I0RwhaTuHBvPVsXIxeH
	kMAiRokz92+xQjhtTBIz729jBaliE9CW+L5+MZDNwSEioCJx7o05iMkskC/xf5MZSIWwgKtE
	77uzbCA2i4CqxNTWUywgNq+Ah8SHKS+ZQcolBBQk5kyyAQlzCnhKNKy9AnaCEFDJwWnfmSYw
	8i5gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERwPz6R2MK5ssDjEKMDBqMTDu+GyRIgQ
	a2JZcWXuIUYJDmYlEV7rjZIhQrwpiZVVqUX58UWlOanFhxhNgY6ayCwlmpwPjNW8knhDYxMz
	I0sjc0MLI2NzJXHeA63WgUIC6YklqdmpqQWpRTB9TBycUg2MahOVJ105mS+xPF6KU2PKmSvZ
	xxZu3v3tiXj82gXOgotzf8YbvmOYtdugpTXz1AulhS8vrN/3ZtER8Xmz54tV2kj3z5qZb2Hz
	89xeN9+pe3kYdU5e0gzoMbLfOV0qw0O1Jkp0g6Gl8KYn4Sd3TRawv+Kq5ND2MTdv5oHNedMe
	umy4KfS3rb75rRJLcUaioRZzUXEiAGIV3HCdAgAA
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

