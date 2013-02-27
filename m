Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab3B0F5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 00:57:05 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:56271 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab3B0F5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 00:57:02 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-44-512da02d8d86
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jonghwa Lee'" <jonghwa3.lee@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/5] rtc: max77686: use module_platform_driver()
Date: Wed, 27 Feb 2013 14:57:00 +0900
Message-id: <008f01ce14af$4283cf90$c78b6eb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Ur0Jf3bJm/gOXS5uxDgC3uRXcVg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t8zY13dBbqBBq3NLBaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStj5Y6JzAUX2SsufDjD3sB4mq2LkZNDQsBEYuOfhVC2mMSFe+uB
	bC4OIYFljBLf/zSydzFygBW9vFsJUiMksIhRYtlFXoia2UwSG88tZQZJsAmoSXz5chisXkRA
	X6KtRQOkhllgJ6PEw9W3GUFqhAUcJFYcXMYEUsMioCpx5LUqiMkrYCtxY70bSAWvgKDEj8n3
	WEBsZgEtifU7jzNB2PISm9e8ZYa4Rl3i0V9diEV6EjPfWEJUiEjse/GOEWSphEA3u0TH7YNg
	Y1gEBCS+TT7EAtEqK7HpADPEs5ISB1fcYJnAKDYLyeJZSBbPQrJ4FpIVCxhZVjGKphYkFxQn
	pRcZ6xUn5haX5qXrJefnbmKEREj/Dsa7B6wPMSYDrZ/ILCWanA+MsLySeENjYxMzE1MTc0tT
	c1PShJXEeeUvyQQKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYJSOSFJ5XJwy4+ax1dm6Cl2S
	v7Pe8PUdUtJdyKKfsJnx4brNEmH5H07emrZox8RPy6cdzAndW/rupfQFfRVrtxn5Is8fXJJt
	Crq4OlDob/9OU/O8lapu27QeFrmcCnEKq4xa+ibo2Nq9Z35mCLdldydcUqplUVK1EfAX+XGS
	q+FAcvznbztyDyqxFGckGmoxFxUnAgAMg8LbpgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t9jAV2dBbqBBu2d1haXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY+WOicwFF9krLnw4w97A
	eJqti5GDQ0LAROLl3couRk4gU0ziwr31bCC2kMAiRollF3m7GLmA7NlMEhvPLWUGSbAJqEl8
	+XKYHaRXREBfoq1FA6SGWWAno8TD1bcZQWqEBRwkVhxcxgRSwyKgKnHktSqIyStgK3FjvRtI
	Ba+AoMSPyfdYQGxmAS2J9TuPM0HY8hKb17xlhrhMXeLRX12IRXoSM99YQlSISOx78Y5xAqPA
	LCSDZiEZNAvJoFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI6/Z9I7GFc1WBxi
	FOBgVOLhXXBJJ1CINbGsuDL3EKMEB7OSCO/HA0Ah3pTEyqrUovz4otKc1OJDjMlAX05klhJN
	zgemhrySeENjEzMjSyMzCyMTc3PShJXEeRlPPQkQEkhPLEnNTk0tSC2C2cLEwSnVwLj+6O2W
	E3u3LggR/z3TqvD+1qVXw8KPRIkfPWX+9vvcB3y2jY4xufmrpsu1/Lmecuul0O/ZZ6S5N01+
	J+zmz/rHTD/rYv+W3lf6ju/1S19dvFgjZn9tT7xr6LfZh5VKswP3Nu+cf/3biVURk6eseJsS
	nZUnJ3u1Ylnt7gtBy5zsonfOVzq3VoJHiaU4I9FQi7moOBEAAual+gMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-max77686.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index 6b1337f..a8e31fc 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -624,17 +624,7 @@ static struct platform_driver max77686_rtc_driver = {
 	.id_table	= rtc_id,
 };
 
-static int __init max77686_rtc_init(void)
-{
-	return platform_driver_register(&max77686_rtc_driver);
-}
-module_init(max77686_rtc_init);
-
-static void __exit max77686_rtc_exit(void)
-{
-	platform_driver_unregister(&max77686_rtc_driver);
-}
-module_exit(max77686_rtc_exit);
+module_platform_driver(max77686_rtc_driver);
 
 MODULE_DESCRIPTION("Maxim MAX77686 RTC driver");
 MODULE_AUTHOR("<woong.byun@samsung.com>");
-- 
1.7.2.5


