Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3CFHwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:52:10 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:52766 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755186Ab3CFHwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:52:07 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-1e-5136f5a66ca7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 14/30] rtc: rtc-max8907: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:52:05 +0900
Message-id: <008801ce1a3f$7f1641f0$7d42c5d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAKdHw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zA91lX80CDdreilgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV8XbWDMaCG5wVLdszGhjbOboYOTkkBEwkbnx4zgZhi0lcuLceyObiEBJYxijRcfU3
	axcjB1jRybV+EPHpjBJ/Xv9ggnB+MUqs3tbGCtLNJqAm8eXLYXaQBhEBfYm2Fg2QGmaBXkaJ
	M727weJCArYSPfN4QMo5Bewkpkx8zA5iCwt4STT37WIGsVkEVCX+btkINpIXqPzi+Q42CFtQ
	4sfkeywgNrOAlsT6nceZIGx5ic1r3jJD3Kku8eivLkhYRMBI4sO+DYwQJSIS+168YwQ5R0Lg
	HrvElznnoHYJSHybfIgFoldWYtMBZkg4SEocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSia
	WpBcUJyUXmSsV5yYW1yal66XnJ+7iRESpf07GO8esD7EmAy0fiKzlGhyPjDK80riDY2NTcxM
	TE3MLU3NTUkTVhLnlb8kEygkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcd2O8MSVy7gjZwYv
	8D+lJLsvdc3szm9bDkd13qyLYn6X+f2e/UWBu7Ornc8/epx/7QC/1Y9H+sb94fN/dbsL3V32
	4u0FO8aFysV7g1Z4lUdIFO8/fFbXSlox381nyUlvJUWntzr7S+Wmvuj3S3va/Lnr3S0HMbWA
	9FePrPsjs+ou7+e6MPHifyWW4oxEQy3mouJEANLT+GHoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd1lX80CDQ5dErBYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePtrBmMBTc4K1q2ZzQwtnN0MXJwSAiYSJxc
	69fFyAlkiklcuLeerYuRi0NIYDqjxJ/XP5ggnF+MEqu3tbGCVLEJqEl8+XKYHaRZREBfoq1F
	A6SGWaCXUeJM726wuJCArUTPPB6Qck4BO4kpEx+zg9jCAl4SzX27mEFsFgFVib9bNoKN5AUq
	v3i+gw3CFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zBA3q0s8+qsLEhYRMJL4sG8DI0SJiMS+
	F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOAU8Exq
	B+PKBotDjAIcjEo8vBZKZoFCrIllxZW5hxglOJiVRHi5zgCFeFMSK6tSi/Lji0pzUosPMSYD
	PTqRWUo0OR+YnvJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRASCA9sSQ1OzW1ILUIZgsTB6dU
	A6Ndm6udw129ykVbK04Wx9XlXokKrmSI319/d23xegnPc7cPPex992yiO/dO05jmEIbJO+UY
	vjut8tglxiBmMnev2aor0kGzzk+/G2eXVnbjk+f7Kde/lu9JulqdqXx9krTkm3cdt5LFbGbq
	n/wtUBQQfuCW1H+WlzbJWXNFIvcEazwS2OtWEq7EUpyRaKjFXFScCABvZinrRQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- used 'struct device *dev' as the first argument

 drivers/rtc/rtc-max8907.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-max8907.c b/drivers/rtc/rtc-max8907.c
index 31ca8fa..9d62cdb 100644
--- a/drivers/rtc/rtc-max8907.c
+++ b/drivers/rtc/rtc-max8907.c
@@ -190,7 +190,7 @@ static int max8907_rtc_probe(struct platform_device *pdev)
 	rtc->max8907 = max8907;
 	rtc->regmap = max8907->regmap_rtc;
 
-	rtc->rtc_dev = rtc_device_register("max8907-rtc", &pdev->dev,
+	rtc->rtc_dev = devm_rtc_device_register(&pdev->dev, "max8907-rtc",
 					&max8907_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc_dev)) {
 		ret = PTR_ERR(rtc->rtc_dev);
@@ -217,16 +217,11 @@ static int max8907_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 err_unregister:
-	rtc_device_unregister(rtc->rtc_dev);
 	return ret;
 }
 
 static int max8907_rtc_remove(struct platform_device *pdev)
 {
-	struct max8907_rtc *rtc = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(rtc->rtc_dev);
-
 	return 0;
 }
 
-- 
1.7.2.5


