Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab3IZHxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:53:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57123 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3IZHxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:53:24 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-4d-5243e7f3bcbd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Axel Lin'" <axel.lin@ingics.com>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
In-reply-to: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
Subject: [PATCH V3 12/14] regulator: tps6524x: use devm_regulator_register()
Date: Thu, 26 Sep 2013 16:53:23 +0900
Message-id: <003c01ceba8d$79872c60$6c958520$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66jIjCzH3ID+v5Qym5l1DxbvczrwAAN0Hg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zA93Pz52DDOY8krc4Mucrs8XUh0/Y
	LC4vvMRq8e1KB5PF5V1z2BxYPXbOusvu0fazzGPTqk42j74tqxg9Pm+SC2CN4rJJSc3JLEst
	0rdL4Mq4fv0AS8ExjoqlF9eyNTB+Zeti5OSQEDCR2Hj9CSOELSZx4d56oDgXh5DAMkaJDZeb
	WWCKpr88xAiRmM4osbbpODtIQkjgF6PE3rsmIDabgJrEly+HgeIcHCICqhL/X7mD1DML9DNK
	XNp5hwmi3lai8dtfsKGcAnYSs/afZAaxhQV8JD78fQFmswD1ft9xjBXE5gWqn3h8JzuELSjx
	Y/I9sF5mAS2J9TuPM0HY8hKb17xlBtkrIaAu8eivLkhYRMBI4tPX3YwQJSIS+168A7tfQuAW
	u8SxH0sYIXYJSHybfIgFoldWYtMBZoh/JSUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRN
	LUguKE5KLzLUK07MLS7NS9dLzs/dxAiJ094djLcPWB9iTAZaP5FZSjQ5HxjneSXxhsZmRham
	JqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleakFh9iZOLglGpg1Dm1wvusdklD7T2f
	eQc8dq5an6e1spH1SETDke1tOvvPfudV/xbOpPjLuSx8w5bbRqEzL8v7Ol6f3qKzmJ3Lb2ul
	oKp1UF/ppYhfgm/68pqknmo75T6Q5RE+oBHZ9Kvz9tysLC+F1ufTf6iLHOszf9JZKnL9uods
	+6EU5U+L3FKnCFqJbWJVYinOSDTUYi4qTgQAUvmDxekCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd3Pz52DDP68k7Y4Mucrs8XUh0/Y
	LC4vvMRq8e1KB5PF5V1z2BxYPXbOusvu0fazzGPTqk42j74tqxg9Pm+SC2CNamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMuH79AEvBMY6KpRfXsjUwfmXrYuTkkBAwkZj+
	8hAjhC0mceHeeqA4F4eQwHRGibVNx9lBEkICvxgl9t41AbHZBNQkvnw5DBTn4BARUJX4/8od
	pJ5ZoJ9R4tLOO0wQ9bYSjd/+soDYnAJ2ErP2n2QGsYUFfCQ+/H0BZrMA9X7fcYwVxOYFqp94
	fCc7hC0o8WPyPbBeZgEtifU7jzNB2PISm9e8ZQbZKyGgLvHory5IWETASOLT192MECUiEvte
	vGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgpPAM+kd
	jKsaLA4xCnAwKvHwXmB2DhJiTSwrrsw9xCjBwawkwvvNCCjEm5JYWZValB9fVJqTWnyIMRno
	0YnMUqLJ+cAElVcSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFIN
	jGsD5ij8qlMtdpl87iXLuaNvvDf73jrZ8lP0X1uut+Ts3GYpj3s3bkY71Prz7Tm5d9/Pirfh
	qUrfDA1Dd1+KCr/wWma6nutOOSWdODspxlctOfKak5YH3Quz+7a6sbL5EuObuD/mL4XVlaWW
	/J25eFPl/mjr7qjDui7PNx7n6742ZUFP+0T7NCWW4oxEQy3mouJEAE102OhGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/tps6524x-regulator.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/tps6524x-regulator.c b/drivers/regulator/tps6524x-regulator.c
index 8b9ee39..8fe67fb 100644
--- a/drivers/regulator/tps6524x-regulator.c
+++ b/drivers/regulator/tps6524x-regulator.c
@@ -584,10 +584,8 @@ static int pmic_remove(struct spi_device *spi)
 
 	if (!hw)
 		return 0;
-	for (i = 0; i < N_REGULATORS; i++) {
-		regulator_unregister(hw->rdev[i]);
+	for (i = 0; i < N_REGULATORS; i++)
 		hw->rdev[i] = NULL;
-	}
 	return 0;
 }
 
@@ -631,7 +629,8 @@ static int pmic_probe(struct spi_device *spi)
 		config.init_data = init_data;
 		config.driver_data = hw;
 
-		hw->rdev[i] = regulator_register(&hw->desc[i], &config);
+		hw->rdev[i] = devm_regulator_register(dev, &hw->desc[i],
+						      &config);
 		if (IS_ERR(hw->rdev[i])) {
 			ret = PTR_ERR(hw->rdev[i]);
 			hw->rdev[i] = NULL;
-- 
1.7.10.4


