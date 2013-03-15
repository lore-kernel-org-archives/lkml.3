Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab3COJOH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 05:14:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53229 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3COJOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 05:14:04 -0400
X-AuditID: cbfee68d-b7f786d000005188-2b-5142e65a78b0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/6] gpio: adp5520: use devm_kzalloc()
Date: Fri, 15 Mar 2013 18:14:01 +0900
Message-id: <006201ce215d$6f133d10$4d39b730$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4hXW7HXikowtUaTheLztVYvIsx2A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t8zI92oZ06BBo9XCVq8OrORzeLywkus
	FlP+LGeyuLxrDpsDi8eda3vYPPq2rGL0+PlSx+PzJrkAligum5TUnMyy1CJ9uwSujH1TmxgL
	brBXvL26jqmBcQZbFyMnh4SAicSXznksELaYxIV764HiXBxCAssYJf42zGaGKdr/4jgTiC0k
	MJ1RYnczC0TRL0aJhUves4Mk2ATUJL58OQxmiwjoSdy40MEIYjMLFEk875rF2sXIwSEsYCYx
	/RDYMhYBVYnO3j4wm1fAVmL9jf1QtqDEj8n3WCBatSTW74TYyywgL7F5zVtmkDESAuoSj/7q
	wmy6uvseM0SJiMS+F+8YQU6TEFjHLnHzxX12iF0CEt8mg+wF6ZWV2HQA6i1JiYMrbrBMYBSb
	hWTzLCSbZyHZPAvJigWMLKsYRVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxQiKsdwfj7QPWhxiT
	gdZPZJYSTc4HRmheSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanF
	hxiZODilGhgf6Dfvv7fI4f+NHS6Tm/7YRvsr7uDJmWD6tTztU27HqqbFbHd//MuLfMGt0fxu
	maDpS2cB/mn6AeqKmhyXZD4UPPnh+vt8uLCe8LmoRjbXL8f9VwQ9mHq6SKHP/Yv6/dXSvdJT
	263eb27ZkBDwMGjCCeFOr9BDR9aoPTm3Z8WOcxEnWpVTFR8psRRnJBpqMRcVJwIAN3kc9MYC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jQd2oZ06BBl9/8li8OrORzeLywkus
	FlP+LGeyuLxrDpsDi8eda3vYPPq2rGL0+PlSx+PzJrkAlqgGRpuM1MSU1CKF1Lzk/JTMvHRb
	Je/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJVKCmWJOaVAoYDE4mIlfTtME0JD3HQt
	YBojdH1DguB6jAzQQMI6xox9U5sYC26wV7y9uo6pgXEGWxcjJ4eEgInE/hfHmSBsMYkL99aD
	xYUEpjNK7G5m6WLkArJ/MUosXPKeHSTBJqAm8eXLYTBbREBP4saFDkYQm1mgSOJ51yzWLkYO
	DmEBM4nph1hAwiwCqhKdvX1gNq+ArcT6G/uhbEGJH5PvsUC0akms3wlxA7OAvMTmNW+ZQcZI
	CKhLPPqrC7Pp6u57zBAlIhL7XrxjnMAoMAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31
	ihNzi0vz0vWS83M3MYLj95nUDsaVDRaHGAU4GJV4eA/0OwQKsSaWFVfmHmKU4GBWEuH19HIM
	FOJNSaysSi3Kjy8qzUktPsSYDPToRGYp0eR8YGrJK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1
	oJBAemJJanZqakFqEcwWJg5OqQZGu5eZxZtmPfAWc+k13T6p5vS/+Fd+e0S/yrfJS0xacEG1
	YlVWxALRxVN+xq6wZE++EpxuF/VM+XyJjJNfb+fv/HszuP5+s1HL4K0J/bRN7750+aIl9j/T
	2VJfbPl48v2arf255Sa2dhdt77I8m3O+e8VKLou6nJsHr612fqcfzFytxTClT3mlEktxRqKh
	FnNRcSIAjBZUGyMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/gpio/gpio-adp5520.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-adp5520.c b/drivers/gpio/gpio-adp5520.c
index 8afa95f..f33f78d 100644
--- a/drivers/gpio/gpio-adp5520.c
+++ b/drivers/gpio/gpio-adp5520.c
@@ -105,7 +105,7 @@ static int adp5520_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
 		dev_err(&pdev->dev, "failed to alloc memory\n");
 		return -ENOMEM;
@@ -163,7 +163,6 @@ static int adp5520_gpio_probe(struct platform_device *pdev)
 	return 0;
 
 err:
-	kfree(dev);
 	return ret;
 }
 
@@ -180,7 +179,6 @@ static int adp5520_gpio_remove(struct platform_device *pdev)
 		return ret;
 	}
 
-	kfree(dev);
 	return 0;
 }
 
-- 
1.7.2.5


