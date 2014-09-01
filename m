Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaIALOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:14:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59826 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaIALOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:14:43 -0400
X-AuditID: cbfee68d-f79c46d000000b84-10-54045521a623
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jaewon Kim <jaewon02.kim@samsung.com>
Subject: [PATCH 1/3] mfd: max77693: Initialize haptic register map
Date: Mon, 01 Sep 2014 20:14:29 +0900
Message-id: <1409570071-26719-2-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1409570071-26719-1-git-send-email-jaewon02.kim@samsung.com>
References: <1409570071-26719-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWyRsSkUFcxlCXEYH2LpcX1L89ZLQ4vesFo
	saPhCKvF/a9HGS1ufvrGanF51xw2i9PdrA7sHjtn3WX3uHNtD5vHvJOBHn1bVjF6fN4kF8Aa
	xWWTkpqTWZZapG+XwJXRMm0OY8FroYoH11axNjDe4O9i5OSQEDCR+H96FwuELSZx4d56ti5G
	Lg4hgaWMEguPHGGEKWr6NJsdIjGdUWL934mMEE4bk8TKR3PZQarYBLQlvq9fzApiiwhUSvR3
	v2AFKWIW6GGU+N6+mhkkISzgJHFz8WewfSwCqhLXXr4FmsTBwSvgIfFgoz6IKSGgIDFnkg1I
	BaeAp8TuZ2fBRgoBVaxa+Qlsr4TAPHaJ6Ru3QI0RkPg2+RALRK+sxKYDzBBHS0ocXHGDZQKj
	8AJGhlWMoqkFyQXFSelFhnrFibnFpXnpesn5uZsYgSF++t+z3h2Mtw9YH2IU4GBU4uF9MIs5
	RIg1say4MvcQoynQhonMUqLJ+cBIyiuJNzQ2M7IwNTE1NjK3NFMS51WU+hksJJCeWJKanZpa
	kFoUX1Sak1p8iJGJg1OqgTHfX8BSw4NnVuyt9Pq66826jvt7xPrWTo3N/rjQ7OnSvyrBZ4Ol
	n71Rn26XIXTL7MbKxzvmbuzMiL6rPoX51krT4Goxzpbcx8ISXv84wi6K7Vm0xX/yAitPt5/y
	UU+XMHx+cbreqfvYv9wV//2TpksxNPw6t22SYFmt8uMzploLzFOXx5+I4lRiKc5INNRiLipO
	BAAAVd0ebAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsVy+t9jQV3FUJYQg+edhhbXvzxntTi86AWj
	xY6GI6wW978eZbS4+ekbq8XlXXPYLE53szqwe+ycdZfd4861PWwe804GevRtWcXo8XmTXABr
	VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QFUoK
	ZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjJZpcxgLXgtVPLi2irWB8QZ/
	FyMnh4SAiUTTp9nsELaYxIV769m6GLk4hASmM0qs/zuREcJpY5JY+WguWBWbgLbE9/WLWUFs
	EYFKif7uF6wgRcwCPYwS39tXM4MkhAWcJG4u/swCYrMIqEpce/kWaBIHB6+Ah8SDjfogpoSA
	gsScSTYgFZwCnhK7n50FGykEVLFq5SfGCYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefn
	bmIER9AzqR2MKxssDjEKcDAq8fA+mMUcIsSaWFZcmXuIUYKDWUmEt9CRJUSINyWxsiq1KD++
	qDQntfgQoynQTROZpUST84HRnVcSb2hsYmZkaWRuaGFkbK4kznug1TpQSCA9sSQ1OzW1ILUI
	po+Jg1OqgdHHtYH5xApfl5sz1HN3O33h359Y/uQCU8aui7nPogo0znWveKP7b82GjDXS7qY5
	uy46JCx7mVs19waP6xEGG0Z3y4D29RvXTFM/3rIr1frZd85rvbwC0847S4gXm3/+OkHLa6ml
	Wcckxeo3jEcvFW66kmW65M88mZameLPELR7WQkwXfBfHeiixFGckGmoxFxUnAgCBoZ09tgIA	AA==
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

