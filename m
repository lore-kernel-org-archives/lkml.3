Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077Ab3BTGMp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 01:12:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:18173 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933224Ab3BTGMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 01:12:43 -0500
X-AuditID: cbfee68d-b7f4f6d000004209-49-51246957bc55
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
In-reply-to: <002601ce0f30$d6b81c40$842854c0$%han@samsung.com>
Subject: [PATCH 07/11] mfd: menelaus: use devm_request_irq() and devm_kzalloc()
Date: Wed, 20 Feb 2013 15:12:38 +0900
Message-id: <002c01ce0f31$48d55e00$da801a00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PMNZl2zNDd+kPTaydPUTuUPUSLQAAGLQg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zI93wTJVAgycvBC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGm54LjAWLhSv+XfBsYFzD38XIySEhYCIxaekdJghbTOLCvfVs
	XYxcHEICyxglnn36zApTtODCLXaIxHRGiauTVjNBOLOZJN7+amEHqWITUJP48uUwmC0ioCXR
	few80CgODmYBF4mj00RAwkICthLf1/4DG8opYCex69F5MFtYwF/iw6NOsCtYBFQlvh26wwzS
	ygtUf32OGEiYV0BQ4sfkeywgNjPQ9PU7jzNB2PISm9e8BSuXEFCXePRXF+IAI4mVB04wQpSI
	SOx78Y4R5GIJgUXsEtc2fodaJSDxbfIhFoheWYlNB5gh3pWUOLjiBssERolZSDbPQrJ5FpLN
	s5CsWMDIsopRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjJKp6dzDePmB9iDEZaP1EZinR5Hxg
	VOaVxBsaG5uYmZiamFuampuSJqwkzit3SSZQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUAyOb
	xZNpk9k0v92fWH7lrvlODc8PB67f5Z1h+z9wgmq6IWf2wUzfJP+iBX37TPbrdBbOXb7Ucn6u
	5GO7fqOHzjJ53pIZxRazdX58t9umm3zpgYH7wrUPbSdqCxu9ujmR61xpheq97uDFZ005xa9O
	uiIyWXJefLGbzkUB7U938jey3Fqtt0Vf7pQSS3FGoqEWc1FxIgBM/PnLwAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xoG54pkqgwa9F3BaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x403PBcaCxcIV/y54NjCu
	4e9i5OSQEDCRWHDhFjuELSZx4d56ti5GLg4hgemMElcnrWaCcGYzSbz91QJWxSagJvHly2Ew
	W0RAS6L72HmgDg4OZgEXiaPTREDCQgK2Et/X/mMFsTkF7CR2PToPZgsL+Et8eNTJBGKzCKhK
	fDt0hxmklReo/vocMZAwr4CgxI/J91hAbGag6et3HmeCsOUlNq95C1YuIaAu8eivLsQBRhIr
	D5xghCgRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpec
	n7uJERyzz6R3MK5qsDjEKMDBqMTD27BQOVCINbGsuDL3EKMEB7OSCG+zk0qgEG9KYmVValF+
	fFFpTmrxIcZkoD8nMkuJJucD00leSbyhsYmZkaWRmYWRibk5acJK4ryMp54ECAmkJ5akZqem
	FqQWwWxh4uCUamBcf/ZJop6v3eRrlrf0MuNelbw7flKndPKZrttVk8KOPT9ZIHzvnvrkNTt3
	Ssw96rBo94+q3vOzLfXuHFV3WLrhd3H3mqOL109e18YSvmaqTo7X7EXb527yVDyj+6xsqfZE
	B5+N/x24lnbXRdrN7vhXm/Rm49nAt3v+h9q/zfz0Xt84vijKPWyfnRJLcUaioRZzUXEiADb6
	xQUdAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_request_irq() and devm_kzalloc() to make cleanup paths
more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/menelaus.c |   23 +++++++++--------------
 1 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index 998ce8c..28bac1c 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -1197,7 +1197,8 @@ static int menelaus_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	menelaus = kzalloc(sizeof *menelaus, GFP_KERNEL);
+	menelaus = devm_kzalloc(&client->dev, sizeof(*menelaus),
+				GFP_KERNEL);
 	if (!menelaus)
 		return -ENOMEM;
 
@@ -1210,8 +1211,7 @@ static int menelaus_probe(struct i2c_client *client,
 	rev = menelaus_read_reg(MENELAUS_REV);
 	if (rev < 0) {
 		pr_err(DRIVER_NAME ": device not found");
-		err = -ENODEV;
-		goto fail1;
+		return -ENODEV;
 	}
 
 	/* Ack and disable all Menelaus interrupts */
@@ -1226,12 +1226,12 @@ static int menelaus_probe(struct i2c_client *client,
 	menelaus_write_reg(MENELAUS_MCT_CTRL1, 0x73);
 
 	if (client->irq > 0) {
-		err = request_irq(client->irq, menelaus_irq, 0,
-				  DRIVER_NAME, menelaus);
+		err = devm_request_irq(&client->dev, client->irq, menelaus_irq,
+					0, DRIVER_NAME, menelaus);
 		if (err) {
 			dev_dbg(&client->dev,  "can't get IRQ %d, err %d\n",
 					client->irq, err);
-			goto fail1;
+			return err;
 		}
 	}
 
@@ -1242,7 +1242,7 @@ static int menelaus_probe(struct i2c_client *client,
 
 	val = menelaus_read_reg(MENELAUS_VCORE_CTRL1);
 	if (val < 0)
-		goto fail2;
+		goto fail1;
 	if (val & (1 << 7))
 		menelaus->vcore_hw_mode = 1;
 	else
@@ -1251,17 +1251,14 @@ static int menelaus_probe(struct i2c_client *client,
 	if (menelaus_pdata != NULL && menelaus_pdata->late_init != NULL) {
 		err = menelaus_pdata->late_init(&client->dev);
 		if (err < 0)
-			goto fail2;
+			goto fail1;
 	}
 
 	menelaus_rtc_init(menelaus);
 
 	return 0;
-fail2:
-	free_irq(client->irq, menelaus);
-	flush_work(&menelaus->work);
 fail1:
-	kfree(menelaus);
+	flush_work(&menelaus->work);
 	return err;
 }
 
@@ -1269,9 +1266,7 @@ static int __exit menelaus_remove(struct i2c_client *client)
 {
 	struct menelaus_chip	*menelaus = i2c_get_clientdata(client);
 
-	free_irq(client->irq, menelaus);
 	flush_work(&menelaus->work);
-	kfree(menelaus);
 	the_menelaus = NULL;
 	return 0;
 }
-- 
1.7.2.5


