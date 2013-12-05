Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933087Ab3LEBFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 20:05:42 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54887 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756266Ab3LEBFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 20:05:39 -0500
X-AuditID: cbfee690-b7f676d00000310d-aa-529fd16132a2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Yoichi Yuasa'" <yuasa@linux-mips.org>
References: <000001cef155$be1674e0$3a435ea0$%han@samsung.com>
In-reply-to: <000001cef155$be1674e0$3a435ea0$%han@samsung.com>
Subject: [PATCH 2/2] rtc: rtc-vr41xx: Use devm_*() functions
Date: Thu, 05 Dec 2013 10:05:37 +0900
Message-id: <000101cef156$1ba62d80$52f28880$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7xVbT2xOcYR3GdRSO1O8jmIZkciAAACKKg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zY93Ei/ODDBasUrFYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djBZvrz1id2Dz2DPxJJvHiRm/WTyOrlzL5NG3ZRWjx/R5P5k8Pm+S
	C2CL4rJJSc3JLEst0rdL4MpoaNnEXvBMomJv52+WBsZfwl2MnBwSAiYS19pmsEPYYhIX7q1n
	62Lk4hASWMYoMf/pNVaYom/nPkAlpjNKvJ78Bsr5xSjRvaaXDaSKTUBN4suXw0CjODhEBPQl
	2lo0QGqYBbYxSsz4+hxskpCArcTXozsZQWxOATuJr7OnsYDYwgI2EjsffgerYRFQlTi/9ykz
	iM0LVL/ndBOULSjxY/I9sHpmAS2J9TuPM0HY8hKb17xlBtkrIaAu8eivLkhYRMBIYvvGI6wQ
	JSIS+168YwS5R0LgI7vEyo7dULsEJL5NPsQC0SsrsekAM8TDkhIHV9xgmcAoMQvJ5llINs9C
	snkWkhULGFlWMYqmFiQXFCelF5noFSfmFpfmpesl5+duYoTE74QdjPcOWB9iTAZaP5FZSjQ5
	Hxj/eSXxhsZmRhamJqbGRuaWZqQJK4nzqj1KChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXA
	WKBlv262rLtEkGVl9Z9HrxPz1BMk37slnV6R+//3qxeybySnPtbiiVSuWP/h6SlOzq1LNQ4/
	n/XvTFnV8sznbiEnrrxar3o9aIr6vc9yBxyMbyqYlrQebj/39eWltVb/VdiyTFv3aO3bNrfM
	Te5eI9uMyluBq8zWpphPKLZtqXN8eWaf8Xu+L0osxRmJhlrMRcWJAIRCxmX1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jQd3Ei/ODDOa+k7dYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djBZvrz1id2Dz2DPxJJvHiRm/WTyOrlzL5NG3ZRWjx/R5P5k8Pm+S
	C2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6
	Q0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY0dCyib3gmUTF3s7fLA2M
	v4S7GDk5JARMJL6d+8AGYYtJXLi3Hsjm4hASmM4o8XryGyjnF6NE95pesCo2ATWJL18Os3cx
	cnCICOhLtLVogNQwC2xjlJjx9TkrSI2QgK3E16M7GUFsTgE7ia+zp7GA2MICNhI7H34Hq2ER
	UJU4v/cpM4jNC1S/53QTlC0o8WPyPbB6ZgEtifU7jzNB2PISm9e8ZQbZKyGgLvHory5IWETA
	SGL7xiOsECUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS
	9ZLzczcxgpPDM6kdjCsbLA4xCnAwKvHwvkicHyTEmlhWXJl7iFGCg1lJhPdfDVCINyWxsiq1
	KD++qDQntfgQYzLQoxOZpUST84GJK68k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZ
	qakFqUUwW5g4OKUaGG2nxH/gfPd/l83da5+2HH39RFH3g0CX0HbLefK9Tx80SK6t0fH8vnjz
	dx0/d4tJz+RTl+RcX1++6nlqguwk9rz37XK/PXq/md63PxSnVPTp5sZrS04dXj69wksv5431
	oVUPlmUU99XM9Wh6yizz/ska44zPRmVz3Z4+5k1W9sqee9z1b49csbsSS3FGoqEWc1FxIgB1
	xs4/UgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler, and remove
unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-vr41xx.c |   50 +++++++++++-----------------------------------
 1 file changed, 12 insertions(+), 38 deletions(-)

diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index aabc22c..88c9c92 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -293,7 +293,7 @@ static int rtc_probe(struct platform_device *pdev)
 	if (!res)
 		return -EBUSY;
 
-	rtc1_base = ioremap(res->start, resource_size(res));
+	rtc1_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (!rtc1_base)
 		return -EBUSY;
 
@@ -303,13 +303,14 @@ static int rtc_probe(struct platform_device *pdev)
 		goto err_rtc1_iounmap;
 	}
 
-	rtc2_base = ioremap(res->start, resource_size(res));
+	rtc2_base = devm_ioremap(&pdev->dev, res->start, resource_size(res));
 	if (!rtc2_base) {
 		retval = -EBUSY;
 		goto err_rtc1_iounmap;
 	}
 
-	rtc = rtc_device_register(rtc_name, &pdev->dev, &vr41xx_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&pdev->dev, rtc_name, &vr41xx_rtc_ops,
+					THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		retval = PTR_ERR(rtc);
 		goto err_iounmap_all;
@@ -330,24 +331,24 @@ static int rtc_probe(struct platform_device *pdev)
 	aie_irq = platform_get_irq(pdev, 0);
 	if (aie_irq <= 0) {
 		retval = -EBUSY;
-		goto err_device_unregister;
+		goto err_iounmap_all;
 	}
 
-	retval = request_irq(aie_irq, elapsedtime_interrupt, 0,
-			     "elapsed_time", pdev);
+	retval = devm_request_irq(&pdev->dev, aie_irq, elapsedtime_interrupt, 0,
+				"elapsed_time", pdev);
 	if (retval < 0)
-		goto err_device_unregister;
+		goto err_iounmap_all;
 
 	pie_irq = platform_get_irq(pdev, 1);
 	if (pie_irq <= 0) {
 		retval = -EBUSY;
-		goto err_free_irq;
+		goto err_iounmap_all;
 	}
 
-	retval = request_irq(pie_irq, rtclong1_interrupt, 0,
-			     "rtclong1", pdev);
+	retval = devm_request_irq(&pdev->dev, pie_irq, rtclong1_interrupt, 0,
+				"rtclong1", pdev);
 	if (retval < 0)
-		goto err_free_irq;
+		goto err_iounmap_all;
 
 	platform_set_drvdata(pdev, rtc);
 
@@ -358,47 +359,20 @@ static int rtc_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_free_irq:
-	free_irq(aie_irq, pdev);
-
-err_device_unregister:
-	rtc_device_unregister(rtc);
-
 err_iounmap_all:
-	iounmap(rtc2_base);
 	rtc2_base = NULL;
 
 err_rtc1_iounmap:
-	iounmap(rtc1_base);
 	rtc1_base = NULL;
 
 	return retval;
 }
 
-static int rtc_remove(struct platform_device *pdev)
-{
-	struct rtc_device *rtc;
-
-	rtc = platform_get_drvdata(pdev);
-	if (rtc)
-		rtc_device_unregister(rtc);
-
-	free_irq(aie_irq, pdev);
-	free_irq(pie_irq, pdev);
-	if (rtc1_base)
-		iounmap(rtc1_base);
-	if (rtc2_base)
-		iounmap(rtc2_base);
-
-	return 0;
-}
-
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:RTC");
 
 static struct platform_driver rtc_platform_driver = {
 	.probe		= rtc_probe,
-	.remove		= rtc_remove,
 	.driver		= {
 		.name	= rtc_name,
 		.owner	= THIS_MODULE,
-- 
1.7.10.4


