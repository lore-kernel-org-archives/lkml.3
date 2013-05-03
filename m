Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762735Ab3ECGaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:30:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21574 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762633Ab3ECGaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:30:21 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-e1-51835976ead2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 16/42] rtc: rtc-ds1302: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:30:13 +0900
Message-id: <001e01ce47c7$ab443100$01cc9300$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hx6qPpOCw0D2RTBakYxI8UK3Glg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zI92yyOZAg6MnWS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKeLHuGUvBHraKAx/XMjcwrmftYuTgkBAwkeh/kNDFyAlkiklcuLeerYuRi0NIYBmj
	xI4dH1ggEiYSz58cYoZILGKUuLbhFCOE84tRYvPbvWwgVWwCahJfvhxmB5kqIqAv0daiAVLD
	LNDNKPGoeS4zSI2wQLDEjq13mUBsFgFViZe/3jGC2LwClhJXOjZC2YISPybfA9vMLKAlsX7n
	cSYIW15i85q3zBAXKUjsOPsarF5EQE/iT9c3qHoRiX0vIGZKCBxjl1jVpA6xS0Di2+RDLBAf
	y0psOgA1RlLi4IobLBMYxWYh2TwLyeZZSDbPQrJhASPLKkbR1ILkguKk9CIjveLE3OLSvHS9
	5PzcTYyQyOvbwXjzgPUhxmSg9ROZpUST84GRm1cSb2hsZmRhamJqbGRuaUaasJI4r1qLdaCQ
	QHpiSWp2ampBalF8UWlOavEhRiYOTqkGxtmyrbOYa5IfdvY2vWbuFnqueU7BwXdR6Vq+vq97
	zNZYhIvZae+5tmjOwbN7pjw2WlLqde7dZtVW6YSIx6UR4psS1VcsZBI83rWh/NWSBOt5X+d9
	vZi2o7C66qVSncUCYdur3/lVU1/nZKncf5Q88fXBqf3f/0d58r7uMGpPMnJ/rCT2ecL5o0os
	xRmJhlrMRcWJAIRxop7SAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd2yyOZAg2MPGC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzHix7hlLwR62igMf1zI3MK5n7WLk5JAQMJF4
	/uQQM4QtJnHh3nq2LkYuDiGBRYwS1zacYoRwfjFKbH67lw2kik1ATeLLl8PsXYwcHCIC+hJt
	LRogNcwC3YwSj5rngk0SFgiW2LH1LhOIzSKgKvHy1ztGEJtXwFLiSsdGKFtQ4sfkeywgNrOA
	lsT6nceZIGx5ic1r3kJdpCCx4+xrsHoRAT2JP13foOpFJPa9eMc4gVFgFpJRs5CMmoVk1Cwk
	LQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMf2M+kdjKsaLA4xCnAwKvHwKrQ0BQqx
	JpYVV+YeYpTgYFYS4XX7ARTiTUmsrEotyo8vKs1JLT7EmAz06URmKdHkfGDaySuJNzQ2MTOy
	NDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGRuHe5VcePHt/zOy516XJPl9L
	zRpPLb0yKVT2lvRZO7kjRR+YVUTYp+gviZVKedTL93JT8rKy24rX+i69kBHMbdbdedy1ZSW7
	QlB+4t8jO32XH6u77f2Ydea8zuSZKneWJL9a8/a5zOmb5+wNNzu1yk53Vvd2adWcymR66N9U
	z7TO78t3KXv+klBiKc5INNRiLipOBADH0S/EMQMAAA==
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
 drivers/rtc/rtc-ds1302.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ds1302.c b/drivers/rtc/rtc-ds1302.c
index d139543..1f8ee63 100644
--- a/drivers/rtc/rtc-ds1302.c
+++ b/drivers/rtc/rtc-ds1302.c
@@ -236,8 +236,6 @@ static int __init ds1302_rtc_probe(struct platform_device *pdev)
 
 static int __exit ds1302_rtc_remove(struct platform_device *pdev)
 {
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


