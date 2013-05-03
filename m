Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852Ab3ECG0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:26:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62564 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213Ab3ECG0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:26:17 -0400
X-AuditID: cbfee68d-b7f016d000007930-af-518358881c9a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 07/42] rtc: rtc-at91sam9: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:26:16 +0900
Message-id: <001501ce47c7$1da946a0$58fbd3e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HxxloBCSEklZxTx29pWZufFYx2w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zI92OiOZAg6ZJghZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBlzPxYXDBfqOJi7yyWBsa7fF2MnBwSAiYSK/+/Y4awxSQu3FvPBmILCSxjlNg7sxym
	ZtKDHUA1XEDx6YwS1y9MZ4dwfjFK/F//BqyDTUBN4suXw0AJDg4RAX2JthYNkBpmgW5GiUfN
	c8E2CAuESpy7cp0JxGYRUJW4sOkaK4jNK2ApceDoL2YIW1Dix+R7LCA2s4CWxPqdx5kgbHmJ
	zWveQl2qILHj7GtGiF16En/v80KUiEjse/GOEWSvhMAhdom1rYtZIHYJSHybfIgFpF5CQFZi
	0wGoMZISB1fcYJnAKDYLyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpRcZ6hUn5haX5qXrJefn
	bmKExF3vDsbbB6wPMSYDrZ/ILCWanA+M27ySeENjMyMLUxNTYyNzSzPShJXEedVarAOFBNIT
	S1KzU1MLUovii0pzUosPMTJxcEo1MM4LkGqKseMzSfh7/qbbY5ZZ5jYXrm25I9NpJ6TUZKub
	vyftn7/5imXbwncw/2QR7P7PUdhrofWB9e4V72VrJ0986HKfcc6Ej31s/9p7dMumyu//rXqA
	M6Ds2RqnOy9kfSqi/DNjFvW2dOeYGH7cmMe0ek9YqAVjUx07U4BIXW24z8kSTj5jJZbijERD
	Leai4kQAhFEfsdECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd2OiOZAg3/TeS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzJj5sbhgvlDFxd5ZLA2Md/m6GDk5JARMJCY9
	2MEMYYtJXLi3nq2LkYtDSGA6o8T1C9PZIZxfjBL/179hA6liE1CT+PLlMFCCg0NEQF+irUUD
	pIZZoJtR4lHzXLBJwgKhEueuXGcCsVkEVCUubLrGCmLzClhKHDj6ixnCFpT4MfkeC4jNLKAl
	sX7ncSYIW15i85q3UBcpSOw4+5oRYpeexN/7vBAlIhL7XrxjnMAoMAvJpFlIJs1CMmkWkpYF
	jCyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYLj+pnUDsaVDRaHGAU4GJV4eBVamgKFWBPL
	iitzDzFKcDArifC6/QAK8aYkVlalFuXHF5XmpBYfYkwGenQis5Rocj4w5eSVxBsam5gZWRqZ
	WRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6NXmsiG2xsyK1gtb5c7PVwnN4k5
	/smq+tPfnz6Y0/5DInKLXuItvyX3fnjGTMzn1o//OEl4C5PiC8erT+v5JynO2LHp/4Q99u3f
	5r62/3Wx88QDXs63pybOPvjv48s/hX+eX3h23nApi3zkjaxvmcala/fGVQkFX770XM958kFB
	8TmbPE54V+QwKbEUZyQaajEXFScCAGzGE7QvAwAA
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
 drivers/rtc/rtc-at91sam9.c |   19 +++++--------------
 1 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index b60a34c..309b8b3 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -324,16 +324,14 @@ static int at91_rtc_probe(struct platform_device *pdev)
 	rtc->rtt = devm_ioremap(&pdev->dev, r->start, resource_size(r));
 	if (!rtc->rtt) {
 		dev_err(&pdev->dev, "failed to map registers, aborting.\n");
-		ret = -ENOMEM;
-		goto fail;
+		return -ENOMEM;
 	}
 
 	rtc->gpbr = devm_ioremap(&pdev->dev, r_gpbr->start,
 				resource_size(r_gpbr));
 	if (!rtc->gpbr) {
 		dev_err(&pdev->dev, "failed to map gpbr registers, aborting.\n");
-		ret = -ENOMEM;
-		goto fail;
+		return -ENOMEM;
 	}
 
 	mr = rtt_readl(rtc, MR);
@@ -350,17 +348,15 @@ static int at91_rtc_probe(struct platform_device *pdev)
 
 	rtc->rtcdev = devm_rtc_device_register(&pdev->dev, pdev->name,
 					&at91_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc->rtcdev)) {
-		ret = PTR_ERR(rtc->rtcdev);
-		goto fail;
-	}
+	if (IS_ERR(rtc->rtcdev))
+		return PTR_ERR(rtc->rtcdev);
 
 	/* register irq handler after we know what name we'll use */
 	ret = devm_request_irq(&pdev->dev, rtc->irq, at91_rtc_interrupt,
 				IRQF_SHARED, dev_name(&rtc->rtcdev->dev), rtc);
 	if (ret) {
 		dev_dbg(&pdev->dev, "can't share IRQ %d?\n", rtc->irq);
-		goto fail;
+		return ret;
 	}
 
 	/* NOTE:  sam9260 rev A silicon has a ROM bug which resets the
@@ -374,10 +370,6 @@ static int at91_rtc_probe(struct platform_device *pdev)
 				dev_name(&rtc->rtcdev->dev));
 
 	return 0;
-
-fail:
-	platform_set_drvdata(pdev, NULL);
-	return ret;
 }
 
 /*
@@ -391,7 +383,6 @@ static int at91_rtc_remove(struct platform_device *pdev)
 	/* disable all interrupts */
 	rtt_writel(rtc, MR, mr & ~(AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN));
 
-	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
 
-- 
1.7.2.5


