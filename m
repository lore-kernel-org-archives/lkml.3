Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab3HTHF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:05:56 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59532 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab3HTHFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:05:55 -0400
X-AuditID: cbfee691-b7fef6d000002d62-a6-52131552cc90
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 5/6] mfd: tps65010: use devm_*() functions
Date: Tue, 20 Aug 2013 16:05:54 +0900
Message-id: <005901ce9d73$b61bd400$22537c00$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6dc7ItoAYed6Y2TUaelkyQjpzyRA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zQ90gUeEgg7ZXChaXF15itbj/9Sij
	xeVdc9gsTnezOrB43Lm2h81j3slAj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mq4tHg1U8E6
	7orJD98yNzD2cXYxcnBICJhILN0s0MXICWSKSVy4t56ti5GLQ0hgGaPE5neP2CESJhIPL9xm
	gkgsYpRon7cXyvnFKHFv3y4mkCo2ATWJL18Os4NMFRHwk2hYAdbMLOAk8XPLTBYQW1jASuLt
	hHOMIDaLgKrE4kdfwWxeAUuJ1Xe/MUPYghI/Jt9jgejVkli/8zgThC0vsXnNW2aIgxQkdpx9
	DdYrIqAnsfDURkaIGhGJfS/eMULUbGKX2LbfGmKXgMS3yYdYIB6Wldh0AGqMpMTBFTdYJjCK
	zUKyeRaSzbOQbJ6FZMMCRpZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCHxNXEH4/0D1ocY
	k4HWT2SWEk3OB8ZnXkm8obGZkYWpiamxkbmlGWnCSuK86i3WgUIC6YklqdmpqQWpRfFFpTmp
	xYcYmTg4pRoYi8UmPBJwL/rx+URUxwH2SxNS1BY+ze588n5Zi2X4hYXbNwaF3DfQX1HN0HEh
	vObGsi1rPYyVl/6+ufPe04odpX1Cat3hbcrb1G/qPg1puzC7bnrlr+QZl6e15i+babFRb2bt
	MkE1572LJ1//Mv0jKz/zXuG731q6zly3Z+z1v7DHfbn3utCVm5RYijMSDbWYi4oTAdEyT/rF	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd0gUeEgg997ZS0uL7zEanH/61FG
	i8u75rBZnO5mdWDxuHNtD5vHvJOBHn1bVjF6fN4kF8AS1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMeYcWnxaqaCddwVkx++ZW5g7OPsYuTkkBAwkXh44TYThC0mceHeerYu
	Ri4OIYFFjBLt8/YyQTi/GCXu7dsFVsUmoCbx5cth9i5GDg4RAT+JhhXsIGFmASeJn1tmsoDY
	wgJWEm8nnGMEsVkEVCUWP/oKZvMKWEqsvvuNGcIWlPgx+R4LRK+WxPqdx5kgbHmJzWveMkMc
	pCCx4+xrsF4RAT2Jhac2MkLUiEjse/GOcQKjwCwko2YhGTULyahZSFoWMLKsYhRNLUguKE5K
	zzXSK07MLS7NS9dLzs/dxAiO4GfSOxhXNVgcYhTgYFTi4e1QEgoSYk0sK67MPcQowcGsJMLr
	8h8oxJuSWFmVWpQfX1Sak1p8iDEZ6NOJzFKiyfnA5JJXEm9obGJmZGlkZmFkYm5OmrCSOO/B
	VutAIYH0xJLU7NTUgtQimC1MHJxSDYwucqz9NZ3i97VZ/+oui2J0/VUkd7Wr5f7zJUUSz4Sn
	75F9eabgQOptKea0Xx8eXpBepPv63ru1dd9WrS0O3Kgefd+lK2DdNvvHQTar4717WV+EfTD5
	e6M50XLr+rLr0uvuNtyZcdx2qnh/wdU19/wP7Pt77kDWqSztYxxK9/7+2HlcbZmu7KcpSizF
	GYmGWsxFxYkAVdIIcyQDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/tps65010.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/tps65010.c b/drivers/mfd/tps65010.c
index 8114567..743fb52 100644
--- a/drivers/mfd/tps65010.c
+++ b/drivers/mfd/tps65010.c
@@ -530,7 +530,6 @@ static int __exit tps65010_remove(struct i2c_client *client)
 		free_irq(client->irq, tps);
 	cancel_delayed_work_sync(&tps->work);
 	debugfs_remove(tps->file);
-	kfree(tps);
 	the_tps = NULL;
 	return 0;
 }
@@ -550,7 +549,7 @@ static int tps65010_probe(struct i2c_client *client,
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
 		return -EINVAL;
 
-	tps = kzalloc(sizeof *tps, GFP_KERNEL);
+	tps = devm_kzalloc(&client->dev, sizeof(*tps), GFP_KERNEL);
 	if (!tps)
 		return -ENOMEM;
 
@@ -568,7 +567,7 @@ static int tps65010_probe(struct i2c_client *client,
 		if (status < 0) {
 			dev_dbg(&client->dev, "can't get IRQ %d, err %d\n",
 					client->irq, status);
-			goto fail1;
+			return status;
 		}
 		/* annoying race here, ideally we'd have an option
 		 * to claim the irq now and enable it later.
@@ -668,9 +667,6 @@ static int tps65010_probe(struct i2c_client *client,
 	}
 
 	return 0;
-fail1:
-	kfree(tps);
-	return status;
 }
 
 static const struct i2c_device_id tps65010_id[] = {
-- 
1.7.10.4


