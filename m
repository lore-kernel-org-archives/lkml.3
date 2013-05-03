Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab3ECGfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:35:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64436 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab3ECGfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:35:44 -0400
X-AuditID: cbfee690-b7f136d000000fea-70-51835abf2858
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 30/42] rtc: rtc-pm8xxx: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:35:42 +0900
Message-id: <002c01ce47c8$6f518d90$4df4a8b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyG6VNXiUEr0zR8+SVFn0hQqhRA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zQ939Uc2BBhNbmS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKuH/0C3vBRY6KM4cOMzYwLmLvYuTkkBAwkTi7aC8bhC0mceHeeiCbi0NIYBmjREvX
	dmaYokXvlzFBJBYxShx984sdwvnFKHH20DYWkCo2ATWJL18OAyU4OEQE9CXaWjRAapgFuhkl
	HjXPBZskLBAs8XxfG9g6FgFViec3OsDqeQUsJRafSAUJ8woISvyYfA9sJLOAlsT6nceZIGx5
	ic1r3kIdpCCx4+xrRhBbREBP4t3eh8wQNSIS+168Y4SoOcUu0f0mB2KVgMS3yYdYQFZJCMhK
	bDoANUZS4uCKGywTGMVmIdk8C8nmWUg2z0KyYQEjyypG0dSC5ILipPQiE73ixNzi0rx0veT8
	3E2MkMibsIPx3gHrQ4zJQOsnMkuJJucDIzevJN7Q2MzIwtTE1NjI3NKMNGElcV71FutAIYH0
	xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYymgT/Pc37n37nN0v3AOZkK14np0Vf332Vk8FWfen6b
	lEyc516XhrDwPY1+DiWPDnE1qd1rKjmj3f1PTTStxKirf9v5WTOeiWu+8dN8UadybGLG4VpX
	wTPyMVeaFCZk3EyxMfpjduXhn6SgcybW835Mjqqe9Uv2Rrx94ArfnoTKC7edZlu3dymxFGck
	GmoxFxUnAgCEqfWp0gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd19Uc2BBlc22lgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHH/6Bf2goscFWcOHWZsYFzE3sXIySEhYCKx
	6P0yJghbTOLCvfVsXYxcHEICixgljr75xQ7h/GKUOHtoGwtIFZuAmsSXL4eBEhwcIgL6Em0t
	GiA1zALdjBKPmucyg9QICwRLPN/XxgZiswioSjy/0QFWzytgKbH4RCpImFdAUOLH5HtgI5kF
	tCTW7zzOBGHLS2xe85YZ4iAFiR1nXzOC2CICehLv9j5khqgRkdj34h3jBEaBWUhGzUIyahaS
	UbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzZz6R3MK5qsDjEKMDBqMTDq9DS
	FCjEmlhWXJl7iFGCg1lJhNftB1CINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84FJJ68k3tDY
	xMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZqakFqUUwW5g4OKUaGLcZ2x7Nmnb3qrfQznaT
	tRJ+5c5bqw0W3ln8+8K10qdHe61Sf4ZuWyrw+1vfCm/JezKRs3+vU7OcEB4ozPR3i5/VIc47
	zv8vN2xYZyrnr/dNYPaUO5/WtrsezeiQu7E4ZK9w1OVpC3ZMC5K4ljdbea2YbelHrQ2GSz48
	UNouf8LYbn3gmdVdv8KUWIozEg21mIuKEwHf6jkWMAMAAA==
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
 drivers/rtc/rtc-pm8xxx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index f1a6557..14ee860 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -480,7 +480,6 @@ static int pm8xxx_rtc_probe(struct platform_device *pdev)
 fail_req_irq:
 	rtc_device_unregister(rtc_dd->rtc);
 fail_rtc_enable:
-	platform_set_drvdata(pdev, NULL);
 	kfree(rtc_dd);
 	return rc;
 }
@@ -492,7 +491,6 @@ static int pm8xxx_rtc_remove(struct platform_device *pdev)
 	device_init_wakeup(&pdev->dev, 0);
 	free_irq(rtc_dd->rtc_alarm_irq, rtc_dd);
 	rtc_device_unregister(rtc_dd->rtc);
-	platform_set_drvdata(pdev, NULL);
 	kfree(rtc_dd);
 
 	return 0;
-- 
1.7.2.5


