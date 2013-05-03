Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762716Ab3ECG3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:29:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60375 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762633Ab3ECG3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:29:42 -0400
X-AuditID: cbfee68f-b7f066d000003683-02-518359558537
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 14/42] rtc: rtc-davinci: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:29:41 +0900
Message-id: <001c01ce47c7$982a8330$c87f8990$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hx5cxlgY7GJgfRISVGAEFHu5qEA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zY93QyOZAgxV7DS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK6F9ymLlgF19F752j7A2Mr7i7GDk5JARMJL7P+ckGYYtJXLi3HswWEljGKLHqrAxM
	zaETTYxdjFxA8UWMEmsmP2eBcH4xSuz9vYIVpIpNQE3iy5fD7F2MHBwiAvoSbS0aIDXMAt2M
	Eo+a5zKD1AgLhEjc2LmSDaSGRUBVYl0/B0iYV8BSYvXctawQtqDEj8n3WEBsZgEtifU7jzNB
	2PISm9e8ZYY4SEFix9nXjCC2iICeRPvE74wQNSIS+168AztUQuAUu8TRSzfAGlgEBCS+TT7E
	ArJXQkBWYtMBqDmSEgdX3GCZwCg2C8nqWUhWz0KyehaSFQsYWVYxiqYWJBcUJ6UXGesVJ+YW
	l+al6yXn525ihERe/w7GuwesDzEmA62fyCwlmpwPjNy8knhDYzMjC1MTU2Mjc0sz0oSVxHnV
	WqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDG55vqdF4ufriw/F05b93RFRnqO6vT5xvc
	Srwk3bJfQuPQmcyqjcf3lfQtYPdQLejYcsu8uqEvTsHN1Zx15YrTDbc+eX3m6LcsjOMt0W/b
	e9lvH6vapXTTPKa0i/fFVjkXMXpJyLJ8ZBOxddpuaaftpnd+++HvW3exCZRu3xCRNztO0itP
	QImlOCPRUIu5qDgRAEIF/2nSAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd3QyOZAg6l3dC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzOhfcpi5YBdfRe+do+wNjK+4uxg5OSQETCQO
	nWhihLDFJC7cW8/WxcjFISSwiFFizeTnLBDOL0aJvb9XsIJUsQmoSXz5cpi9i5GDQ0RAX6Kt
	RQOkhlmgm1HiUfNcZpAaYYEQiRs7V7KB1LAIqEqs6+cACfMKWEqsnruWFcIWlPgx+R4LiM0s
	oCWxfudxJghbXmLzmrfMEAcpSOw4+xrsOBEBPYn2id8ZIWpEJPa9eMc4gVFgFpJRs5CMmoVk
	1CwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBEf2M+kdjKsaLA4xCnAwKvHwKrQ0
	BQqxJpYVV+YeYpTgYFYS4XX7ARTiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHkfGDSySuJNzQ2
	MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxglBTKtuWjgo/XtUbh45
	4UuH64Fo1rtzvk7zj7WWyyz2j7DQSbHZc9l4D7N15YfjeueEF2uvfTffX/dKcalIx3fj4xr3
	C8xvSJed+b3kceVyme2v9AS6v1ids/+6e/3qH5N3zz29n787tfPPhMsFkxqN6teY1O5/yVIq
	1770xu+OsC8LGR2O1CqxFGckGmoxFxUnAgATLFX1MAMAAA==
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
 drivers/rtc/rtc-davinci.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index a55048c..ca62118 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -526,10 +526,9 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 	davinci_rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				    &davinci_rtc_ops, THIS_MODULE);
 	if (IS_ERR(davinci_rtc->rtc)) {
-		ret = PTR_ERR(davinci_rtc->rtc);
 		dev_err(dev, "unable to register RTC device, err %d\n",
 				ret);
-		goto fail1;
+		return PTR_ERR(davinci_rtc->rtc);
 	}
 
 	rtcif_write(davinci_rtc, PRTCIF_INTFLG_RTCSS, PRTCIF_INTFLG);
@@ -543,7 +542,7 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 			  0, "davinci_rtc", davinci_rtc);
 	if (ret < 0) {
 		dev_err(dev, "unable to register davinci RTC interrupt\n");
-		goto fail1;
+		return ret;
 	}
 
 	/* Enable interrupts */
@@ -556,10 +555,6 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 	device_init_wakeup(&pdev->dev, 0);
 
 	return 0;
-
-fail1:
-	platform_set_drvdata(pdev, NULL);
-	return ret;
 }
 
 static int __exit davinci_rtc_remove(struct platform_device *pdev)
@@ -570,8 +565,6 @@ static int __exit davinci_rtc_remove(struct platform_device *pdev)
 
 	rtcif_write(davinci_rtc, 0, PRTCIF_INTEN);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


