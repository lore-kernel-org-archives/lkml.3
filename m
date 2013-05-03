Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762889Ab3ECGeS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:34:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22340 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762770Ab3ECGeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:34:17 -0400
X-AuditID: cbfee691-b7fe56d000004b96-cd-51835a677c80
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>,
        "'Wan ZongShun'" <mcuos.com@gmail.com>
Subject: [PATCH 28/42] rtc: rtc-nuc900: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:34:15 +0900
Message-id: <002a01ce47c8$3b993250$b2cb96f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyCo7Zrja+ykVTkGJFunfp9GDjg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zA92MqOZAg5luFksuXmW3mLN+DZvF
	5YWXWC0u75rDZvF0ep3F/s4ORgc2j52z7rJ77Jl4ks3jxIzfLB59W1Yxekyf95PJ4/MmuQC2
	KC6blNSczLLUIn27BK6MJZ3vWAr2sFV0nf7J2sC4nrWLkZNDQsBE4vCcr4wQtpjEhXvr2boY
	uTiEBJYxSqxYNI0RpujNhluMEIlFjBLfjrczgySEBH4xSjxpNgSx2QTUJL58OczexcjBISKg
	L9HWogFSzyywmVHiYNMmFpAaYYFgiRuXv4ANZRFQlTj6+TMbiM0rYCmx5f5kKFtQ4sfke2D1
	zAJaEut3HmeCsOUlNq95ywxxkILEjrOvweaICOhJrDz9BqpGRGLfi3dQR19ilzi9ShBil4DE
	t8mHWEBukxCQldh0AGqMpMTBFTdYJjCKzUKyeRaSzbOQbJ6FZMMCRpZVjKKpBckFxUnpRaZ6
	xYm5xaV56XrJ+bmbGCGROHEH4/0D1ocYk4HWT2SWEk3OB0ZyXkm8obGZkYWpiamxkbmlGWnC
	SuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY1dR7RBZeEvXRuX7kR3Wd/dxW0W+z
	962tfytTdvKBw5sHZ//oTJo5+Xrn83dTAqXmFD0Tvf1f/dmzjxecThhLuH3N7Xr7S/fv9r8M
	wqrlsoVVzgLaHdwHvqmoPg2y7l3gMCUhMJv3GcvqC14M3qf+BW2ucTPjStpjI5C9QaLnStsm
	uweZdivWKrEUZyQaajEXFScCACKx2uHaAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jAd30qOZAgzcfLC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h83i6fQ6i/2dHYwObB47Z91l99gz8SSbx4kZv1k8+rasYvSYPu8nk8fnTXIB
	bFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGco
	KZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDOWdL5jKdjDVtF1+idrA+N6
	1i5GTg4JAROJNxtuMULYYhIX7q1n62Lk4hASWMQo8e14OzNIQkjgF6PEk2ZDEJtNQE3iy5fD
	7F2MHBwiAvoSbS0aIPXMApsZJQ42bWIBqREWCJa4cfkL2FAWAVWJo58/s4HYvAKWElvuT4ay
	BSV+TL4HVs8soCWxfudxJghbXmLzmrfMEAcpSOw4+xpsjoiAnsTK02+gakQk9r14xziBUWAW
	klGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx/ozqR2MKxssDjEK
	cDAq8fAqtDQFCrEmlhVX5h5ilOBgVhLhdfsBFOJNSaysSi3Kjy8qzUktPsSYDPTpRGYp0eR8
	YBrKK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbGVcatLf93
	5yimZfDYPJuu9/tiyBupNxtyGbX9Zc6zbPmg5qLAvzxDcO+zrVMlzDVvt4jmHOw9c/T2fo2j
	C1ltDntn690oT13LzbJny0a3mMRtl7eLb+P6ftbzqWeDwD2jv7L2O8Sulpb6725o52BO7RDI
	aLe0lokwF7x4b9ZB9vC56rJxMx8osRRnJBpqMRcVJwIAYeSyPTkDAAA=
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
 drivers/rtc/rtc-nuc900.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
index f5dfb6e..90ca8aa 100644
--- a/drivers/rtc/rtc-nuc900.c
+++ b/drivers/rtc/rtc-nuc900.c
@@ -267,8 +267,6 @@ static int __init nuc900_rtc_probe(struct platform_device *pdev)
 
 static int __exit nuc900_rtc_remove(struct platform_device *pdev)
 {
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


