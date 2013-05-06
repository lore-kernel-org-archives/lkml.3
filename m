Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab3EFEUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:20:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49016 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3EFEUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:20:17 -0400
X-AuditID: cbfee68d-b7f016d000007930-bd-51872f7f15b9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Hongbo Zhang'" <hongbo.zhang@linaro.org>,
        "'Marcus Cooper'" <marcus.xm.cooper@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/8] ab8500_bm: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 13:20:15 +0900
Message-id: <003801ce4a11$0259c4a0$070d4de0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KEKYVJ4FIBd/jQ26VMLTyqPxNqg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zA916/fZAg49dmhYHt2paTFw5mdli
	yoY7rBb3vx5ltLi8aw6bxc6XM1gc2Dwm9H9i9Ni8QsvjzrU9bB7fl65h9/i8SS6ANYrLJiU1
	J7MstUjfLoErY1p7J2PBWcGK84fvsjcwNvJ3MXJySAiYSByZNp0NwhaTuHBvPZDNxSEksIxR
	YvW6xUwwRT/mLoVKTGeU+HZsFxOE84tRom97KwtIFZuAmsSXL4fZQWwRAQ2JttVTWECKmAXO
	MUocOjAfbIewgKfE/d53jCA2i4CqxMrdx1lBbF4BS4m1T9uYIGxBiR+T74ENZRbQkli/8zgT
	hC0vsXnNW2aIkxQkdpx9zQixTE9iR+M8VogaEYl9L0DmcwHVHGOXWH3lCtQyAYlvkw8BDeUA
	SshKbDoANUdS4uCKGywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiQ73ixNzi0rx0
	veT83E2MkCjs3cF4+4D1IcZkoPUTmaVEk/OBUZxXEm9obGZkYWpiamxkbmlGmrCSOK9ai3Wg
	kEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkbHzscbl/GcddObNGHb0RvsOi7mz3mzq3ZLLasy
	9S464XqC77pZkP3BP1cW5rYU/uhYIFHqdqDMSDX8kvKu2ybPknxPa1dwsexRv1xXt//v7xta
	QtNMfnbeCr+1XNVC9nzpmZb6N9Nn39A5LGaY58Jt6TZj5/epPzODOH8t7xaNdWl2SLmaWqrE
	UpyRaKjFXFScCAA+m7Wu2AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t9jQd16/fZAg63tKhYHt2paTFw5mdli
	yoY7rBb3vx5ltLi8aw6bxc6XM1gc2Dwm9H9i9Ni8QsvjzrU9bB7fl65h9/i8SS6ANaqB0SYj
	NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
	UEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8a09k7GgrOCFecP32VvYGzk72Lk5JAQ
	MJH4MXcpG4QtJnHh3nogm4tDSGA6o8S3Y7uYIJxfjBJ921tZQKrYBNQkvnw5zA5iiwhoSLSt
	nsICUsQscI5R4tCB+WCjhAU8Je73vmMEsVkEVCVW7j7OCmLzClhKrH3axgRhC0r8mHwPbCiz
	gJbE+p3HmSBseYnNa94yQ5ykILHj7GtGiGV6Ejsa57FC1IhI7HvxjnECo8AsJKNmIRk1C8mo
	WUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjvFn0jsYVzVYHGIU4GBU4uEteNIW
	KMSaWFZcmXuIUYKDWUmE12cvUIg3JbGyKrUoP76oNCe1+BBjMtCnE5mlRJPzgeknryTe0NjE
	zMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYZUrvnBRTO1CguFxi/yP5
	6HMXr7R8rLvgqFDd2dz0kdcgzr9tCps0l+g1t23OjoVlCqc2ujxTEFh6tf1gQ1OGsw7bBdaF
	HIpz5uRcvz/1xOeXs6oK4iLt08N5NtTlfrjfzzChQNrwWWBwkny33GrLMKYnLkVxJ3ydZWab
	un1ym6F9+07rARslluKMREMt5qLiRAAtJPIZNQMAAA==
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
 drivers/power/ab8500_btemp.c    |    1 -
 drivers/power/ab8500_charger.c  |    2 --
 drivers/power/ab8500_fg.c       |    1 -
 drivers/power/abx500_chargalg.c |    1 -
 4 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index d412d34..7f9a454 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -1045,7 +1045,6 @@ static int ab8500_btemp_remove(struct platform_device *pdev)
 
 	flush_scheduled_work();
 	power_supply_unregister(&di->btemp_psy);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index a558318..f098fda 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -3425,8 +3425,6 @@ static int ab8500_charger_remove(struct platform_device *pdev)
 	if (di->ac_chg.enabled && !di->ac_chg.external)
 		power_supply_unregister(&di->ac_chg.psy);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index c5391f5..1263638 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -3070,7 +3070,6 @@ static int ab8500_fg_remove(struct platform_device *pdev)
 	flush_scheduled_work();
 	ab8500_fg_sysfs_psy_remove_attrs(di->fg_psy.dev);
 	power_supply_unregister(&di->fg_psy);
-	platform_set_drvdata(pdev, NULL);
 	return ret;
 }
 
diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index 9863e42..6d27236 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -2035,7 +2035,6 @@ static int abx500_chargalg_remove(struct platform_device *pdev)
 	destroy_workqueue(di->chargalg_wq);
 
 	power_supply_unregister(&di->chargalg_psy);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.2.5


