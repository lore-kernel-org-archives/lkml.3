Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276Ab3ECGiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:38:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22801 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab3ECGg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:36:58 -0400
X-AuditID: cbfee68d-b7f016d000007930-72-51835b09e024
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 34/42] rtc: rtc-spear: remove unnecessary platform_set_drvdata()
Date: Fri, 03 May 2013 15:36:57 +0900
Message-id: <003001ce47c8$9ba8df10$d2fa9d30$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyJsS7AiXyKzES+K0mldvujGzhA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zfV3O6OZAg5aZXBZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBldO08wFywlq3i6u3jLA2MS1m7GDk4JARMJK48Culi5AQyxSQu3FvPBmILCSxjlDiy
	MBIibiKxZ9Zs9i5GLqD4dEaJRYf/skE4vxglDp/YygpSxSagJvHly2F2kKEiAvoSbS0aIDXM
	At2MEo+a5zKD1AgLBEh0zH8EVs8ioCrxZu9mRhCbV8BS4uynWywQtqDEj8n3wGxmAS2J9TuP
	M0HY8hKb17xlhrhIQWLH2deMELv0JF70uUOUiEjse/GOEWSvhMAhdokHf3ugdglIfJt8iAXi
	YVmJTQegxkhKHFxxg2UCo9gsJJtnIdk8C8nmWUhWLGBkWcUomlqQXFCclF5kqFecmFtcmpeu
	l5yfu4kREne9OxhvH7A+xJgMtH4is5Rocj4wbvNK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4U
	EkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwGgo9GO/62ozu4t/Vm84N2H+KZc3q+YzTFhxrPm7
	wv4DHJfSHZQulogaKyTtP9z84KD0PqYT1178uNPXqCytOL11k+9798U3XD38RG3Cuus2ub3t
	3Zv3y7xGpH/9t+/JxrV1bZ3ZmVNsHap2yRlM6GTjuz8lka1w4aPpEi4t9acjT67/t27O6a9K
	LMUZiYZazEXFiQD2VpFZ0QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQV3O6OZAg3272CyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzOjaeYC5YC1bxdXbx1kaGJeydjFyckgImEjs
	mTWbHcIWk7hwbz1bFyMXh5DAdEaJRYf/Qjm/GCUOn9gK1sEmoCbx5cthoA4ODhEBfYm2Fg2Q
	GmaBbkaJR81zmUFqhAUCJDrmPwKrZxFQlXizdzMjiM0rYClx9tMtFghbUOLH5HtgNrOAlsT6
	nceZIGx5ic1r3jJDXKQgsePsa0aIXXoSL/rcIUpEJPa9eMc4gVFgFpJJs5BMmoVk0iwkLQsY
	WVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBEf2M6kdjCsbLA4xCnAwKvHwKrQ0BQqxJpYV
	V+YeYpTgYFYS4XX7ARTiTUmsrEotyo8vKs1JLT7EmAz06ERmKdHkfGDSySuJNzQ2MTOyNDKz
	MDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGRtH+zJrDad0dzFs+yEvwWoklzJm6
	+yrXzkWlev/fbna8yfnoVqSB7OykJ1siX5gwFe6XUN9ldka89WWe/pPvX0/vWXv+4jUWT4aS
	VX+17RQan8x0+nWHRZslu5Hf8sO+TqEX+ybsFHF/mbh4cXvq4Xu3v17I53qWxrBeWKpi1pr9
	ew0OXy4rvqTEUpyRaKjFXFScCAADywUYMAMAAA==
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
 drivers/rtc/rtc-spear.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index 574359c..c492cf0 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -417,7 +417,6 @@ static int spear_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 err_disable_clock:
-	platform_set_drvdata(pdev, NULL);
 	clk_disable_unprepare(config->clk);
 
 	return status;
-- 
1.7.2.5


