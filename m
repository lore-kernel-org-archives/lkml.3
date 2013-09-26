Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab3IZCCP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:02:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:31921 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab3IZCCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:02:13 -0400
X-AuditID: cbfee68e-b7f756d000004512-55-524395a2c713
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Subject: [PATCH V2 01/18] regulator: ab3100: use devm_regulator_register()
Date: Thu, 26 Sep 2013 11:02:10 +0900
Message-id: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zI91FU52DDD4dMbSY+vAJm8XlhZdY
	Lb5d6WCymPJnOZPF5V1z2BxYPXbOusvusWlVJ5vHnWt72Dz6tqxi9Pi8SS6ANYrLJiU1J7Ms
	tUjfLoEro+F8P0vBM/aK3W//Mzcw7mbrYuTkkBAwkVjbuZ0FwhaTuHBvPVCci0NIYBmjxJwp
	s5i7GDnAil7PiICIT2eUuHajhxmkQUjgF6PE/s+qIDabgJrEly+H2UHqRQRUJf6/cgepZxaY
	ySixs38HE0iNsICXxM7l78EWswDVnPz4A2wxr4CtxKtDs1khbEGJH5PvgcWZBbQk1u88zgRh
	y0tsXvMW6h51iUd/dUHCIgJ6Er1/5jBDlIhI7HvxjhFkr4TAMXaJ5gefWCF2CUh8m3yIBaJX
	VmLTAWaIfyUlDq64wTKBUWwWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y0itOzC0uzUvX
	S87P3cQIibu+HYw3D1gfYkwGWj+RWUo0OR8Yt3kl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcK
	CaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYGR/XZ2uFp6x0rZyusG2rnnXX/fovl/uYPZl29TD
	k9/aTuXp+lT4an7XdCarO90ibNE9su8X/cmTX7+zQy3dcXvP3htRd7c8Xfl7Q5XpCa0cx6PW
	G64veDxj85EjIdNP28W6rT29z/zF320S84TCXqr2CzsYB85YGjLZqZ738pqERtG9s556Sl5U
	YinOSDTUYi4qTgQAqrcNZdECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQd1FU52DDLb80bWY+vAJm8XlhZdY
	Lb5d6WCymPJnOZPF5V1z2BxYPXbOusvusWlVJ5vHnWt72Dz6tqxi9Pi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMaPhfD9LwTP2it1v/zM3MO5m62Lk4JAQMJF4
	PSOii5ETyBSTuHBvPVCYi0NIYDqjxLUbPcwgCSGBX4wS+z+rgthsAmoSX74cZgfpFRFQlfj/
	yh2knllgJqPEzv4dTCA1wgJeEjuXv2cDsVmAak5+/MECYvMK2Eq8OjSbFcIWlPgx+R5YnFlA
	S2L9zuNMELa8xOY1b5khblOXePRXFyQsIqAn0ftnDjNEiYjEvhfvGCcwCsxCMmkWkkmzkEya
	haRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgqH4mvYNxVYPFIUYBDkYlHt4LzM5B
	QqyJZcWVuYcYJTiYlUR4vxkBhXhTEiurUovy44tKc1KLDzEmAz06kVlKNDkfmHDySuINjU3M
	jCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoGR/y3v79cd+9lKbvDdqLx0
	RLv947v/OtkMap+33jZ4cjtOfdeDh83TxNl/HanljHrLltZfFrdYRerjIR+/+7cS7B3W/Pl6
	8WdulnjOuiN6+1mvRmc/LnRlYPrZ3s75R49ti2/k1Uxh9ZeKLzY2dS/3y72YMSMl9cH7D0/O
	RfCk5j1con7knNNCJZbijERDLeai4kQABV9aMy4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/ab3100.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index 7d5eaa8..77b46d0 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -535,7 +535,7 @@ static int ab3100_regulator_register(struct platform_device *pdev,
 	config.dev = &pdev->dev;
 	config.driver_data = reg;
 
-	rdev = regulator_register(desc, &config);
+	rdev = devm_regulator_register(&pdev->dev, desc, &config);
 	if (IS_ERR(rdev)) {
 		err = PTR_ERR(rdev);
 		dev_err(&pdev->dev,
@@ -616,7 +616,6 @@ static int ab3100_regulators_remove(struct platform_device *pdev)
 	for (i = 0; i < AB3100_NUM_REGULATORS; i++) {
 		struct ab3100_regulator *reg = &ab3100_regulators[i];
 
-		regulator_unregister(reg->rdev);
 		reg->rdev = NULL;
 	}
 	return 0;
-- 
1.7.10.4


