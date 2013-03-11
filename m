Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab3CKGfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:35:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:60547 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258Ab3CKGfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:35:41 -0400
X-AuditID: cbfee68e-b7f946d000001e37-19-513d7b3a9fa3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
In-reply-to: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
Subject: [PATCH 12/14] power: pcf50633-charger: use devm_kzalloc()
Date: Mon, 11 Mar 2013 15:35:38 +0900
Message-id: <007c01ce1e22$a502f980$ef08ec80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4eIfOI6J7YtEddQ/Gjh19YaZUzVAAAKO8g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zA12rattAg/73hhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj4qSvLAW3eCqeNE1naWDcztXFyMkhIWAiMXdbIxOELSZx4d56
	ti5GLg4hgWWMEm8frWaEKdr8cQM7RGIRo8SN1dsYIZzZTBKbrnSxg1SxCahJfPlyGMwWEdCQ
	aFs9hQXEZhbIlzh86DKYLSRgK7H75wuwqZwCdhI3ll1iA7GFBZwkti78CXYGi4CqROf6q8wg
	Ni9Q/f03q1ggbEGJH5PvQc3Ukti8rYkVwpaX2LzmLVA9B9Cl6hKP/upCnGAksaFtIzNEiYjE
	vhfvwG6WEJjHLrHs7DWoXQIS3yYfYoHolZXYdIAZ4mFJiYMrbrBMYJSYhWTzLCSbZyHZPAvJ
	igWMLKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxQmKrbwfjzQPWhxiTgdZPZJYSTc4HxmZe
	SbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhh7rvd9
	PvrvuZZd6y3Ofev+ie6/fGFKe0zkwXjr7PagxNNpa69tdFx53HD1zLfrtDJN1p7vz2yZvGWJ
	/p3/8fbrmJxEWlWu8r9/13J5neZVbfXPfw/daPuolHTJ6shz55fpb+NT7GLS6vwStxf0qLJd
	d400SPB3nH0s/OBlCV+l7b591VaybxiVWIozEg21mIuKEwGMI7j4wwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgK5VtW2gwY1XuhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4+KkrywFt3gqnjRNZ2lg
	3M7VxcjJISFgIrH54wZ2CFtM4sK99WxdjFwcQgKLGCVurN7GCOHMZpLYdKULrIpNQE3iy5fD
	YLaIgIZE2+opLCA2s0C+xOFDl8FsIQFbid0/XzCC2JwCdhI3ll1iA7GFBZwkti78yQRiswio
	SnSuv8oMYvMC1d9/s4oFwhaU+DH5HtRMLYnN25pYIWx5ic1r3gLVcwBdqi7x6K8uxAlGEhva
	NjJDlIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P
	3cQIjtxnUjsYVzZYHGIU4GBU4uGdoGMbKMSaWFZcmXuIUYKDWUmEd+Umm0Ah3pTEyqrUovz4
	otKc1OJDjMlAj05klhJNzgcmlbySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YW
	pBbBbGHi4JRqYJSSdDJ7csrl0P6aCQVKKlzi8eyZMvXnwubNCdvwd64U/63fWovy3oYI3NVL
	+te/paJt8wHT8/eE/jhzaUqGCXBOWbTHKVKptz1thnzPba8ltuo+Vp/YC4pUvLPrXW8eFmPN
	35GZWSoRaXX3/q6OBa2Tfy+JrlQX0Eh6P3V2aufSLxO9jJVnKLEUZyQaajEXFScCAK7IOVIg	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/pcf50633-charger.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index c2122a7..17fd77f 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -373,7 +373,7 @@ static int pcf50633_mbc_probe(struct platform_device *pdev)
 	int i;
 	u8 mbcs1;
 
-	mbc = kzalloc(sizeof(*mbc), GFP_KERNEL);
+	mbc = devm_kzalloc(&pdev->dev, sizeof(*mbc), GFP_KERNEL);
 	if (!mbc)
 		return -ENOMEM;
 
@@ -413,7 +413,6 @@ static int pcf50633_mbc_probe(struct platform_device *pdev)
 	ret = power_supply_register(&pdev->dev, &mbc->adapter);
 	if (ret) {
 		dev_err(mbc->pcf->dev, "failed to register adapter\n");
-		kfree(mbc);
 		return ret;
 	}
 
@@ -421,7 +420,6 @@ static int pcf50633_mbc_probe(struct platform_device *pdev)
 	if (ret) {
 		dev_err(mbc->pcf->dev, "failed to register usb\n");
 		power_supply_unregister(&mbc->adapter);
-		kfree(mbc);
 		return ret;
 	}
 
@@ -430,7 +428,6 @@ static int pcf50633_mbc_probe(struct platform_device *pdev)
 		dev_err(mbc->pcf->dev, "failed to register ac\n");
 		power_supply_unregister(&mbc->adapter);
 		power_supply_unregister(&mbc->usb);
-		kfree(mbc);
 		return ret;
 	}
 
@@ -461,8 +458,6 @@ static int pcf50633_mbc_remove(struct platform_device *pdev)
 	power_supply_unregister(&mbc->adapter);
 	power_supply_unregister(&mbc->ac);
 
-	kfree(mbc);
-
 	return 0;
 }
 
-- 
1.7.2.5


