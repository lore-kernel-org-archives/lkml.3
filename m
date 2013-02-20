Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934549Ab3BTJ37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:29:59 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:20503 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934470Ab3BTJ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:29:54 -0500
X-AuditID: cbfee68d-b7f4f6d000004209-45-51249791aa52
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
In-reply-to: <000f01ce0f4c$7c1d01d0$74570570$%han@samsung.com>
Subject: [PATCH V2 5/9] mfd: aat2870: use use devm_*() functions
Date: Wed, 20 Feb 2013 18:29:53 +0900
Message-id: <001301ce0f4c$d6ddbbf0$849933d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4PTHvvVazquf7TSyaZqgztkH4/LAAAE5Ug
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zQ92J01UCDRp+WVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mb9vXshV08FdMXzifsYGxm6eLkZNDQsBE4sH2LnYIW0ziwr31
	bCC2kMAyRomze5Vgau7NfAoU5wKKT2eUOLphAZQzm0nidf9XsA42ATWJL18Og00SEdCS6D52
	HijOwcEs4CJxdJoIxFBbiUddW5lBbE4BO4mWa/PAbGEBB4krG9pYQMpZBFQlbs3UBwnzApXP
	6Z3GBmELSvyYfI8FxGYGmr5+53EmCFteYvOat8wgrRIC6hKP/upCHGAk8XTSV6hyEYl9L94x
	glwsIbCIXeLXlktgV7IICEh8m3yIBaJXVmLTAWaIdyUlDq64wTKBUWIWks2zkGyehWTzLCQr
	FjCyrGIUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQIiareHYy3D1gfYkwGWj+RWUo0OR8YlXkl
	8YbGxiZmJqYm5pam5qakCSuJ88pdkgkUEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwJjTtPXH
	gTzm6bsPrbOyzCjZuYL9QuqPFYffHX7S/6kxp68oLv2gitfzm/eaPtx5KbEydIOvwsLvH/hl
	lqnPvLaKfxOHRV+w4pu9cTccmOIE5Fh+zzZ0YzP587Tsbo3s1G1XYipPLXN6WrKHS2Ln2U/c
	V2pO6U5bYuOTNmexdsG5KMnNOxav1dVWYinOSDTUYi4qTgQAcUxK7cACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoO7E6SqBBhOWmVpc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjG/b17IVdPBXTF84n7GB
	sZuni5GTQ0LAROLezKdsELaYxIV764FsLg4hgemMEkc3LIByZjNJvO7/ClbFJqAm8eXLYXYQ
	W0RAS6L72HmgOAcHs4CLxNFpIiBhIQFbiUddW5lBbE4BO4mWa/PAbGEBB4krG9pYQMpZBFQl
	bs3UBwnzApXP6Z3GBmELSvyYfI8FxGYGmr5+53EmCFteYvOat8wgrRIC6hKP/upCHGAk8XTS
	V6hyEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmb
	GMFR+0xqB+PKBotDjAIcjEo8vBrzlQOFWBPLiitzDzFKcDArifD+7FAJFOJNSaysSi3Kjy8q
	zUktPsSYDPTnRGYp0eR8YELJK4k3NDYxM7I0MrMwMjE3J01YSZyX8dSTACGB9MSS1OzU1ILU
	IpgtTBycUg2M21fM9jsxcfu1dPcHkZFvlrXmb9dmWvWf3/nBzUPXNmXYGFwpjDniY/WrXiNq
	YQnn7z0qhW5Tbj44MPnPvuQXk4zE7XYff5rX8E1qxyMDo7V+G71WxbZJzX7ntj3/wed33I0b
	+7ULztx1kKqWuJIpa7D877MYtrzzTI92Lgp8tnv2M9Z782yyzyqxFGckGmoxFxUnAgB6N7YP
	HgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
No changes since v1:

 drivers/mfd/aat2870-core.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/aat2870-core.c b/drivers/mfd/aat2870-core.c
index f1beb49..dfdb0a2 100644
--- a/drivers/mfd/aat2870-core.c
+++ b/drivers/mfd/aat2870-core.c
@@ -367,12 +367,12 @@ static int aat2870_i2c_probe(struct i2c_client *client,
 	int i, j;
 	int ret = 0;
 
-	aat2870 = kzalloc(sizeof(struct aat2870_data), GFP_KERNEL);
+	aat2870 = devm_kzalloc(&client->dev, sizeof(struct aat2870_data),
+				GFP_KERNEL);
 	if (!aat2870) {
 		dev_err(&client->dev,
 			"Failed to allocate memory for aat2870\n");
-		ret = -ENOMEM;
-		goto out;
+		return -ENOMEM;
 	}
 
 	aat2870->dev = &client->dev;
@@ -400,12 +400,12 @@ static int aat2870_i2c_probe(struct i2c_client *client,
 		aat2870->init(aat2870);
 
 	if (aat2870->en_pin >= 0) {
-		ret = gpio_request_one(aat2870->en_pin, GPIOF_OUT_INIT_HIGH,
-				       "aat2870-en");
+		ret = devm_gpio_request_one(&client->dev, aat2870->en_pin,
+					GPIOF_OUT_INIT_HIGH, "aat2870-en");
 		if (ret < 0) {
 			dev_err(&client->dev,
 				"Failed to request GPIO %d\n", aat2870->en_pin);
-			goto out_kfree;
+			return ret;
 		}
 	}
 
@@ -436,11 +436,6 @@ static int aat2870_i2c_probe(struct i2c_client *client,
 
 out_disable:
 	aat2870_disable(aat2870);
-	if (aat2870->en_pin >= 0)
-		gpio_free(aat2870->en_pin);
-out_kfree:
-	kfree(aat2870);
-out:
 	return ret;
 }
 
@@ -452,11 +447,8 @@ static int aat2870_i2c_remove(struct i2c_client *client)
 
 	mfd_remove_devices(aat2870->dev);
 	aat2870_disable(aat2870);
-	if (aat2870->en_pin >= 0)
-		gpio_free(aat2870->en_pin);
 	if (aat2870->uninit)
 		aat2870->uninit(aat2870);
-	kfree(aat2870);
 
 	return 0;
 }
-- 
1.7.2.5


