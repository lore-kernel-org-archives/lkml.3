Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab3IXJN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:13:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:21800 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3IXJNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:13:25 -0400
X-AuditID: cbfee68e-b7f756d000004512-d2-524157b4b6c9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 10/22] backlight: da9052_bl: use
 devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:13:24 +0900
Message-id: <005001ceb906$52535b60$f6fa1220$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAAQy2g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zI90t4Y5BBhvaZCzmrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsEroxV3V1M
	BSc4K94ei21g7OLoYuTkkBAwkfh28h87hC0mceHeerYuRi4OIYFljBKP+z8wwhSdeXEaKrGI
	UaLzwSUWCOcXo8TXxZNYQarYBNQkvnw5DDSKg0NEQF+irUUDJMwskCNx/8kssA1CArYS6z7M
	BrM5BewkTi09wwZiCwsES2w8uhlsGYuAqsT0hT/BRvIC1b/b3MQGYQtK/Jh8jwVippbE5m1N
	rBC2vMTmNW+ZQdZKCKhLPPqrCxIWETCS2LHtF1S5iMS+F+8YQU6WEDjHLtF54yILxC4BiW+T
	D7FA9MpKbDrADPGvpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRUZ6xYm5
	xaV56XrJ+bmbGCEx2beD8eYB60OMyUDrJzJLiSbnA2M6ryTe0NjMyMLUxNTYyNzSjDRhJXFe
	tRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MLh+MWcMfqvAu3yiRdezEzSo5pTul/S80
	ZaIuhCzdx7G0/uiM4rMsUwtF3TIa9wlPfS5ZL3/0lOHLlTVSyc6Sy26d+OTtYqkt9/T55m2a
	5yIdE84Hsy1bfGazSO7uf/7ayX4hG416n2w1fqRznu2BpcM3J+7n8z8umrM28PbeuQJlP5P2
	79o1S4mlOCPRUIu5qDgRAJhLlt3fAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd0t4Y5BBue3SljMWb+GzeLywkus
	Fpd3zWGz2L3rKasDi8eJGb9ZPPbM/8Hq0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZq7q7mApOcFa8PRbbwNjF0cXIySEhYCJx5sVpNghbTOLCvfVA
	NheHkMAiRonOB5dYIJxfjBJfF09iBaliE1CT+PLlMHsXIweHiIC+RFuLBkiYWSBH4v6TWewg
	tpCArcS6D7PBbE4BO4lTS8+ALRAWCJbYeHQzI4jNIqAqMX3hT7CRvED17zY3sUHYghI/Jt9j
	gZipJbF5WxMrhC0vsXnNW2aQtRIC6hKP/uqChEUEjCR2bPsFVS4ise/FO8YJjEKzkEyahWTS
	LCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOOKfSe1gXNlgcYhRgINRiYd3
	h7dDkBBrYllxZe4hRgkOZiUR3hu2jkFCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9MRnkl
	8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwFgXq2P57sqGyB2T
	tCckXDjJHFr075XNot1Zb9YfFNmbGv1HcHPZl4oNnwSn/lkr++FA6x8GPwFNy7kMv6T6GJbu
	yTGXFbz8RHmGn4bB0+aM+4uLijWD1m0uunry9ZbojrYADd6InmoHs+Qnj/Yb/P+f730tUPPd
	RdZtO/bLKy/fy2ZTFJMddUOJpTgj0VCLuag4EQAAjK61PAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/da9052_bl.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/da9052_bl.c b/drivers/video/backlight/da9052_bl.c
index 842da5a..20d55be 100644
--- a/drivers/video/backlight/da9052_bl.c
+++ b/drivers/video/backlight/da9052_bl.c
@@ -125,8 +125,9 @@ static int da9052_backlight_probe(struct platform_device *pdev)
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = DA9052_MAX_BRIGHTNESS;
 
-	bl = backlight_device_register(pdev->name, wleds->da9052->dev, wleds,
-				       &da9052_backlight_ops, &props);
+	bl = devm_backlight_device_register(&pdev->dev, pdev->name,
+					wleds->da9052->dev, wleds,
+					&da9052_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "Failed to register backlight\n");
 		return PTR_ERR(bl);
@@ -147,7 +148,6 @@ static int da9052_backlight_remove(struct platform_device *pdev)
 	wleds->brightness = 0;
 	wleds->state = DA9052_WLEDS_OFF;
 	da9052_adjust_wled_brightness(wleds);
-	backlight_device_unregister(bl);
 
 	return 0;
 }
-- 
1.7.10.4


