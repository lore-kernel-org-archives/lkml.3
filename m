Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab3IXJUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:20:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23104 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab3IXJUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:20:35 -0400
X-AuditID: cbfee68e-b7f756d000004512-27-524159621ef0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 22/22] backlight: wm831x_bl: use
 devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:20:33 +0900
Message-id: <005c01ceb907$528635c0$f792a140$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAAjvcg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zA92kSMcgg0XPBS3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsEroyO3YfY
	CjbxVBxcMYG9gXEzVxcjJ4eEgInE6Wc9jBC2mMSFe+vZuhi5OIQEljFK/L3SwQpT9Pv/D1aI
	xHRGiXezjzJBOL8YJf7tesoEUsUmoCbx5cth9i5GDg4RAX2JthYNkDCzQI7E/Sez2EFsIQFb
	iXUfZoPZnAJ2EqeWnmEDsYUFgiWOzvjAAmKzCKhKTF2/CSzOC1R/c8ErRghbUOLH5HssEDO1
	JDZva2KFsOUlNq95ywyyVkJAXeLRX12QsIiAkcTBT7+ZIUpEJPa9eMcIcrKEwCV2idk3nzBD
	7BKQ+Db5EAtEr6zEpgPMEP9KShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJRe
	ZKRXnJhbXJqXrpecn7uJERKVfTsYbx6wPsSYDLR+IrOUaHI+MKrzSuINjc2MLExNTI2NzC3N
	SBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cCo0lGlEPTftOfoNevquIjvXCo5
	ccKet9jmX99Xx7f3nOIB8QB1m+IjN1gl93q+muS/5rbr1prY4uCC+/a9D79XHOKZL2Jk90no
	wfFbv1VvOZqkzX6dsN9hZaAJ76yrUod4vLSF9AtcNGa2BLRc8T/kkuKmvmPPpcY3B7rE0+db
	L4qbHieyPEyJpTgj0VCLuag4EQBOlApA4AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd2kSMcgg78tfBZz1q9hs7i88BKr
	xeVdc9gsdu96yurA4nFixm8Wjz3zf7B69G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWNGx+5DbAWbeCoOrpjA3sC4mauLkZNDQsBE4vf/H6wQtpjEhXvr
	2boYuTiEBKYzSrybfZQJwvnFKPFv11MmkCo2ATWJL18Os3cxcnCICOhLtLVogISZBXIk7j+Z
	xQ5iCwnYSqz7MBvM5hSwkzi19AwbiC0sECxxdMYHFhCbRUBVYur6TWBxXqD6mwteMULYghI/
	Jt9jgZipJbF5WxMrhC0vsXnNW2aQtRIC6hKP/uqChEUEjCQOfvrNDFEiIrHvxTvGCYxCs5BM
	moVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzjmn0nvYFzVYHGIUYCD
	UYmH90KCQ5AQa2JZcWXuIUYJDmYlEd4bto5BQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwP
	TEd5JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cAYbvddovSf
	eVCW5KHFlWtu/XrBe6Jhj6zPgUn/WiL7NviYnfgfyPB3qWuLed4fk3kVh4pi/eadNEpX/zad
	Z2tH1oKdsmWeaXLhPE8tZjw02mxy9WSntNwH0QbGe6uTuqUyX9x1XG7f9fvcQtFbylc2pM58
	NJf/VYjiUeeWbSaGrlem8c74t+mKEktxRqKhFnNRcSIAGdSUiT0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/wm831x_bl.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/video/backlight/wm831x_bl.c b/drivers/video/backlight/wm831x_bl.c
index 2ccf320..8b9455e 100644
--- a/drivers/video/backlight/wm831x_bl.c
+++ b/drivers/video/backlight/wm831x_bl.c
@@ -195,8 +195,8 @@ static int wm831x_backlight_probe(struct platform_device *pdev)
 	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = max_isel;
-	bl = backlight_device_register("wm831x", &pdev->dev, data,
-				       &wm831x_backlight_ops, &props);
+	bl = devm_backlight_device_register(&pdev->dev, "wm831x", &pdev->dev,
+					data, &wm831x_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		return PTR_ERR(bl);
@@ -214,21 +214,12 @@ static int wm831x_backlight_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int wm831x_backlight_remove(struct platform_device *pdev)
-{
-	struct backlight_device *bl = platform_get_drvdata(pdev);
-
-	backlight_device_unregister(bl);
-	return 0;
-}
-
 static struct platform_driver wm831x_backlight_driver = {
 	.driver		= {
 		.name	= "wm831x-backlight",
 		.owner	= THIS_MODULE,
 	},
 	.probe		= wm831x_backlight_probe,
-	.remove		= wm831x_backlight_remove,
 };
 
 module_platform_driver(wm831x_backlight_driver);
-- 
1.7.10.4


