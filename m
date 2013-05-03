Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762665Ab3ECG2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:28:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59621 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762217Ab3ECG2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:28:49 -0400
X-AuditID: cbfee691-b7fe56d000004b96-b2-5183591671cd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 11/42] rtc: rtc-coh901331: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:28:38 +0900
Message-id: <001901ce47c7$7285d300$57917900$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hx2ZuxiTJofbLQBWXTbRpHOCU3Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zA12xyOZAgzmduhZLLl5lt5izfg2b
	xeWFl1gtpvxZzmRxedccNov9nR2MDmweeyaeZPO4c20Pm8eJGb9ZPPq2rGL0mD7vJ5PH501y
	AWxRXDYpqTmZZalF+nYJXBmnvy5lLzjPUbHwyxeWBsZu9i5GTg4JAROJxn07mCFsMYkL99az
	gdhCAssYJT5t4oGp+XB7IVCcCyg+nVFiwcSvUM4vRok3J96BdbAJqEl8+XIYaCoHh4iAvkRb
	iwZIDbPAdkaJa08/MIHUCAuESWyZ1csIYrMIqErsndrIAlLPK2ApsaaFAyTMKyAo8WPyPRYQ
	m1lAS2L9zuNMELa8xOY1b6EOVZDYcfY12BgRAT2J/+3vmSFqRCT2vXjHCLJXQuASu8Taxn6o
	XQIS3yYfAtslISArsekA1BxJiYMrbrBMYBSbhWT1LCSrZyFZPQvJigWMLKsYRVMLkguKk9KL
	TPWKE3OLS/PS9ZLzczcxQqJx4g7G+wesDzEmA62fyCwlmpwPjOa8knhDYzMjC1MTU2Mjc0sz
	0oSVxHnVW6wDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBe0r/FprrI+GrYeh8Oc0Ozz90R
	W5gyfWdZmhc52tfd5JvxK8hv2361pjlv1iom3mhOXLVGn3VV0blJK0qtfrBZ7nrxvmHq6wUF
	7/psOL2i5S+bFew+7TLr2R7Z3QuCLyxi27g5+MsfpoNZ5b+vPd05n5H5f/I83i6rFF43x0Q9
	xkkVR79v4NiqxFKckWioxVxUnAgA9RdfF9wCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQV2xyOZAg4blmhZLLl5lt5izfg2b
	xeWFl1gtpvxZzmRxedccNov9nR2MDmweeyaeZPO4c20Pm8eJGb9ZPPq2rGL0mD7vJ5PH501y
	AWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3
	KCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzTn9dyl5wnqNi4ZcvLA2M
	3exdjJwcEgImEh9uL2SDsMUkLtxbD2RzcQgJTGeUWDDxK5Tzi1HizYl3YFVsAmoSX74cBurm
	4BAR0Jdoa9EAqWEW2M4oce3pByaQGmGBMIkts3oZQWwWAVWJvVMbWUDqeQUsJda0cICEeQUE
	JX5MvscCYjMLaEms33mcCcKWl9i85i0zxEEKEjvOvgYbIyKgJ/G//T0zRI2IxL4X7xgnMArM
	QjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Gh/Jr2DcVWDxSFG
	AQ5GJR5ehZamQCHWxLLiytxDjBIczEoivG4/gEK8KYmVValF+fFFpTmpxYcYk4EencgsJZqc
	D0xEeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAGHr82YV5
	zSGx1dpG7KZXAvpWunT9dfPZecuL4blsZkhM9ZTL7OIn885pRMfLnzTPvjvLsc7yyPvkgF5J
	1Sf7xBT2xBvsehHm+rOdKYxptbKPTN9nubmSUaZ1W8RizxV/OfnG6sKbGVvED4ftn8cppZ2y
	SPVTaXLrZZumhvBnIs5b1ndujPylxFKckWioxVxUnAgABcIJrzoDAAA=
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
 drivers/rtc/rtc-coh901331.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-coh901331.c b/drivers/rtc/rtc-coh901331.c
index 93c0658..9ad5891 100644
--- a/drivers/rtc/rtc-coh901331.c
+++ b/drivers/rtc/rtc-coh901331.c
@@ -154,10 +154,8 @@ static int __exit coh901331_remove(struct platform_device *pdev)
 {
 	struct coh901331_port *rtap = dev_get_drvdata(&pdev->dev);
 
-	if (rtap) {
+	if (rtap)
 		clk_unprepare(rtap->clk);
-		platform_set_drvdata(pdev, NULL);
-	}
 
 	return 0;
 }
@@ -220,7 +218,6 @@ static int __init coh901331_probe(struct platform_device *pdev)
 	return 0;
 
  out_no_rtc:
-	platform_set_drvdata(pdev, NULL);
 	clk_unprepare(rtap->clk);
 	return ret;
 }
-- 
1.7.2.5


