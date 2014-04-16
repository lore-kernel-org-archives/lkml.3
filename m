Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbaDPK1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:27:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10660 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaDPK1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:27:09 -0400
X-AuditID: cbfee690-b7f266d00000287c-47-534e5afc11bc
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH 6/8] extcon: max8997: Use devm_extcon_dev_register()
Date: Wed, 16 Apr 2014 19:27:01 +0900
Message-id: <1397644023-32516-7-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
References: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWyRsSkSPdPlF+wwcJXphbXvzxntbi8aw6b
	xe3GFWwWC/aUOLB49G1ZxejxeZNcAFMUl01Kak5mWWqRvl0CV8aPIweZCn5xVnzdPIO9gXEv
	RxcjJ4eEgInEglvPWSFsMYkL99azdTFycQgJLGWU2LVjGyNM0YsPDewQiUWMEidfTIRy2pgk
	Vk99ywZSxSagK/HkwGVmEFtEIFii4+RxJhCbWcBTYu7kLrAaYQEXiTOrngPZHBwsAqoSz++k
	gYR5BTwk9l8DuYIDaJmCxJxJNiBhTqDOza++MYOEhYBK7n01A9kqIfCeTeLexwtg01kEBCS+
	TT7EAtEqK7HpADPEyZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRmCQ
	nv73bMIOxnsHrA8xJgONm8gsJZqcDwzyvJJ4Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJpCeW
	pGanphakFsUXleakFh9iZOLglGpglHnO/t+n49LNf0n3b2ye/XGdxxtPBt6In6bFF6Y2N2Zd
	rbla7vCg8bx/GFP1AfUfzB/v/2sO//6YLc/JxvsnU4diB3Ptsx9Z588JLuw40dJa9MGpxb2l
	6ew2K3aNlT5vau5GTDnXf+f1R7Hc7Q+e+0k6S81Sm5cSzlLxXNPt1Y6MdYsN/7reUWIpzkg0
	1GIuKk4EAKw5ejJoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t9jAd0/UX7BBp+O6Vlc//Kc1eLyrjls
	FrcbV7BZLNhT4sDi0bdlFaPH501yAUxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6
	hpYW5koKeYm5qbZKLj4Bum6ZOUCLlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZ
	oIGENYwZP44cZCr4xVnxdfMM9gbGvRxdjJwcEgImEi8+NLBD2GISF+6tZ+ti5OIQEljEKHHy
	xUR2CKeNSWL11LdsIFVsAroSTw5cZgaxRQSCJTpOHmcCsZkFPCXmTu4CqxEWcJE4s+o5kM3B
	wSKgKvH8ThpImFfAQ2L/teesIGEJAQWJOZNsQMKcQJ2bX31jBgkLAZXc+2o2gZF3ASPDKkbR
	1ILkguKk9FwjveLE3OLSvHS95PzcTYzgGHgmvYNxVYPFIUYBDkYlHt6ZOb7BQqyJZcWVuYcY
	JTiYlUR4GyP9goV4UxIrq1KL8uOLSnNSiw8xJgOdNJFZSjQ5HxifeSXxhsYmZkaWRuaGFkbG
	5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAuJzNz+ysxfZ3QqG/1/4t85n8931zvuE/
	yxsaTj9XqysXbuU4fE8j8uy7/Or863scvh2O4b3cW7hvq8O8eZxK882/3n6Xwrk3THKR3zpd
	EVXTzILkr7cfbvPLZ6xTWSVpv6u12jpva1jUqpPMBcsERY+qfmY5VpVz7laQ/DfZgmndEXPj
	o3dsU2Ipzkg01GIuKk4EAH4eir3FAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the resource-managed extcon device register function (i.e.
devm_extcon_dev_register()) instead of extcon_dev_register(). If extcon device
is attached with this function, that extcon device is automatically unregistered
on driver detach. That reduces tiresome managing code.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
---
 drivers/extcon/extcon-max8997.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 223e6b0..804a446 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -709,7 +709,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	info->edev->name = DEV_NAME;
 	info->edev->dev.parent = &pdev->dev;
 	info->edev->supported_cable = max8997_extcon_cable;
-	ret = extcon_dev_register(info->edev);
+	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
 		goto err_irq;
@@ -790,8 +790,6 @@ static int max8997_muic_remove(struct platform_device *pdev)
 		free_irq(muic_irqs[i].virq, info);
 	cancel_work_sync(&info->irq_work);
 
-	extcon_dev_unregister(info->edev);
-
 	return 0;
 }
 
-- 
1.7.9.5

