Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762848Ab3ECGcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:32:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63837 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762770Ab3ECGct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:32:49 -0400
X-AuditID: cbfee68d-b7f016d000007930-c2-51835a10b3e2
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 25/42] rtc: rtc-mc13xxx: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:32:48 +0900
Message-id: <002701ce47c8$075279c0$15f76d40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyAQguWd+DFTFRUWD65GfPi5/Ww==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zA12BqOZAg9frhSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK+LHGruAYe8W8OysZGxhnsnUxcnJICJhI9J7vZIewxSQu3FsPFOfiEBJYxiixcG4P
	C0zRpWm9rBCJRYwS+68/g3J+MUrsvfIBrIpNQE3iy5fDQKM4OEQE9CXaWjRAapgFuhklHjXP
	ZQaJCwuESPyZxwJisgioSnSuEwLp5BWwlPi59zALhC0o8WPyPTCbWUBLYv3O40wQtrzE5jVv
	mSHuUZDYcfY1I4gtIqAncWHOD2aIGhGJfS/eMYKslRA4xC6x7dVOVpAEi4CAxLfJh8D2SgjI
	Smw6ADVHUuLgihssExjFZiFZPQvJ6llIVs9CsmIBI8sqRtHUguSC4qT0IkO94sTc4tK8dL3k
	/NxNjJC4693BePuA9SHGZKD1E5mlRJPzgXGbVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBA
	emJJanZqakFqUXxRaU5q8SFGJg5OqQbGPbzFZfuKfs+avezOj3euW3Oy283Fv88VnsavW6F6
	Ys31ryHfI1lC0k/u3H+M+fJ2LQ79oH1XXc+E1y+avCdPdmuH0Pkn76XEm87PqxVKmC3GcGX3
	0iCRc/yHBBY57jFtnc+uaeDLc16ubPZy07A2neQtf5j2fHi/YKeY1RHxtVUv50RN3PG/RYml
	OCPRUIu5qDgRAOZ/pt/RAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAV2BqOZAg6Vn+CyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzPixxq7gGHvFvDsrGRsYZ7J1MXJySAiYSFya
	1ssKYYtJXLi3HijOxSEksIhRYv/1Z6wQzi9Gib1XPrCAVLEJqEl8+XKYvYuRg0NEQF+irUUD
	pIZZoJtR4lHzXGaQuLBAiMSfeSwgJouAqkTnOiGQTl4BS4mfew+zQNiCEj8m3wOzmQW0JNbv
	PM4EYctLbF7zlhniHgWJHWdfM4LYIgJ6Ehfm/GCGqBGR2PfiHeMERoFZSEbNQjJqFpJRs5C0
	LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHNXPpHcwrmqwOMQowMGoxMOr0NIUKMSa
	WFZcmXuIUYKDWUmE1+0HUIg3JbGyKrUoP76oNCe1+BBjMtCjE5mlRJPzgQknryTe0NjEzMjS
	yMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYtSZsM1krVOzPde96y9eleuu6
	GP9sNz5l4ZmfGGl0TnaC6fe1FqeSGaYlpan9NNvw8NMec/7qyoyAorx1de925VzoWODsWuUb
	fFtq38u3K54unT7NlLuk597FS+cr0vh4n2fZNEa2FrDPuxEp8ePN5EevHfYU3pb44xkwM87/
	+/rJ0861mq47qcRSnJFoqMVcVJwIAEeEDdUuAwAA
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
 drivers/rtc/rtc-mc13xxx.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index 7a8ed27..77ea989 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -370,8 +370,6 @@ err_reset_irq_status:
 err_reset_irq_request:
 
 		mc13xxx_unlock(mc13xxx);
-
-		platform_set_drvdata(pdev, NULL);
 	}
 
 	return ret;
@@ -389,8 +387,6 @@ static int __exit mc13xxx_rtc_remove(struct platform_device *pdev)
 
 	mc13xxx_unlock(priv->mc13xxx);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


