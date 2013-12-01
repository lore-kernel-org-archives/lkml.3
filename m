Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab3LAX5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 18:57:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29452 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab3LAX5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 18:57:44 -0500
X-AuditID: cbfee690-b7f126d00000418c-a6-529bccf7b64d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000001ceeef0$d88a7f40$899f7dc0$%han@samsung.com>
In-reply-to: <000001ceeef0$d88a7f40$899f7dc0$%han@samsung.com>
Subject: [PATCH 6/8] backlight: jornada720: use devm_lcd_device_register()
Date: Mon, 02 Dec 2013 08:57:43 +0900
Message-id: <000501ceeef1$20110b40$603321c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7u8NgcVnqPK6OFQjq+Xy+HsAignwAAD4cg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zI93vZ2YHGWw5JmcxZ/0aNovLCy+x
	WlzeNYfNgdnjxIzfLB59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CV8WzKEdaCu1wV9y52sTYw
	tnF2MXJySAiYSDzff5INwhaTuHBvPZDNxSEksIxR4sirXsYuRg6wogV/ZSHiixgltq97xALS
	ICTwi1HiRGMxiM0moCbx5cthdpB6EQF9ibYWDRCTWcBF4ug0EYhqW4kNj84zgdicAnYSE27+
	AbOFBbwklvxrBjuBRUBV4nX3G0YQmxeo/u2tq1C2oMSPyffAtjILaEms33mcCcKWl9i85i0z
	xJXqEo/+6oKERQSMJO4unMgOUSIise/FO0aID/exS1zs84FYJSDxbfIhFohWWYlNB5ghSiQl
	Dq64wTKBUWIWksWzkCyehWTxLCQbFjCyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQIibwJ
	OxjvHbA+xJgMtH4is5Rocj4wcvNK4g2NzYwsTE1MjY3MLc1IE1YS51V7lBQkJJCeWJKanZpa
	kFoUX1Sak1p8iJGJg1OqgVHnhB1P3OUPtS6S7Nb7ldsij9m/X3ZrUviy3xcXXL5w6K+ogiKf
	olD+HJX58oc+r3wqp69rH2XXf/31/nuhwSZzP1+xnX6zMcRP2v/QBI+9x4Pr+g8Ir+L8sep9
	VESJwb4FnDEmfrPCdSO6PxzSuJnxbdNiqw+1fZo2k3+yfhMolYl8deetvJgSS3FGoqEWc1Fx
	IgCGl5N30gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd3vZ2YHGbzpkLaYs34Nm8XlhZdY
	LS7vmsPmwOxxYsZvFo++LasYPT5vkgtgjmpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw
	1DW0tDBXUshLzE21VXLxCdB1y8wB2qSkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7H
	yAANJKxjzHg25QhrwV2uinsXu1gbGNs4uxg5OCQETCQW/JXtYuQEMsUkLtxbz9bFyMUhJLCI
	UWL7ukcsIAkhgV+MEicai0FsNgE1iS9fDrOD9IoI6Eu0tWiAmMwCLhJHp4lAVNtKbHh0ngnE
	5hSwk5hw8w+YLSzgJbHkXzMbiM0ioCrxuvsNI4jNC1T/9tZVKFtQ4sfke2BbmQW0JNbvPM4E
	YctLbF7zlhniYnWJR391QcIiAkYSdxdOZIcoEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZ
	xSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc2c+kdzCuarA4xCjAwajEw3vhxOwgIdbEsuLK
	3EOMEhzMSiK8Fl9nBQnxpiRWVqUW5ccXleakFh9iTAZ6dCKzlGhyPjDp5JXEGxqbmBlZGplZ
	GJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo5icTXvN5fS6NhWtB5dD+8ySX2Zp
	LH/kXR2pGfJo/1z5vWf//H37fN2m9/OX1OXz3XXuVTDuqGNTY/YRujDfJGyldvnV3ppSz9dr
	Mze+KVTNTHfNcnsU8rxux5ydwhP5HLxLQh+2bEqMuKPBdM5WeW/LpV2LuOtv91e/dpf85NKd
	1TrVoGmDEktxRqKhFnNRcSIAVl9q2jADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_lcd_device_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/jornada720_lcd.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/video/backlight/jornada720_lcd.c b/drivers/video/backlight/jornada720_lcd.c
index b061413..da3876c 100644
--- a/drivers/video/backlight/jornada720_lcd.c
+++ b/drivers/video/backlight/jornada720_lcd.c
@@ -100,7 +100,8 @@ static int jornada_lcd_probe(struct platform_device *pdev)
 	struct lcd_device *lcd_device;
 	int ret;
 
-	lcd_device = lcd_device_register(S1D_DEVICENAME, &pdev->dev, NULL, &jornada_lcd_props);
+	lcd_device = devm_lcd_device_register(&pdev->dev, S1D_DEVICENAME,
+					&pdev->dev, NULL, &jornada_lcd_props);
 
 	if (IS_ERR(lcd_device)) {
 		ret = PTR_ERR(lcd_device);
@@ -119,18 +120,8 @@ static int jornada_lcd_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int jornada_lcd_remove(struct platform_device *pdev)
-{
-	struct lcd_device *lcd_device = platform_get_drvdata(pdev);
-
-	lcd_device_unregister(lcd_device);
-
-	return 0;
-}
-
 static struct platform_driver jornada_lcd_driver = {
 	.probe	= jornada_lcd_probe,
-	.remove	= jornada_lcd_remove,
 	.driver	= {
 		.name	= "jornada_lcd",
 	},
-- 
1.7.10.4


