Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab3BOF6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 00:58:14 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:25406 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3BOF6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 00:58:13 -0500
X-AuditID: cbfee68e-b7fc26d000001938-f2-511dce73da25
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
In-reply-to: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
Subject: [PATCH 02/11] rtc: max77686: use dev_info() instead of printk()
Date: Fri, 15 Feb 2013 14:58:11 +0900
Message-id: <001301ce0b41$6f9b46b0$4ed1d410$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LQUiQnZ5yIGDDRaO8BQe4Zm4AfgAAArzQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zY93ic7KBBvM3GFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MC81H2Qq+cFQcnX6TqYFxK3sXIweHhICJxN+PIl2MnECmmMSF
	e+vZuhi5OIQEljFKzJo/mQ0iYSLx/sldFojEIkaJzsNvWSGc2UwSt34fYAapYhNQk/jy5TDY
	VBEBfYm2Fg2QGmaBXkaJM7272UFqhARsJSZ8WgdWzylgJ/H9z0OwDcICHhLb2qYzg/SyCKhK
	3OpLBAnzApV/ufqSDcIWlPgx+R4LiM0soCWxeVsTK4QtL7F5zVtmiGfUJR791QUJiwgYSTTv
	OsoOUSIise/FO0aQcyQElrFLXGx9zgSSYBEQkPg2+RALRK+sxCaITyQEJCUOrrjBMgEYBEg2
	z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIySu+nYw3jxgfYgxGWj9
	RGYp0eR8YFzmlcQbGhubmJmYmphbmpqbkiasJM4rf0kmUEggPbEkNTs1tSC1KL6oNCe1+BAj
	EwenVAPjgt8lLlP+OD++/+iNk0D69O/LFn0NXfHWfNOyvokzOjOquU68qvWKqe03aX/PmS/e
	qfK5eevvJ/WuOzzrfKtZs21K1vac5zO7W/o9srh034faSR63/hYe538nd8h9b7QD09a/ax65
	npy095x01PS7vgf/BtS+kgvfVcPH+9iom/G5fGOs2fZjSizFGYmGWsxFxYkAZRe1h8ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG7xOdlAg3c39S0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxoXmo2wFXzgqjk6/ydTA
	uJW9i5GTQ0LAROL9k7ssELaYxIV769m6GLk4hAQWMUp0Hn7LCuHMZpK49fsAM0gVm4CaxJcv
	h4G6OThEBPQl2lo0QGqYBXoZJc707gabKiRgKzHh0zqwek4BO4nvfx6ygdjCAh4S29qmM4P0
	sgioStzqSwQJ8wKVf7n6kg3CFpT4Mfke2EHMAloSm7c1sULY8hKb17wFa5UQUJd49FcXJCwi
	YCTRvOsoO0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8
	dL3k/NxNjOC4fSa9g3FVg8UhRgEORiUeXgEJ2UAh1sSy4srcQ4wSHMxKIrxrQoBCvCmJlVWp
	RfnxRaU5qcWHGJOB/pzILCWanA9MKXkl8YbGJmZGlkZmFkYm5uakCSuJ8zKeehIgJJCeWJKa
	nZpakFoEs4WJg1OqgbHPx0DpQuiOEBux5DiH35GyCs6zN3dqpK7lMWsw4ftgZvh9UWHLWkuj
	2kV6rnfeh3suUdjy9VzaxhjX0z8ubFp56OLUo1a6YQzsci0qMQvy7hbYtBpwPp7AslKpUrL5
	9EGjs+d+S5/jil3PrrbPbWHPBh+buT//f2q88nPP8bCZRn3CC3yk3yuxFGckGmoxFxUnAgDo
	FDvrHwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-max77686.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index 2da0855..abe27c0 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -507,7 +507,7 @@ static int max77686_rtc_probe(struct platform_device *pdev)
 	struct max77686_rtc_info *info;
 	int ret, virq;
 
-	printk(KERN_INFO "%s\n", __func__);
+	dev_info(&pdev->dev, "%s\n", __func__);
 
 	info = kzalloc(sizeof(struct max77686_rtc_info), GFP_KERNEL);
 	if (!info)
@@ -546,7 +546,7 @@ static int max77686_rtc_probe(struct platform_device *pdev)
 			&max77686_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(info->rtc_dev)) {
-		printk(KERN_INFO "%s: fail\n", __func__);
+		dev_info(&pdev->dev, "%s: fail\n", __func__);
 
 		ret = PTR_ERR(info->rtc_dev);
 		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
-- 
1.7.2.5


