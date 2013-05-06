Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab3EFD3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:29:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35780 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab3EFD3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:29:21 -0400
X-AuditID: cbfee68f-b7f066d000003683-b9-5187238f8418
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 3/7] gpio: rdc321x: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 12:29:18 +0900
Message-id: <001901ce4a09$e48fe640$adafb2c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KCdlUNWbB0aS4SfuMWqfggC0pYQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t8zA91+5fZAg/VXJCxendnIZnF54SVW
	iyl/ljNZXN41h82BxePOtT1sHn1bVjF6/Hyp4/F5k1wASxSXTUpqTmZZapG+XQJXxoyzT5kK
	3nJXzH84g7mB8QlnFyMnh4SAicSshk1MELaYxIV769m6GLk4hASWMUrMXTSbDabo2/+tTBCJ
	6YwSXWcXMEI4vxglFv99wwJSxSagJvHly2F2EFtEQE/ixoUORhCbWaBA4vTBt2CThAV8JXZd
	ngS2jkVAVWLixe2sIDavgKXE/FcQ9bwCghI/Jt9jgejVkli/8zgThC0vsXnNW2aIixQkdpx9
	zQiz69vRlVC7RCT2vXgHdpyEwDp2iXO7lrJCLBOQ+Db5ENBQDqCErMSmA1BzJCUOrrjBMoFR
	bBaS1bOQrJ6FZPUsJCsWMLKsYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAiJs/4djHcPWB9i
	TAZaP5FZSjQ5HxineSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgnKe1bGHbdjnh3S6TBfcuCTjBckBh61zh5l8MfzuNbFnOqOhejDm2VWjxkaaa
	mOM3N2XrrPTi8l7MKcVqqSRdJaT/yytzzpZr/uliKq+D/eyO7X8yjeXq2qPMRx/vtPF+eUU8
	/liG+QwBv/m1j759ZfAoOvLSeKZhOOP+K/WOG06dmXT9hISOkRJLcUaioRZzUXEiAFO8UUnJ	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jQd1+5fZAg4MXRSxendnIZnF54SVW
	iyl/ljNZXN41h82BxePOtT1sHn1bVjF6/Hyp4/F5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8aMs0+ZCt5yV8x/OIO5gfEJZxcjJ4eEgInEt/9bmSBsMYkL99az
	dTFycQgJTGeU6Dq7gBHC+cUosfjvGxaQKjYBNYkvXw6zg9giAnoSNy50MILYzAIFEqcPvmUD
	sYUFfCV2XZ4ENpVFQFVi4sXtrCA2r4ClxPxXEPW8AoISPybfY4Ho1ZJYv/M4E4QtL7F5zVtm
	iIsUJHacfc0Is+vb0ZVQu0Qk9r14xziBUWAWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca
	6hUn5haX5qXrJefnbmIER/EzqR2MKxssDjEKcDAq8fAWPGkLFGJNLCuuzD3EKMHBrCTC67MX
	KMSbklhZlVqUH19UmpNafIgxGejTicxSosn5wASTVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbr
	QCGB9MSS1OzU1ILUIpgtTBycUg2M1skGO+ep106N3+P6uTxQN2uvTdyyf4debBReqhQms/9n
	7DEbxdsRB92jt+9YPDFmDcvkXaGlfP9mS5yYlfR1wpIa0bf2F1I4ElKPmDN9XFxhs3uvVv0V
	47SO7x43YmebmKxVefFmgbXAT6Mv22e4fbw/817swU2RWpbTPZtvByv47T/nxlX6XYmlOCPR
	UIu5qDgRAMC5gaYmAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/gpio/gpio-rdc321x.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpio-rdc321x.c b/drivers/gpio/gpio-rdc321x.c
index 1bf55f6..368c3c0 100644
--- a/drivers/gpio/gpio-rdc321x.c
+++ b/drivers/gpio/gpio-rdc321x.c
@@ -187,20 +187,18 @@ static int rdc321x_gpio_probe(struct platform_device *pdev)
 					rdc321x_gpio_dev->reg1_data_base,
 					&rdc321x_gpio_dev->data_reg[0]);
 	if (err)
-		goto out_drvdata;
+		goto out_free;
 
 	err = pci_read_config_dword(rdc321x_gpio_dev->sb_pdev,
 					rdc321x_gpio_dev->reg2_data_base,
 					&rdc321x_gpio_dev->data_reg[1]);
 	if (err)
-		goto out_drvdata;
+		goto out_free;
 
 	dev_info(&pdev->dev, "registering %d GPIOs\n",
 					rdc321x_gpio_dev->chip.ngpio);
 	return gpiochip_add(&rdc321x_gpio_dev->chip);
 
-out_drvdata:
-	platform_set_drvdata(pdev, NULL);
 out_free:
 	kfree(rdc321x_gpio_dev);
 	return err;
@@ -216,7 +214,6 @@ static int rdc321x_gpio_remove(struct platform_device *pdev)
 		dev_err(&pdev->dev, "failed to unregister chip\n");
 
 	kfree(rdc321x_gpio_dev);
-	platform_set_drvdata(pdev, NULL);
 
 	return ret;
 }
-- 
1.7.2.5


