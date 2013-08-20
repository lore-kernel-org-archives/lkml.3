Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab3HTHFO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:05:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64164 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3HTHFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:05:12 -0400
X-AuditID: cbfee691-b7fef6d000002d62-34-52131527914a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 3/6] mfd: menelaus: use devm_*() functions
Date: Tue, 20 Aug 2013 16:05:11 +0900
Message-id: <005701ce9d73$9c749910$d55dcb30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6dc5mdb0Te18XdSGGCQdCNKOBMqg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zfV11UeEgg1cdchaXF15itbj/9Sij
	xeVdc9gsTnezOrB43Lm2h81j3slAj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4MpYcf8CU8E0
	gYqpF7czNzA+5uli5OSQEDCROPz4FBOELSZx4d56ti5GLg4hgWWMElufTWGDKZo9bx4LRGI6
	o8T15nVMEM4vRokL10+AtbMJqEl8+XKYvYuRg0NEwE+iYQU7SJhZwEni55aZLCC2sICVxKeZ
	E8FsFgFViQntN5lBbF4BS4lvCx4wQdiCEj8m32OB6NWSWL/zOBOELS+xec1bZoiDFCR2nH3N
	CGKLCOhJrJjzkRWiRkRi34t3jCC3SQhsYpeYuayVDWKZgMS3yYdYQG6TEJCV2HQAao6kxMEV
	N1gmMIrNQrJ6FpLVs5CsnoVkxQJGllWMoqkFyQXFSelFpnrFibnFpXnpesn5uZsYITE2cQfj
	/QPWhxiTgdZPZJYSTc4HxmheSbyhsZmRhamJqbGRuaUZacJK4rzqLdaBQgLpiSWp2ampBalF
	8UWlOanFhxiZODilGhgldQ9Z8Yjaz74uOtHFcmLT5iKRWpkl6muWvWNdEnbVekrS5M2Gi3kU
	Tyu8Mz4gWH6LrX/5GrG53xh+yoZGBB03vrpt/ZXctz/nt3mprK5exWxk/zXhcWWocrvIm0dM
	720/+flPdMqxstnwfG/d5xyb/1wHdV/rm3T/X3PxXqOVUYqHd6CYw3MlluKMREMt5qLiRAAS
	r8mMxwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jQV11UeEgg48NUhaXF15itbj/9Sij
	xeVdc9gsTnezOrB43Lm2h81j3slAj74tqxg9Pm+SC2CJamC0yUhNTEktUkjNS85PycxLt1Xy
	Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3wzQhNMRN1wKm
	MULXNyQIrsfIAA0krGPMWHH/AlPBNIGKqRe3MzcwPubpYuTkkBAwkZg9bx4LhC0mceHeerYu
	Ri4OIYHpjBLXm9cxQTi/GCUuXD/BBFLFJqAm8eXLYfYuRg4OEQE/iYYV7CBhZgEniZ9bZoIN
	Ehawkvg0cyKYzSKgKjGh/SYziM0rYCnxbcEDJghbUOLH5HssEL1aEut3HmeCsOUlNq95ywxx
	kILEjrOvGUFsEQE9iRVzPrJC1IhI7HvxjnECo8AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihO
	Ss811CtOzC0uzUvXS87P3cQIjuBnUjsYVzZYHGIU4GBU4uHtVBIKEmJNLCuuzD3EKMHBrCTC
	6/IfKMSbklhZlVqUH19UmpNafIgxGejTicxSosn5wOSSVxJvaGxiZmRpZGZhZGJuTpqwkjjv
	gVbrQCGB9MSS1OzU1ILUIpgtTBycUg2Mp/J+FLMcXWskti/3xutT7isv6Ko+57jHE2HFGv3p
	5/rmKAdX/o1m03SlGN80ypcG8lk/S1bq71a6/vyk6cbWwtLK7hWNbLfkZt7Sv7CrztiP79MW
	7q8X55wX9Pmdml93RGpzJIOpzcOI+czP6388dy7VFr5XuzLz0m37PZvto38vOPTEM/ygEktx
	RqKhFnNRcSIAX4tOWCQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/menelaus.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
index f24df8c..ad25bfa 100644
--- a/drivers/mfd/menelaus.c
+++ b/drivers/mfd/menelaus.c
@@ -1197,7 +1197,7 @@ static int menelaus_probe(struct i2c_client *client,
 		return -ENODEV;
 	}
 
-	menelaus = kzalloc(sizeof *menelaus, GFP_KERNEL);
+	menelaus = devm_kzalloc(&client->dev, sizeof(*menelaus), GFP_KERNEL);
 	if (!menelaus)
 		return -ENOMEM;
 
@@ -1210,8 +1210,7 @@ static int menelaus_probe(struct i2c_client *client,
 	rev = menelaus_read_reg(MENELAUS_REV);
 	if (rev < 0) {
 		pr_err(DRIVER_NAME ": device not found");
-		err = -ENODEV;
-		goto fail1;
+		return -ENODEV;
 	}
 
 	/* Ack and disable all Menelaus interrupts */
@@ -1231,7 +1230,7 @@ static int menelaus_probe(struct i2c_client *client,
 		if (err) {
 			dev_dbg(&client->dev,  "can't get IRQ %d, err %d\n",
 					client->irq, err);
-			goto fail1;
+			return err;
 		}
 	}
 
@@ -1242,7 +1241,7 @@ static int menelaus_probe(struct i2c_client *client,
 
 	val = menelaus_read_reg(MENELAUS_VCORE_CTRL1);
 	if (val < 0)
-		goto fail2;
+		goto fail;
 	if (val & (1 << 7))
 		menelaus->vcore_hw_mode = 1;
 	else
@@ -1251,17 +1250,15 @@ static int menelaus_probe(struct i2c_client *client,
 	if (menelaus_pdata != NULL && menelaus_pdata->late_init != NULL) {
 		err = menelaus_pdata->late_init(&client->dev);
 		if (err < 0)
-			goto fail2;
+			goto fail;
 	}
 
 	menelaus_rtc_init(menelaus);
 
 	return 0;
-fail2:
+fail:
 	free_irq(client->irq, menelaus);
 	flush_work(&menelaus->work);
-fail1:
-	kfree(menelaus);
 	return err;
 }
 
@@ -1271,7 +1268,6 @@ static int __exit menelaus_remove(struct i2c_client *client)
 
 	free_irq(client->irq, menelaus);
 	flush_work(&menelaus->work);
-	kfree(menelaus);
 	the_menelaus = NULL;
 	return 0;
 }
-- 
1.7.10.4


