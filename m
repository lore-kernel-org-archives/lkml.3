Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab3ECGgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:36:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61381 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab3ECGgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:36:20 -0400
X-AuditID: cbfee691-b7fe56d000004b96-ee-51835ae316cf
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 32/42] rtc: rtc-sa1100: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:36:18 +0900
Message-id: <002e01ce47c8$84dfbdd0$8e9f3970$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyIJ4HRR+z2gxQtCwTJ/h8Nl6SA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zY93HUc2BBr82M1ksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVceKMakEnd8X29R/ZGhj/cXQxcnJICJhI7HwzmRnCFpO4cG89WxcjF4eQwDJGiU23
	f7LCFD2++IgdIrGIUeLA8nlMEM4vRom2qZfAqtgE1CS+fDkMVMXBISKgL9HWogFSwyzQzSjx
	qHku2AphgWCJWydmsoHYLAKqEqvW3QSzeQUsJZ6vOMwMYQtK/Jh8jwXEZhbQkli/8zgThC0v
	sXnNW6hTFSR2nH3NCGKLCOhJXJuykw2iRkRi34t3jCCLJQSOsUtM2dTLDrFMQOLb5EMsIMdJ
	CMhKbDoANUdS4uCKGywTGMVmIVk9C8nqWUhWz0KyYgEjyypG0dSC5ILipPQiU73ixNzi0rx0
	veT83E2MkNibuIPx/gHrQ4zJQOsnMkuJJucDYzevJN7Q2MzIwtTE1NjI3NKMNGElcV71FutA
	IYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzzJryMtOZJmfNH61j/hNN1LQ/8P/y+9eLufbdN
	bVlra38Y2v5pqj8VvY7v+uRJRa+SM2YVhtaFzei4kxa3wjPyx/L7Gy72q96ZcyFBIynr5P1L
	0o/3pPI1n2rQsfESYTvAuc943plPj5Ys2iaut2rvza37zQ7u3B4qMa/zdHmW09OFK5fOFjrQ
	q8RSnJFoqMVcVJwIAIrnIPvTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd1HUc2BBo8eWlssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHHijGpBJ3fF9vUf2RoY/3F0MXJySAiYSDy+
	+IgdwhaTuHBvPVsXIxeHkMAiRokDy+cxQTi/GCXapl5iBaliE1CT+PLlMFAHB4eIgL5EW4sG
	SA2zQDejxKPmucwgNcICwRK3TsxkA7FZBFQlVq27CWbzClhKPF9xmBnCFpT4MfkeC4jNLKAl
	sX7ncSYIW15i85q3zBAXKUjsOPuaEcQWEdCTuDZlJxtEjYjEvhfvGCcwCsxCMmoWklGzkIya
	haRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgyH4mvYNxVYPFIUYBDkYlHl6FlqZA
	IdbEsuLK3EOMEhzMSiK8bj+AQrwpiZVVqUX58UWlOanFhxiTgT6dyCwlmpwPTDp5JfGGxiZm
	RpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cC4UiPPRM7HM8Df2TLpU/VR
	tavhu01bvvBnyB4I6rkvyHZJ+1Gp2dMJO5ZeZP/5ZEb1dp3697MNCraI681RME955h54qvdF
	/Jqfmt1lH18eX/zs6s9A3l1O4vP+lssXH/jU8bmQW/eyc3bXMbPZe350Plxz/MfSj5MTpzxX
	7BOKUvkl8KBPWG6KEktxRqKhFnNRcSIAmndMbDADAAA=
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
 drivers/rtc/rtc-sa1100.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 0060560..0f7adeb 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -249,7 +249,7 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
 
 	ret = clk_prepare_enable(info->clk);
 	if (ret)
-		goto err_enable_clk;
+		return ret;
 	/*
 	 * According to the manual we should be able to let RTTR be zero
 	 * and then a default diviser for a 32.768KHz clock is used.
@@ -303,8 +303,6 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
 	return 0;
 err_dev:
 	clk_disable_unprepare(info->clk);
-err_enable_clk:
-	platform_set_drvdata(pdev, NULL);
 	return ret;
 }
 
@@ -312,10 +310,8 @@ static int sa1100_rtc_remove(struct platform_device *pdev)
 {
 	struct sa1100_rtc *info = platform_get_drvdata(pdev);
 
-	if (info) {
+	if (info)
 		clk_disable_unprepare(info->clk);
-		platform_set_drvdata(pdev, NULL);
-	}
 
 	return 0;
 }
-- 
1.7.2.5


