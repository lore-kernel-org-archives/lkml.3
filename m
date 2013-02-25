Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab3BYIPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 03:15:50 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:62877 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab3BYIPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 03:15:49 -0500
X-AuditID: cbfee690-b7f6b6d000004563-c4-512b1db49f10
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001301ce1330$05b74d60$1125e820$%han@samsung.com>
In-reply-to: <001301ce1330$05b74d60$1125e820$%han@samsung.com>
Subject: [PATCH 2/2] pwm_backlight: remove unnecessary ifdefs
Date: Mon, 25 Feb 2013 17:15:47 +0900
Message-id: <001401ce1330$50d64260$f282c720$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4TMAWY/k5Gl7s5To252aayYJP61wAABW9Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zQ90tstqBBkdusFpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MuRcfsBZ85qqY+u08ewNjM2cXIweHhICJxNUNtl2MnECmmMSF
	e+vZuhi5OIQEljFKTLl3gBkiYSIx/8wlZojEIkaJljW7wBJCArOZJG702oDYbAJqEl++HGYH
	GSoioC/R1qIBUs8ssI5R4veP36wQ9bYSxz/fYgSxOQXsJGadWMYGYgsDxecenQFmswioSjR3
	HGEBsXmB4vvnzGCCsAUlfky+BxZnFtCSWL/zOBOELS+xec1bZohn1CUe/dUFCYsIGEnsf3QM
	qlxEYt+Ld4wQvyxil/g62QRilYDEt8mHWCBaZSU2wbwrKXFwxQ2WCYwSs5AsnoVk8Swki2ch
	2bCAkWUVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRkhUTdjBeO+A9SHGZKD1E5mlRJPzgVGZ
	VxJvaGxsYmZiamJuaWpuSpqwkjiv/CWZQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MXtJW
	RUuf7OfyfL98ydn/XBc5jM5Kquxp9FdKTZpWsOKFAePPnHyeyPOXJm8sDc4++Kl55sOVl/gO
	LLylodbSn/arPGKjyMtNLmJVc/XP7yn/JWl3jMnwkfThm85nwiaKuMvqKfxcUDsh/0qM3D39
	D5anGZ+wBp8Pe9by0HyxRMLpm09sqt8KKrEUZyQaajEXFScCAEpdIPPAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO5mWe1Ag423DCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxtyLD1gLPnNVTP12nr2B
	sZmzi5GTQ0LARGL+mUvMELaYxIV769m6GLk4hAQWMUq0rNkFlhASmM0kcaPXBsRmE1CT+PLl
	MHsXIweHiIC+RFuLBkg9s8A6RonfP36zQtTbShz/fIsRxOYUsJOYdWIZG4gtDBSfe3QGmM0i
	oCrR3HGEBcTmBYrvnzODCcIWlPgx+R5YnFlAS2L9zuNMELa8xOY1b5lB9koIqEs8+qsLEhYR
	MJLY/+gYVLmIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0
	veT83E2M4Lh9Jr2DcVWDxSFGAQ5GJR7ehpVagUKsiWXFlbmHGCU4mJVEeDVDgUK8KYmVValF
	+fFFpTmpxYcYk4EencgsJZqcD0wpeSXxhsYmZkaWRmYWRibm5qQJK4nzMp56EiAkkJ5Ykpqd
	mlqQWgSzhYmDU6qBcVq++xnXhEduL45tvrqUeZ4B29Z1uewXN+VUbJxpc8FLIu39yrLawzuc
	V26LdHzmw31o4Zfl0ZFF2p4NW790Kq1oajnb+/XuN4lWC5OQzuufjrsXWop8Y9T3NL2j5b3M
	59kV1jfihow+UQnTpD+0CnhHrhPI+zZT9ZgDo+SJ7EDht00nnqe/U2Ipzkg01GIuKk4EADmB
	yYQfAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the macro such as SIMPLE_DEV_PM_OPS is used, there is
no need to use '#ifdef CONFIG_PM' to prevent build error. Thus,
this patch removes unnecessary ifdefs.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/video/backlight/pwm_bl.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index fa00304..1fea627 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -274,7 +274,7 @@ static int pwm_backlight_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int pwm_backlight_suspend(struct device *dev)
 {
 	struct backlight_device *bl = dev_get_drvdata(dev);
@@ -296,19 +296,16 @@ static int pwm_backlight_resume(struct device *dev)
 	backlight_update_status(bl);
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(pwm_backlight_pm_ops, pwm_backlight_suspend,
 			 pwm_backlight_resume);
 
-#endif
-
 static struct platform_driver pwm_backlight_driver = {
 	.driver		= {
 		.name		= "pwm-backlight",
 		.owner		= THIS_MODULE,
-#ifdef CONFIG_PM
 		.pm		= &pwm_backlight_pm_ops,
-#endif
 		.of_match_table	= of_match_ptr(pwm_backlight_of_match),
 	},
 	.probe		= pwm_backlight_probe,
-- 
1.7.2.5


