Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab3CKGaM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:30:12 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18411 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3CKGaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:30:08 -0400
X-AuditID: cbfee68e-b7f946d000001e37-8d-513d79ee35f3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] power: abx500_chargalg: use module_platform_driver() macro
Date: Mon, 11 Mar 2013 15:30:06 +0900
Message-id: <007001ce1e21$df084be0$9d18e3a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4eId7qHHQQJt33RiWRyLZHYMZtbQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t8zQ913lbaBBku+qltc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M3U132Ques1fcX3aOtYHxAVsXIyeHhICJxMpj86BsMYkL99YD
	2VwcQgLLGCW+vTnO2MXIAVb0YVUERHwRo0Tv/N2MEM5sJonFG/Yyg3SzCahJfPlymB3EFhHQ
	kGhbPYUFxGYWyJc4fOgyC8ggYQFviR1H80HCLAKqEqs+zANr5RWwlTj9exGULSjxY/I9qFYt
	ic3bmlghbHmJzWveMkPcoy7x6K8uxCY9ibM73kOVi0jse/EO7DQJgWZ2ia0z/7ND7BKQ+Db5
	EAtEr6zEpgPMEP9KShxccYNlAqPYLCSbZyHZPAvJ5llIVixgZFnFKJpakFxQnJReZKRXnJhb
	XJqXrpecn7uJERInfTsYbx6wPsSYDLR+IrOUaHI+MM7ySuINjc2MLExNTI2NzC3NSBNWEudV
	a7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAopBC4IuxGx+eTBdm64ecD7DxMZdp5fyy2
	djBmj98ky3z5y6o1SzOVzdmCFT6tm+Ge88NvM6Nwi4Wmtqum4D9eP78GQe432xc37zTZf+r1
	13tHOKU+t3W0mX812nVllnzrwtM5b36qKHukVldOqmTp5JQ7nSGwWv3+RZE/Vof+yOxw4vvH
	HaTEUpyRaKjFXFScCABfP15ZqQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jAd13lbaBBkv3Kltc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjN1Nd9kLnrNX3F92jrWB
	8QFbFyMHh4SAicSHVRFdjJxAppjEhXvrgcJcHEICixgleufvZoRwZjNJLN6wlxmkik1ATeLL
	l8PsILaIgIZE2+opLCA2s0C+xOFDl1lAhgoLeEvsOJoPEmYRUJVY9WEeWCuvgK3E6d+LoGxB
	iR+T70G1akls3tbECmHLS2xe85YZ4jZ1iUd/dSE26Umc3fEeqlxEYt+Ld4wTGAVmIZk0C8mk
	WUgmzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcBQ+k97BuKrB4hCjAAejEg/v
	BB3bQCHWxLLiytxDjBIczEoivCs32QQK8aYkVlalFuXHF5XmpBYfYkwGenQis5Rocj4wQeSV
	xBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6Pk1J+FJ+yfnrS0
	0C9jf+JgmdD7sPd++5yr2p9TE/9x/JYQyl8scN1breHQxfmJj7yVLjG/7bmeLem88cDxt/Zd
	IRU3ds//K9el1J3RKb57zpR0AelXu40Tlq+7l8J9g+WdzJOQs3asJ3aJX7/yTrwqVmvGv5Zv
	F+LNNuWcXl3N2re12ICr+YUSS3FGoqEWc1FxIgAIPtaZBgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/abx500_chargalg.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/power/abx500_chargalg.c b/drivers/power/abx500_chargalg.c
index f043c08..3d8e2f3 100644
--- a/drivers/power/abx500_chargalg.c
+++ b/drivers/power/abx500_chargalg.c
@@ -1964,18 +1964,7 @@ static struct platform_driver abx500_chargalg_driver = {
 	},
 };
 
-static int __init abx500_chargalg_init(void)
-{
-	return platform_driver_register(&abx500_chargalg_driver);
-}
-
-static void __exit abx500_chargalg_exit(void)
-{
-	platform_driver_unregister(&abx500_chargalg_driver);
-}
-
-module_init(abx500_chargalg_init);
-module_exit(abx500_chargalg_exit);
+module_platform_driver(abx500_chargalg_driver);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Johan Palsson, Karl Komierowski");
-- 
1.7.2.5


