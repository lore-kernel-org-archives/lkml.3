Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab3I3Awl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:52:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:17226 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3I3Awj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:52:39 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-21-5248cb550603
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Bengt Jonsson'" <bengt.g.jonsson@stericsson.com>
References: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
In-reply-to: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
Subject: [PATCH V4 02/14] regulator: ab8500-ext: use devm_regulator_register()
Date: Mon, 30 Sep 2013 09:52:37 +0900
Message-id: <007501cebd77$5b4e2950$11ea7bf0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac69dwY7qCw/SuPGSmKRawAumfnevwAACneA
Content-language: ko
x-cr-hashedpuzzle: A5+6 DoDr ERtv FXOS G7nw LDxA L0DJ TXFU Vv9Q fJaD kAEp oLJA
 rkrl 11MA 146x
 48e+;5;YgBlAG4AZwB0AC4AZwAuAGoAbwBuAHMAcwBvAG4AQABzAHQAZQByAGkAYwBzAHMAbwBuAC4AYwBvAG0AOwBiAHIAbwBvAG4AaQBlAEAAawBlAHIAbgBlAGwALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGcAaQByAGQAdwBvAG8AZABAAGcAbQBhAGkAbAAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{D47F1BDF-EB2E-4429-94B0-EEE7F3388131};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Mon,
 30 Sep 2013 00:52:28
 GMT;WwBQAEEAVABDAEgAIABWADQAIAAwADIALwAxADQAXQAgAHIAZQBnAHUAbABhAHQAbwByADoAIABhAGIAOAA1ADAAMAAtAGUAeAB0ADoAIAB1AHMAZQAgAGQAZQB2AG0AXwByAGUAZwB1AGwAYQB0AG8AcgBfAHIAZQBnAGkAcwB0AGUAcgAoACkA
x-cr-puzzleid: {D47F1BDF-EB2E-4429-94B0-EEE7F3388131}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zfd3Q0x5BBnOPaFmsf3CMyWLqwyds
	FpcXXmK1+Halg8ni8q45bA6sHjtn3WX32LSqk82jb8sqRo/vS9ewe3zeJBfAGsVlk5Kak1mW
	WqRvl8CVcXjhBpaCW3wV1758Y2xg/MXdxcjJISFgInFw0QRGCFtM4sK99WxdjFwcQgLLGCUe
	bZvA1MXIAVa0tzUeIr6IUeJj9wtGCOcXo8S7wztYQLrZBNQkvnw5zA7SICKgKvH/lTtIDbPA
	QkaJKUseMIPUCAnYSsw5fxZsG6eAncSdDa2MIPXCAn4Sf1oCQMIsQK3d80+xgti8QOUnN62F
	sgUlfky+B7aKWUBLYv3O40wQtrzE5jVvmSHuVJd49FcXJCwiYCSx9vdcZogSEYl9L95B/fiC
	VWJpQzyEbSox/9pSdpAzJQR+skt8+raaGeIGAYlvkw+xQMyUldh0gBmiXlLi4IobLBMYpWYh
	uWgWkotmIbloFpLVCxhZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmKExPWEHYz3DlgfYkwG
	Wj+RWUo0OR+YFvJK4g2NzYwsTE1MjY3MLc1IE1YS51VvsQ4UEkhPLEnNTk0tSC2KLyrNSS0+
	xMjEwSnVwJh014/hbI1icdy62fwCkyT38ws4BEtP917kdlJJfvaVH8+FFMzZvuqnZD677/B4
	dlJiaLOk+Rsj4RVN5un5/q/37bDPe2PAYbTl+tmH5n8+tIeYKfdIlx9pm/V8+enekr3F8wO3
	qTIz/9CzOf8zx3xuapjWQrFlNw8U/8tl0xKU5SxYIrRjsxJLcUaioRZzUXEiAAu/bGoBAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jAd3Q0x5BBtMWqlmsf3CMyWLqwyds
	FpcXXmK1+Halg8ni8q45bA6sHjtn3WX32LSqk82jb8sqRo/vS9ewe3zeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHF44QaWglt8Fde+fGNsYPzF3cXIwSEhYCKx
	tzW+i5ETyBSTuHBvPVsXIxeHkMAiRomP3S8YIZxfjBLvDu9gAaliE1CT+PLlMDtIs4iAqsT/
	V+4gNcwCCxklpix5wAxSIyRgKzHn/FlGEJtTwE7izoZWRpB6YQE/iT8tASBhFqDW7vmnWEFs
	XqDyk5vWQtmCEj8m3wNbxSygJbF+53EmCFteYvOat8wQN6tLPPqrCxIWETCSWPt7LjNEiYjE
	vhfvGCF+ecEqsbQB6i9TifnXlrJPYBSZhWTDLCQbZiHZMAvJqAWMLKsYRVMLkguKk9JzDfWK
	E3OLS/PS9ZLzczcxgpPGM6kdjCsbLA4xCnAwKvHwTljuESTEmlhWXJl7iFGCg1lJhHd5ElCI
	NyWxsiq1KD++qDQntfgQYzIwACYyS4km5wMTWl5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOF
	BNITS1KzU1MLUotgtjBxcEo1MKapFu4PyeYK/pmws5krrzVnI4tfL/vT/ZmZy9xfdSxfwXtJ
	5VDQ4WmTV9otNbvoe3Ue89HKyy3/Jh+9yinRcUlAbotxVtFijrhpu99JhPg01i5blqXRxNm+
	SWbGLQvVFzUukTtb5gcuXr3kXdLGL4JFC9SClnz/b7jE5Wvknef+a6LEbZ2iLiqxFGckGmox
	FxUnAgA6DMOzXgMAAA==
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
 drivers/regulator/ab8500-ext.c |   26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index 02ff691..29c0faa 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -413,16 +413,12 @@ static int ab8500_ext_regulator_probe(struct platform_device *pdev)
 			&pdata->ext_regulator[i];
 
 		/* register regulator with framework */
-		info->rdev = regulator_register(&info->desc, &config);
+		info->rdev = devm_regulator_register(&pdev->dev, &info->desc,
+						     &config);
 		if (IS_ERR(info->rdev)) {
 			err = PTR_ERR(info->rdev);
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
 					info->desc.name);
-			/* when we fail, un-register all earlier regulators */
-			while (--i >= 0) {
-				info = &ab8500_ext_regulator_info[i];
-				regulator_unregister(info->rdev);
-			}
 			return err;
 		}
 
@@ -433,26 +429,8 @@ static int ab8500_ext_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int ab8500_ext_regulator_remove(struct platform_device *pdev)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(ab8500_ext_regulator_info); i++) {
-		struct ab8500_ext_regulator_info *info = NULL;
-		info = &ab8500_ext_regulator_info[i];
-
-		dev_vdbg(rdev_get_dev(info->rdev),
-			"%s-remove\n", info->desc.name);
-
-		regulator_unregister(info->rdev);
-	}
-
-	return 0;
-}
-
 static struct platform_driver ab8500_ext_regulator_driver = {
 	.probe = ab8500_ext_regulator_probe,
-	.remove = ab8500_ext_regulator_remove,
 	.driver         = {
 		.name   = "ab8500-ext-regulator",
 		.owner  = THIS_MODULE,
-- 
1.7.10.4


