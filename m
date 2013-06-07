Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab3FGBjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 21:39:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27432 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab3FGBjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 21:39:21 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-bb-51b139c82bf7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Shuah Khan'" <shuah.kh@samsung.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com, rpurdie@rpsys.net,
        FlorianSchandinat@gmx.de, plagnioj@jcrosoft.com, tomi.valkeinen@ti.com,
        rafael.j.wysocki@intel.com, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: add CONFIG_PM_SLEEP to suspend/resume functions
Date: Fri, 07 Jun 2013 10:39:20 +0900
Message-id: <000201ce631f$d4ad0d50$7e0727f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5jH8VQZVjkEXLOR6aHDdNliT5UcQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t8zfd0TlhsDDba8ULaYs34Nm8XfScfY
	LTpnXmO0uLzwEqvFib4PrBaXd81hs1j38AWTxeMVb9ktdu96ymrx5TOXxdefDhbr599ic+Dx
	+P1rEqPHzll32T0+fIzzWLznJZPHqwt3WDxOzPjN4rFn/g9Wj74tqxg9jt/YzuTxeZNcAFcU
	l01Kak5mWWqRvl0CV0bvtXfMBXO5KiZf/MnYwPiAo4uRk0NCwETi/bn37BC2mMSFe+vZuhi5
	OIQEljFKrO3aywRT1HL2AyNEYjqjxJYbjewQzi9Gib51KxlBqtgE1CS+fDkMlODgEBHQl2hr
	0QCpYRbYzSQx68hkJpC4sIC3xLW3FSDlLAKqErs+zGUFsXkFLCVunNnECGELSvyYfI8FxGYW
	0JJYv/M4E4QtL7F5zVtmiIMUJHacfQ1WLyKgJ7Gt4TgjRI2IxL4X7xghamZySPw5wQexS0Di
	2+RDLCAnSAjISmw6ADVGUuLgihssExjFZiHZPAvJ5llINs9CsmEBI8sqRtHUguSC4qT0IhO9
	4sTc4tK8dL3k/NxNjJBYn7CD8d4B60OMyUDrJzJLiSbnA1NFXkm8obGZkYWpiamxkbmlGWnC
	SuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoY6zefWvWs+oKYg+xbpQmOE7UnGWce
	YVp9pqpy94YIx/b1B28d75OfFVY4jTXu8HH/3JbdbffLvXlMrza3a3b90T3MoejjyJQxw3bJ
	zw7z3S9WTn7iGLzqhmPmuQ86bzMEm9mtnrdpb3Jfpyi8mee7x8EbbzxsOi5GTV7mc/HnBs3S
	L81MrIYySizFGYmGWsxFxYkALrMkdwsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsVy+t9jQd0TlhsDDc42yFvMWb+GzeLvpGPs
	Fp0zrzFaXF54idXiRN8HVovLu+awWax7+ILJ4vGKt+wWu3c9ZbX48pnL4utPB4v182+xOfB4
	/P41idFj56y77B4fPsZ5LN7zksnj1YU7LB4nZvxm8dgz/werR9+WVYwex29sZ/L4vEkugCuq
	gdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hsJYWy
	xJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWNG77V3zAVzuSomX/zJ2MD4gKOL
	kZNDQsBEouXsB0YIW0ziwr31bF2MXBxCAtMZJbbcaGSHcH4xSvStWwlWxSagJvHly2GgBAeH
	iIC+RFuLBkgNs8BuJolZRyYzgcSFBbwlrr2tAClnEVCV2PVhLiuIzStgKXHjzCZGCFtQ4sfk
	eywgNrOAlsT6nceZIGx5ic1r3jJDHKQgsePsa7B6EQE9iW0NxxkhakQk9r14xziBUWAWklGz
	kIyahWTULCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEp5JnUjsYVzZYHGIU4GBU
	4uH9uWpDoBBrYllxZe4hRgkOZiUR3lMaGwOFeFMSK6tSi/Lji0pzUosPMSYDfTqRWUo0OR+Y
	5vJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgdHrCFN6hMPR
	KFfezh17T59LtRWsid/wSiChwKn97uaP8zgKd5jEWpxcFCjNPtuoqrBVjS29I8qHnf/r4aXh
	Lxtzs7dzGiU9/Nh22vRsxMZZhyLnB03JO8W9t3xmkiibn4j59KyQl0v3vrfVk159Yq1tXxjv
	ElsH39/GxgqbzTZtvX3l17JaRyWW4oxEQy3mouJEAJUHVAFpAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_PM_SLEEP to suspend/resume functions to fix the following
build warning when CONFIG_PM_SLEEP is not selected. This is because
sleep PM callbacks defined by SIMPLE_DEV_PM_OPS are only used when
the CONFIG_PM_SLEEP is enabled.

drivers/video/backlight/backlight.c:211:12: warning: 'backlight_suspend' defined but not used [-Wunused-function]
drivers/video/backlight/backlight.c:225:12: warning: 'backlight_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/backlight.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index cedbcbe..750807c 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -208,6 +208,7 @@ static ssize_t backlight_show_actual_brightness(struct device *dev,
 
 static struct class *backlight_class;
 
+#ifdef CONFIG_PM_SLEEP
 static int backlight_suspend(struct device *dev)
 {
 	struct backlight_device *bd = to_backlight_device(dev);
@@ -235,6 +236,7 @@ static int backlight_resume(struct device *dev)
 
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(backlight_class_dev_pm_ops, backlight_suspend,
 			 backlight_resume);
-- 
1.7.10.4


