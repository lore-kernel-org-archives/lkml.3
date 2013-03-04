Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab3CDHZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:25:55 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:63235 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab3CDHZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:25:54 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-c4-51344c81872e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: atmel-pwm-bl: use module_platform_driver_probe()
Date: Mon, 04 Mar 2013 16:25:52 +0900
Message-id: <013701ce18a9$809c0010$81d40030$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4YqYB/U8SWbcv/QWi0MdA0haaBzQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t8zfd1GH5NAg8O32Cwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGneZVbAVfOSq+H9/I1MD4mr2LkZNDQsBEYnrvLWYIW0ziwr31
	bCC2kMAyRonn3RowNSf3LgCKcwHFFzFKTFtxkhnCmc0kMev4FLBuNgE1iS9fDgNN5eAQEdCX
	aGsBa2YWKJXY+uA9C4gtLOAj8WThHLDFLAKqEodbXrKC2LwCthK/p+xkgrAFJX5MvscC0asl
	sX7ncSYIW15i85q3zCDjJQTUJR791QUJiwjoSWzcNIkRokREYt+Ld4wgp0kItLNLnFj2iRli
	l4DEt8mHWCB6ZSU2HYD6V1Li4IobLBMYxWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CJT
	veLE3OLSvHS95PzcTYyQOJm4g/H+AetDjMlA6ycyS4km5wPjLK8k3tDY2MTMxNTE3NLU3JQ0
	YSVxXvlLMoFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGHdbBnedq1jy5P+DG4/yis992vpU
	cnpKw7KLe+vm5Ct31FdFzRQ2uRkj6/cx+67UQnMJbj7bSIVHunJxb0PEWf5mnmTzvcAQUXFr
	5pVZrUyRklGPM94fOr2Ru2J5+K/mxXq+7vwqjnMuxx3YvKjzVu5lpefMJ459LbLjYxJ3MvI6
	+jL8xZ94SSWW4oxEQy3mouJEAH868s+pAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAd1GH5NAg037mCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxp3mVWwFXzkqvh/fyNTA
	+Jq9i5GTQ0LAROLk3gVsELaYxIV764FsLg4hgUWMEtNWnGSGcGYzScw6PoUZpIpNQE3iy5fD
	QN0cHCIC+hJtLRogYWaBUomtD96zgNjCAj4STxbOAVvAIqAqcbjlJSuIzStgK/F7yk4mCFtQ
	4sfkeywQvVoS63ceZ4Kw5SU2r3nLDDJeQkBd4tFfXZCwiICexMZNkxghSkQk9r14xziBUWAW
	kkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEx+EzqR2MKxssDjEK
	cDAq8fAKfDIOFGJNLCuuzD3EKMHBrCTCWyZhEijEm5JYWZValB9fVJqTWnyIMRno0YnMUqLJ
	+cAUkVcSb2hsYmZkaWRmYWRibk6asJI4L+OpJwFCAumJJanZqakFqUUwW5g4OKUaGGf07zVr
	v/lfr+7frW6J5T2Nqe1XpD8GbLRWfruG4/UUwdvdSzqcFvIrcJq56P26Hq68xTfYK+fCD9tJ
	85ffTF3+03Nb4fxXZ8x+bAmpUPFOCzt+18fZ73vH1quM9W/DLh2fyxQmWXDzI2dj9I5HyWK/
	bFZGJs45M+lV0msrofTu+JBQ/Zsm+5RYijMSDbWYi4oTAWRffzEHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses module_platform_driver_probe() macro which makes
the code smaller and simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/atmel-pwm-bl.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/video/backlight/atmel-pwm-bl.c b/drivers/video/backlight/atmel-pwm-bl.c
index de5e5e7..20b330d 100644
--- a/drivers/video/backlight/atmel-pwm-bl.c
+++ b/drivers/video/backlight/atmel-pwm-bl.c
@@ -225,17 +225,7 @@ static struct platform_driver atmel_pwm_bl_driver = {
 	.remove = __exit_p(atmel_pwm_bl_remove),
 };
 
-static int __init atmel_pwm_bl_init(void)
-{
-	return platform_driver_probe(&atmel_pwm_bl_driver, atmel_pwm_bl_probe);
-}
-module_init(atmel_pwm_bl_init);
-
-static void __exit atmel_pwm_bl_exit(void)
-{
-	platform_driver_unregister(&atmel_pwm_bl_driver);
-}
-module_exit(atmel_pwm_bl_exit);
+module_platform_driver_probe(atmel_pwm_bl_driver, atmel_pwm_bl_probe);
 
 MODULE_AUTHOR("Hans-Christian egtvedt <hans-christian.egtvedt@atmel.com>");
 MODULE_DESCRIPTION("Atmel PWM backlight driver");
-- 
1.7.2.5


