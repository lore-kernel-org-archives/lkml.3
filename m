Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3IZHuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:50:54 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27725 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3IZHuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:50:52 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-f4-5243e75b9ea1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Milo Kim'" <milo.kim@ti.com>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
In-reply-to: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
Subject: From 782c15faac0a93cdac43b212073081707f669272 Mon Sep 17 00:00:00 2001
Date: Thu, 26 Sep 2013 16:50:51 +0900
Message-id: <003701ceba8d$1f1c5a70$5d550f50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66jIjCzH3ID+v5Qym5l1DxbvczrwAAIHIg
Content-language: ko
x-cr-hashedpuzzle: Aq6I OpSD RY5a R0j3 VFYY YyDD cmQE dNGP mQQ9 rhzt v8pR zDl0
 09TQ 18vu 2KdD
 4MmU;5;YgByAG8AbwBuAGkAZQBAAGsAZQByAG4AZQBsAC4AbwByAGcAOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABnAGkAcgBkAHcAbwBvAGQAQABnAG0AYQBpAGwALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAGkAbABvAC4AawBpAG0AQAB0AGkALgBjAG8AbQA=;Sosha1_v1;7;{59B05508-F324-408E-AD03-A88FCBAD5A2F};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 26 Sep 2013 07:50:42
 GMT;RgByAG8AbQAgADcAOAAyAGMAMQA1AGYAYQBhAGMAMABhADkAMwBjAGQAYQBjADQAMwBiADIAMQAyADAANwAzADAAOAAxADcAMAA3AGYANgA2ADkAMgA3ADIAIABNAG8AbgAgAFMAZQBwACAAMQA3ACAAMAAwADoAMAAwADoAMAAwACAAMgAwADAAMQA=
x-cr-puzzleid: {59B05508-F324-408E-AD03-A88FCBAD5A2F}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t8zY93o585BBi/3GVtMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LA6sHjtn3WX32LSqk82jb8sqRo/jN7YzeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVsbTfrGCGYMX11kamBsblfF2MnBwSAiYSu7cdYIewxSQu3FvP1sXIxSEksIxRonXf
	PUaYoh1TnrNAJKYzSrT92sMM4fxilFi/ai4LSBWbgJrEly+HgUZxcIgIqEr8f+UOUsMs0M0o
	cXXZZ7AVQgK2Eo3f/oLVcwrYSczaf5IZxBYW8JdY9nUrC0gvC1Dv738VIGFeoPLlHVuZIWxB
	iR+T74G1MgtoSazfeZwJwpaX2LzmLTNIq4SAusSjv7ogYREBI4lV13cwQpSISOx78Y4R5BwJ
	gSOsEtNWPWWFeMxUYtObjcwQib/sEnNuvgRbxiIgIPFt8iEWiKGyEpsOMEPUS0ocXHGDZQKj
	1CwkJ81CctIsJCfNQrJ7ASPLKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYyQyJ6wg/HeAetD
	jMlA6ycyS4km5wMTQ15JvKGxmZGFqYmpsZG5pRlpwkrivOot1oFCAumJJanZqakFqUXxRaU5
	qcWHGJk4OKUaGKezi03IDDsWmXVn5rv5XyZfn/jqUbEM45/L6lGh1xkXi95fH5nYs0ziJ/uR
	4Osnl5n/u7Dv1CLTeWpfbs2zkEr9oFi/4HjkLmehipjHN20nzdi/i3Oi38fgK73JRxnzVJym
	nJnF912lde/vVJN/+bmLPKsPfph2U7t5ScL1qSIdLs+uu6h1GU1WYinOSDTUYi4qTgQAQdb2
	TgIDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jQd3o585BBt+26FtMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LA6sHjtn3WX32LSqk82jb8sqRo/jN7YzeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLG036xghmDF9dZGpgbG5XxdjJwcEgImEjum
	PGeBsMUkLtxbz9bFyMUhJDCdUaLt1x5mCOcXo8T6VXPBqtgE1CS+fDnM3sXIwSEioCrx/5U7
	SA2zQDejxNVln9lBaoQEbCUav/0Fq+cUsJOYtf8kM4gtLOAvsezrVhaQXhag3t//KkDCvEDl
	yzu2MkPYghI/Jt8Da2UW0JJYv/M4E4QtL7F5zVtmkFYJAXWJR391QcIiAkYSq67vYIQoEZHY
	9+IdI8g5EgJHWCWmrXrKCvGYqcSmNxuZJzCKzEKyYhaSFbOQrJiFZNYCRpZVjKKpBckFxUnp
	uYZ6xYm5xaV56XrJ+bmbGMFp45nUDsaVDRaHGAU4GJV4eC8wOwcJsSaWFVfmHmKU4GBWEuH9
	ZgQU4k1JrKxKLcqPLyrNSS0+xJgMDICJzFKiyfnAlJZXEm9obGJmZGlkZmFkYm5OmrCSOO+B
	VutAIYH0xJLU7NTUgtQimC1MHJxSDYwyCrdLFjTYZZf//z5DdU/qZeZz1298CGG8c1Upbu/s
	nDkcbR3Hbm6L5bMJ2er/cdEVO5dp6/6Kvg3pNKziX7Pz2k6mwN0W1/xTjLXq1nv0ycSu253B
	ZHm34L512ekPddofo74Kb3f3NkufK9T0YumLGYxiOhFnAm0LNbxZHdY12/fwmLy5PFWJpTgj
	0VCLuag4EQBYsOwuXwMAAA==
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
 drivers/regulator/lp8788-ldo.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/lp8788-ldo.c b/drivers/regulator/lp8788-ldo.c
index 0527d87..b9a29a2 100644
--- a/drivers/regulator/lp8788-ldo.c
+++ b/drivers/regulator/lp8788-ldo.c
@@ -543,7 +543,7 @@ static int lp8788_dldo_probe(struct platform_device *pdev)
 	cfg.driver_data = ldo;
 	cfg.regmap = lp->regmap;
 
-	rdev = regulator_register(&lp8788_dldo_desc[id], &cfg);
+	rdev = devm_regulator_register(&pdev->dev, &lp8788_dldo_desc[id], &cfg);
 	if (IS_ERR(rdev)) {
 		ret = PTR_ERR(rdev);
 		dev_err(&pdev->dev, "DLDO%d regulator register err = %d\n",
@@ -557,18 +557,8 @@ static int lp8788_dldo_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int lp8788_dldo_remove(struct platform_device *pdev)
-{
-	struct lp8788_ldo *ldo = platform_get_drvdata(pdev);
-
-	regulator_unregister(ldo->regulator);
-
-	return 0;
-}
-
 static struct platform_driver lp8788_dldo_driver = {
 	.probe = lp8788_dldo_probe,
-	.remove = lp8788_dldo_remove,
 	.driver = {
 		.name = LP8788_DEV_DLDO,
 		.owner = THIS_MODULE,
@@ -603,7 +593,7 @@ static int lp8788_aldo_probe(struct platform_device *pdev)
 	cfg.driver_data = ldo;
 	cfg.regmap = lp->regmap;
 
-	rdev = regulator_register(&lp8788_aldo_desc[id], &cfg);
+	rdev = devm_regulator_register(&pdev->dev, &lp8788_aldo_desc[id], &cfg);
 	if (IS_ERR(rdev)) {
 		ret = PTR_ERR(rdev);
 		dev_err(&pdev->dev, "ALDO%d regulator register err = %d\n",
@@ -617,18 +607,8 @@ static int lp8788_aldo_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int lp8788_aldo_remove(struct platform_device *pdev)
-{
-	struct lp8788_ldo *ldo = platform_get_drvdata(pdev);
-
-	regulator_unregister(ldo->regulator);
-
-	return 0;
-}
-
 static struct platform_driver lp8788_aldo_driver = {
 	.probe = lp8788_aldo_probe,
-	.remove = lp8788_aldo_remove,
 	.driver = {
 		.name = LP8788_DEV_ALDO,
 		.owner = THIS_MODULE,
-- 
1.7.10.4


