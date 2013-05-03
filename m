Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab3ECGgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:36:44 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22767 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab3ECGgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:36:42 -0400
X-AuditID: cbfee68f-b7f066d000003683-1e-51835af973c6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 33/42] rtc: rtc-sh: remove unnecessary platform_set_drvdata()
Date: Fri, 03 May 2013 15:36:41 +0900
Message-id: <002f01ce47c8$9265a7d0$b730f770$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyJFAZVbkzZZ+T5e+yG/6H4c/KQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zA92fUc2BBh+mqVksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV0fT0N1vBDLaKtfMnszcw9rJ2MXJySAiYSPze/5cdwhaTuHBvPVsXIxeHkMAyRolt
	yz8zwxStm9MHZgsJLGKU+H5DCqLoF6PEy9YfjCAJNgE1iS9fDgNN4uAQEdCXaGvRAKlhFuhm
	lHjUPBesWVjAV2JJ3yGwbSwCqhJ7Jp8Fi/MKWEpM2fmADcIWlPgx+R4LiM0soCWxfudxJghb
	XmLzmrdQBylI7Dj7GmyviICexNn9bxkhakQk9r14xwhRc4hdYu0nX4hdAhLfJh9iAblNQkBW
	YtMBqDGSEgdX3GCZwCg2C8nmWUg2z0KyeRaSDQsYWVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn
	525ihERe/w7GuwesDzEmA62fyCwlmpwPjNy8knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTS
	E0tSs1NTC1KL4otKc1KLDzEycXBKNTAqrb29MO+x6ObU2JWds/WD9+90L6gSEWbxXLs7e1Xd
	tTWHn119V77r7JTmLwd/fntw1jPk1Nen6oqnw7tFxMJDFxn5PuLgNAlMfmSV3nHY0Pz54dnP
	shX+xzc9ela+ahPT+6UB88+dep19NMD9yWxZT9/8Yo/nX1Zs/+0tpKvWlMh05XXb/rN8SizF
	GYmGWsxFxYkAdSzqh9ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jAd2fUc2BBrceKVksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNH09DdbwQy2irXzJ7M3MPaydjFyckgImEis
	m9PHDGGLSVy4t54NxBYSWMQo8f2GVBcjF5D9i1HiZesPRpAEm4CaxJcvh9m7GDk4RAT0Jdpa
	NEBqmAW6GSUeNc8FGyQs4CuxpO8QO4jNIqAqsWfyWbA4r4ClxJSdD9ggbEGJH5PvsYDYzAJa
	Eut3HmeCsOUlNq95C3WQgsSOs6/B9ooI6Emc3f+WEaJGRGLfi3eMExgFZiEZNQvJqFlIRs1C
	0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBkP5PewbiqweIQowAHoxIPr0JLU6AQ
	a2JZcWXuIUYJDmYlEV63H0Ah3pTEyqrUovz4otKc1OJDjMlAn05klhJNzgcmnbySeENjEzMj
	SyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYCzUibm8t8/R8+yMFzbPvwgu
	mbtircQJj3czVtiFv/+sN7fqSNOWPYqiunWsM+NE63mSTvv+Z/m0xzM+eJfpnC+a9taVE39q
	p20y757o6N/kJ5eSq1x2YLWSXe2Zp7L+U7+FlEvY9YVZeRjpzPwQ9FD0ZdYFxkPzuy8qb/Hl
	7zNj9D7knfb4ihJLcUaioRZzUXEiAI/0e1IwAwAA
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
 drivers/rtc/rtc-sh.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index 8d5bd2e..cb2f839 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -770,8 +770,6 @@ static int __exit sh_rtc_remove(struct platform_device *pdev)
 	clk_disable(rtc->clk);
 	clk_put(rtc->clk);
 
-	platform_set_drvdata(pdev, NULL);
-
 	kfree(rtc);
 
 	return 0;
-- 
1.7.2.5


