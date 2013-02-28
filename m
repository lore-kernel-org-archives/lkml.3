Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3B1Iqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:46:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:37599 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3B1Iqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:46:30 -0500
X-AuditID: cbfee68d-b7f636d0000009be-84-512f19653426
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 19/19] rtc: rtc-starfire: remove erroneous __init/__exit
 annotations
Date: Thu, 28 Feb 2013 17:46:29 +0900
Message-id: <00b701ce1590$19b55070$4d1ff150$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAARzfA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zY91USf1Ag+1/RSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK6H+zmrWgl6fi3I6VLA2ME7i6GDk5JARMJBq6WlghbDGJC/fWs3UxcnEICSxjlGg4
	sJgRpujzp+esEInpjBKnTzZCOb8YJfbtfw/WziagJvHly2H2LkYODhEBfYm2Fg2QGmaBXkaJ
	M7272UFqhARsJY61tbGA2JwCdhK/nx4F6xUWCJOY2nOUBaSXRUBVYvttOZAwL1D5gr37mSFs
	QYkfk++BtTILaEms33mcCcKWl9i85i0zSKuEgLrEo7+6IGERASOJiyv2MUOUiEjse/GOEeQc
	CYFH7BLblm0CO4dFQEDi2+RDLBC9shKbDjBD/CspcXDFDZYJjBKzkGyehWTzLCSbZyFZsYCR
	ZRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZGSKT27mC8fcD6EGMy0PqJzFKiyfnASM8riTc0
	NjYxMzE1Mbc0NTclTVhJnFfukkygkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkbRaR1Kxx9Y
	pmy607IwRVT7yn1Hg8yz+767ds1TK7/89LZ5kcmx8y+YvN3LbSz+Bry/wjxfQ3Wd+knnlXdT
	dvxLDrp8QMCuSGtBiX21bTuX2syWkpssx7aI8ahXrhURMV+tqvv18bxNNj2SXwoeHU0/n79T
	q/LNguKjFlMy0wTOrXB/+72A4bYSS3FGoqEWc1FxIgBZ16dn6gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd1USf1Ag2tXBSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzOh/s5q1oJen4tyOlSwNjBO4uhg5OSQETCQ+
	f3rOCmGLSVy4t56ti5GLQ0hgOqPE6ZONrBDOL0aJffvfg1WxCahJfPlymL2LkYNDREBfoq1F
	A6SGWaCXUeJM7252kBohAVuJY21tLCA2p4CdxO+nR8F6hQXCJKb2HGUB6WURUJXYflsOJMwL
	VL5g735mCFtQ4sfke2CtzAJaEut3HmeCsOUlNq95ywzSKiGgLvHory5IWETASOLiin3MECUi
	EvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgtPA
	M6kdjCsbLA4xCnAwKvHwdpjoBQqxJpYVV+YeYpTgYFYS4XXh1w8U4k1JrKxKLcqPLyrNSS0+
	xJgM9OdEZinR5HxgisoriTc0NjEzsjQyszAyMTcnTVhJnJfx1JMAIYH0xJLU7NTUgtQimC1M
	HJxSDYytxz54LHWOq4g/aBlt6sYjfHbvqWlB+as3XZS/yhdzbJa4aPOt9Wtnffl29LlYq/Ps
	Sf05zJ3iu3k1Fr15a3t/usmLmJKrEjNeab93+2EUy306bHXpBQ/JH+WNV08zq53xrixYnW69
	h2/JgTXqieedXjKGeZRsPrvks9F3/uKnlV02LAlzL09XYinOSDTUYi4qTgQAzZntLkcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__init/__exit annotations for probe()/remove() are supposed to be
__devinit/__devexit, because __init/__exit for probe()/remove()
are not correct. However, __devinit/__devexit are not used,
because CONFIG_HOTPLUG was removed. Thus, these annotations
should be removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-starfire.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-starfire.c b/drivers/rtc/rtc-starfire.c
index 5be98bf..d801eb5 100644
--- a/drivers/rtc/rtc-starfire.c
+++ b/drivers/rtc/rtc-starfire.c
@@ -37,7 +37,7 @@ static const struct rtc_class_ops starfire_rtc_ops = {
 	.read_time	= starfire_read_time,
 };
 
-static int __init starfire_rtc_probe(struct platform_device *pdev)
+static int starfire_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc = rtc_device_register("starfire", &pdev->dev,
 				     &starfire_rtc_ops, THIS_MODULE);
@@ -49,7 +49,7 @@ static int __init starfire_rtc_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit starfire_rtc_remove(struct platform_device *pdev)
+static int starfire_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
 
@@ -63,7 +63,7 @@ static struct platform_driver starfire_rtc_driver = {
 		.name	= "rtc-starfire",
 		.owner	= THIS_MODULE,
 	},
-	.remove		= __exit_p(starfire_rtc_remove),
+	.remove		= starfire_rtc_remove,
 };
 
 static int __init starfire_rtc_init(void)
-- 
1.7.2.5


