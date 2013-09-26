Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab3IZCJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:09:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33532 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3IZCJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:09:41 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-a1-52439764c1f6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Milo Kim'" <milo.kim@ti.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
In-reply-to: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
Subject: [PATCH V2 11/18] regulator: max8925: use devm_regulator_register()
Date: Thu, 26 Sep 2013 11:09:39 +0900
Message-id: <001101ceba5d$752336d0$5f69a470$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAAPziA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zI92U6c5BBp0HeSymPnzCZnF54SVW
	i29XOpgsLu+aw2ax/Nc6FgdWj52z7rJ7bFrVyebRt2UVo8fxG9uZPD5vkgtgjeKySUnNySxL
	LdK3S+DKuLvtHnPBFO6KOY1TWBoYl3N2MXJySAiYSDR+nswEYYtJXLi3nq2LkYtDSGAZo8SU
	mzNZYIrmvetkhkhMZ5T4c3AFI0hCSOAXo8TVznAQm01ATeLLl8PsXYwcHCICqhL/X7mD1DML
	dAOVLPvMDlFvK3Hq90U2EJtTwE7i9LWNrCC2sIC3xJs//8GuYAHqPbOvG2wOL1D99yWJIGFe
	AUGJH5Pvgd3DLKAlsX7ncSYIW15i85q3zCDlEgLqEo/+6oKERQSMJLZu/MEMUSIise/FO0aQ
	cyQEHrFLvLu4kR1ilYDEt8mHWCB6ZSU2HWCGeFdS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEj
	yypG0dSC5ILipPQiY73ixNzi0rx0veT83E2MkDjt38F494D1IcZkoPUTmaVEk/OBcZ5XEm9o
	bGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsY5y5bqxKv1
	KQTsdingYF6enxn0t0OqJ65h3X1/8T0u6W07zZfPenCwMlQkSyjvyAKlyFXv/JPX3DPwXT2h
	vNB8ztxbG5/v9fmz0lx10epP+9ZekpP509ge8XPfMpk1VTmX3mR/9H28O5Ol90fu5i2q6Zdf
	rpqx/BNbkQ2T5eFJc19/mxuz/bO6EktxRqKhFnNRcSIAkZkdfukCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd2U6c5BBndecFhMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LA6sHjtn3WX32LSqk82jb8sqRo/jN7YzeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHF32z3mgincFXMap7A0MC7n7GLk5JAQMJGY
	966TGcIWk7hwbz1bFyMXh5DAdEaJPwdXMIIkhAR+MUpc7QwHsdkE1CS+fDnM3sXIwSEioCrx
	/5U7SD2zQDdQybLP7BD1thKnfl9kA7E5BewkTl/byApiCwt4S7z5858JxGYB6j2zrxtsDi9Q
	/fcliSBhXgFBiR+T77GA2MwCWhLrdx5ngrDlJTavecsMUi4hoC7x6K8uSFhEwEhi68YfzBAl
	IhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYKT
	wDOpHYwrGywOMQpwMCrx8F5gdg4SYk0sK67MPcQowcGsJML7zQgoxJuSWFmVWpQfX1Sak1p8
	iDEZ6M+JzFKiyfnABJVXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1M
	HJxSDYxzNYW0BUtn1rcXy4klJxXOSxf980RB8nLk2aSdM/Y84EnsErm77JjgLeE652NPPv1f
	pjs98LfdU/mGQ1cCdq0L+RF338I1rn3hoWL1zZ+3ylhddFKYefrmxavX/k7Y8Two5CL7j6/q
	nZ/5rk0NPMvxm+OKmWFi1aZdX98/3Px9+hf2o/Lsh435lFiKMxINtZiLihMBHDDfs0YDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/max8925-regulator.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index d80b5fa..7595107 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -312,7 +312,7 @@ static int max8925_regulator_probe(struct platform_device *pdev)
 		if (pdata)
 			config.init_data = pdata;
 
-	rdev = regulator_register(&ri->desc, &config);
+	rdev = devm_regulator_register(&pdev->dev, &ri->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 				ri->desc.name);
@@ -323,22 +323,12 @@ static int max8925_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int max8925_regulator_remove(struct platform_device *pdev)
-{
-	struct regulator_dev *rdev = platform_get_drvdata(pdev);
-
-	regulator_unregister(rdev);
-
-	return 0;
-}
-
 static struct platform_driver max8925_regulator_driver = {
 	.driver		= {
 		.name	= "max8925-regulator",
 		.owner	= THIS_MODULE,
 	},
 	.probe		= max8925_regulator_probe,
-	.remove		= max8925_regulator_remove,
 };
 
 static int __init max8925_regulator_init(void)
-- 
1.7.10.4


