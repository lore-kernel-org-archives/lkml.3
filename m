Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbaJAGoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 02:44:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23286 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaJAGoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 02:44:10 -0400
X-AuditID: cbfee68e-f79b46d000002b74-ed-542ba2b61af6
From: Jaewon Kim <jaewon02.kim@samsung.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Jaewon Kim <jaewon02.kim@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH RESEND v5 1/3] mfd: max77693: Initialize haptic register map
Date: Wed, 01 Oct 2014 15:43:56 +0900
Message-id: <1412145838-7563-2-git-send-email-jaewon02.kim@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1412145838-7563-1-git-send-email-jaewon02.kim@samsung.com>
References: <1412145838-7563-1-git-send-email-jaewon02.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsWyRsSkQHfbIu0Qg72rTCyuf3nOanF40QtG
	ix0NR1gt7n89ymhxedccNgdWj52z7rJ73Lm2h82jb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4
	Mm703GAumC5ccXLmEdYGxv/8XYycHBICJhJtH0+yQdhiEhfurQeyuTiEBJYySqx+v5wdpujP
	hBaoxHRGiW0N75ghnDYmiSVn9zKBVLEJaEt8X7+YtYuRg0NEQEXi3BtzkBpmgXmMEudv7wFb
	ISzgI/Fm7k1mEJtFQFXiyIZDYHFeAXeJQ1u+s4D0SggoSMyZZAMS5hTwkDjTfIQdJCwEVPLl
	eQ3ISAmBZnaJVw9mskKMEZD4NvkQVKusxKYDzBA3S0ocXHGDZQKj8AJGhlWMoqkFyQXFSelF
	RnrFibnFpXnpesn5uZsYgWF8+t+zvh2MNw9YH2IU4GBU4uFVSNAOEWJNLCuuzD3EaAq0YSKz
	lGhyPjBa8kriDY3NjCxMTUyNjcwtzZTEeROkfgYLCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRq
	YOQ5/P+Mdd3dC4qqs7m+iDwyCpsTEp2/PMnfulKZ/0UNY076XlsrmePbtriUHSx2n7RB5OUt
	dUe2VwcX9X9l0Uq0mCr4Y9uGKUsmtpYW7E1IT7ieFeriNY/9yX35txdClYMtuVynLVj6Rq9B
	sXrj8Y2Rh1cm88v9ycrw4Yh4vub1m1p5xdPv/iuxFGckGmoxFxUnAgAz9Gs3XgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t9jQd1ti7RDDD5/0LG4/uU5q8XhRS8Y
	LXY0HGG1uP/1KKPF5V1z2BxYPXbOusvucefaHjaPvi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1L
	zk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqspFCWmFMKFApILC5W0rfD
	NCE0xE3XAqYxQtc3JAiux8gADSSsYcy40XODuWC6cMXJmUdYGxj/83cxcnJICJhI/JnQwgZh
	i0lcuLceyObiEBKYziixreEdM4TTxiSx5OxeJpAqNgFtie/rF7N2MXJwiAioSJx7Yw5Swyww
	j1Hi/O09YJOEBXwk3sy9yQxiswioShzZcAgszivgLnFoy3cWkF4JAQWJOZNsQMKcAh4SZ5qP
	sIOEhYBKvjyvmcDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcJQ8k9rBuLLB4hCj
	AAejEg+vQoJ2iBBrYllxZe4hRgkOZiUR3okVQCHelMTKqtSi/Pii0pzU4kOMpkA3TWSWEk3O
	B0ZwXkm8obGJmZGlkbmhhZGxuZI474FW60AhgfTEktTs1NSC1CKYPiYOTqkGRtbzyUIrLxZ9
	DpYX1TNaYX3L7WT5tP/LJY7Yl9VWtbq/f2L7OTI60m89rzXP86hT2Wum3zpXzp1tJ9sl/uj7
	dv8Pu5+9rqvzOsNYe8sz43gRY7dY577/KrzBkX85e525y/emqiRf3Xt9TcXc8ntCFTb8Z1kb
	tSXf8qQsyGTO3fbQoKEgTnCvEktxRqKhFnNRcSIAD8yXvqgCAAA=
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

