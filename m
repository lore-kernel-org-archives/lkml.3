Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab3CRJbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:31:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41525 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3CRJb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:31:29 -0400
X-AuditID: cbfee68e-b7f946d000001e37-69-5146def073c4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
In-reply-to: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
Subject: [PATCH 06/10] rtc: rtc-sh: switch to using SIMPLE_DEV_PM_OPS
Date: Mon, 18 Mar 2013 18:31:27 +0900
Message-id: <01bc01ce23bb$5d8c5ee0$18a51ca0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4juxtMJTZWEDnPSfOGR4wzonE6SAAADaxQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zQ90P99wCDU42c1ksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVcfLlCcaCS5wVp16dZm9gfMnexcjJISFgIjHjcx8LhC0mceHeerYuRi4OIYFljBJ7
	37xngik6s+kJO0RiOqPEgRc7oZxfjBLfLr0Ca2cTUJP48uUwUIKDQ0RAX6KtRQOkhlmgl1Hi
	TO9usHVCArYS864tZgSxOQXsJLb2T2IFsYUFXCVmPZvEDGKzCKhKnO+8zgZi8wLVz3iwnRnC
	FpT4Mfke2C5mAS2J9TuPM0HY8hKb17xlBtkrIaAu8eivLkhYRMBI4vWeI6wQJSIS+168YwS5
	R0LgEbtE55s3TBC7BCS+TT7EAtErK7HpADPEw5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZ
	VjGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmKExGrfDsabB6wPMSYDrZ/ILCWanA+M9bySeENj
	MyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MNbMndp2jy9m
	f1yU4G/HG4cb/+lvujEzsKDWqSD/1Y1LM6PSTi2J7XAScN25i6HjhNYm4zUVPpO/6mZ/13t2
	eP0BnpD0hiXL+ZeJebeyn9rhbs4U9ehmNrMgS/nsYoXzs9RmTNJPfMTmnSFsJfT0bLmxwMK7
	mYbvjpZnpqUeVOLdKTPlvWRethJLcUaioRZzUXEiAL5b4DLrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd0P99wCDd5cY7VYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePkyxOMBZc4K069Os3ewPiSvYuRk0NCwETi
	zKYnULaYxIV769m6GLk4hASmM0oceLGTHcL5xSjx7dIrFpAqNgE1iS9fDgMlODhEBPQl2lo0
	QGqYBXoZJc707gabJCRgKzHv2mJGEJtTwE5ia/8kVhBbWMBVYtazScwgNouAqsT5zutsIDYv
	UP2MB9uZIWxBiR+T74HtYhbQkli/8zgThC0vsXnNW2aQvRIC6hKP/uqChEUEjCRe7znCClEi
	IrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzgR
	PJPawbiyweIQowAHoxIP7471boFCrIllxZW5hxglOJiVRHgdbwOFeFMSK6tSi/Lji0pzUosP
	MSYDPTqRWUo0OR+YpPJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJ
	g1OqgVGvv6RxwauoVwd3V3sHvnCY/y1/2Zo5BzY5nL4yc8ZCY55NH36YTen5sFfYW5j1iKWx
	+KLW+jt5P93lDpitKz6yrpjX3anqtOLld5GCbNHM+7m331lScmGOVnfRyzvepj/jXaIFb6us
	0P1x3sNRxCB//myteVrHfm7q56metT5LPdGr5ZqI/mElluKMREMt5qLiRADkOQAPSAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to using SIMPLE_DEV_PM_OPS  macro to declare the driver's
pm_ops. It reduces code size. Also, CONFIG_PM_SLEEP is added to
prevent build warning when CONFIG_PM_SLEEP is not selected.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-sh.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index 5f47085..8d5bd2e 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -790,6 +790,7 @@ static void sh_rtc_set_irq_wake(struct device *dev, int enabled)
 	}
 }
 
+#ifdef CONFIG_PM_SLEEP
 static int sh_rtc_suspend(struct device *dev)
 {
 	if (device_may_wakeup(dev))
@@ -805,17 +806,15 @@ static int sh_rtc_resume(struct device *dev)
 
 	return 0;
 }
+#endif
 
-static const struct dev_pm_ops sh_rtc_dev_pm_ops = {
-	.suspend = sh_rtc_suspend,
-	.resume = sh_rtc_resume,
-};
+static SIMPLE_DEV_PM_OPS(sh_rtc_pm_ops, sh_rtc_suspend, sh_rtc_resume);
 
 static struct platform_driver sh_rtc_platform_driver = {
 	.driver		= {
 		.name	= DRV_NAME,
 		.owner	= THIS_MODULE,
-		.pm	= &sh_rtc_dev_pm_ops,
+		.pm	= &sh_rtc_pm_ops,
 	},
 	.remove		= __exit_p(sh_rtc_remove),
 };
-- 
1.7.2.5


