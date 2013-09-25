Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab3IYHxA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 03:53:00 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23713 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3IYHw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:52:59 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-07-5242965a2352
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Bengt Jonsson'" <bengt.g.jonsson@stericsson.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 03/20] regulator: ab8500-ext: use devm_regulator_register()
Date: Wed, 25 Sep 2013 16:52:57 +0900
Message-id: <000c01ceb9c4$40152820$c03f7860$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAAIaTQ
Content-language: ko
x-cr-hashedpuzzle: QReU T84C UTJh WEYF Xeqm X3Te ZRGC bZK+ elxl gyoo iT1y mJr+
 mU9J m93m zPEV
 0IOh;5;YgBlAG4AZwB0AC4AZwAuAGoAbwBuAHMAcwBvAG4AQABzAHQAZQByAGkAYwBzAHMAbwBuAC4AYwBvAG0AOwBiAHIAbwBvAG4AaQBlAEAAawBlAHIAbgBlAGwALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGcAaQByAGQAdwBvAG8AZABAAGcAbQBhAGkAbAAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{F549E6D3-E627-4BA9-91A4-A03942D03333};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Wed,
 25 Sep 2013 07:52:50
 GMT;WwBQAEEAVABDAEgAIAAwADMALwAyADAAXQAgAHIAZQBnAHUAbABhAHQAbwByADoAIABhAGIAOAA1ADAAMAAtAGUAeAB0ADoAIAB1AHMAZQAgAGQAZQB2AG0AXwByAGUAZwB1AGwAYQB0AG8AcgBfAHIAZQBnAGkAcwB0AGUAcgAoACkA
x-cr-puzzleid: {F549E6D3-E627-4BA9-91A4-A03942D03333}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zQ92oaU5BBudb2C3WPzjGZDH14RM2
	i8sLL7FafLvSwWRxedccNgdWj52z7rJ7bFrVyebRt2UVo8f3pWvYPT5vkgtgjeKySUnNySxL
	LdK3S+DKOLxwA0vBLb6Ka1++MTYw/uLuYuTgkBAwkfj6xLmLkRPIFJO4cG89G4gtJLCMUWL6
	wRKIuInEhz8rWCHi0xklek77dDFyAdm/GCWaDx1iBkmwCahJfPlymB1kpoiAqsT/V+4gNcwC
	Cxklpix5wAzRbCux/O9tFhCbU8BOYtm9z2DLhAW8Jc5efQ4WZwHqPXN7KVicF6h+yaR3ULag
	xI/J98BqmAW0JNbvPM4EYctLbF7zlhniF3WJR391QcIiAkYSn3ovMUKUiEjse/GOEeQeCYEH
	rBKnbjSyQDxmKnHi+QqoxE92ib9bp7JCHCEg8W3yIRaIobISmw4wQ9RLShxccYNlAqPULCQn
	zUJy0iwkJ81CsnsBI8sqRtHUguSC4qT0IkO94sTc4tK8dL3k/NxNjJC47t3BePuA9SHGZKD1
	E5mlRJPzgWkhryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOM
	TBycUg2M9l/+L0libgq3L5ymdi1Vy72bV2wPk8q8m7ujN4oETD3lMWnDm8PxGxNc9Z8lLbYz
	djraXVRiE1S5K2+v+zd7OQ+LKJt+trkioQZmhQe23BG9wMmQfF7t6OH66oSHC5/OuLZ15fYK
	v2OuBjHBGzqlar4UR367x2Fou5vlnId9r4lOy5r13IZKLMUZiYZazEXFiQB5nsMuAQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLKsWRmVeSWpSXmKPExsVy+t9jQd2oaU5BBj9amS3WPzjGZDH14RM2
	i8sLL7FafLvSwWRxedccNgdWj52z7rJ7bFrVyebRt2UVo8f3pWvYPT5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzDi8cANLwS2+imtfvjE2MP7i7mLk5JAQMJH4
	8GcFK4QtJnHh3no2EFtIYDqjRM9pny5GLiD7F6NE86FDzCAJNgE1iS9fDrN3MXJwiAioSvx/
	5Q5SwyywkFFiypIHzBDNthLL/95mAbE5Bewklt37DDZUWMBb4uzV52BxFqDeM7eXgsV5geqX
	THoHZQtK/Jh8D6yGWUBLYv3O40wQtrzE5jVvmUH2SgioSzz6qwsSFhEwkvjUe4kRokREYt+L
	d4wg90gIPGCVOHWjkQXiMVOJE89XME5gFJmFZMUsJCtmIVkxC8msBYwsqxhFUwuSC4qT0nON
	9IoTc4tL89L1kvNzNzGCE8cz6R2MqxosDjEKcDAq8fAKHHUMEmJNLCuuzD3EKMHBrCTCWzTV
	KUiINyWxsiq1KD++qDQntfgQYzIwBCYyS4km5wOTWl5JvKGxiZmRpZGZhZGJuTlpwkrivAdb
	rQOFBNITS1KzU1MLUotgtjBxcEo1MFazeCnvKq7daXTEZX6IcLV3UtYK00XFQRxT/WdMXfDJ
	u1t2iSnPswMWId7nmRrFrHJXiU92eJxrpyFyMfZN36NEjn8l9Xpx97drzNooc+juM4WEqq+N
	pl71cg2TZ80qfdp5J3R98dQXemr/TdM+b1sUe29RR8eUNZ9ert3imf3CaWtdf5g+hxJLcUai
	oRZzUXEiAAJDT+ZgAwAA
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


