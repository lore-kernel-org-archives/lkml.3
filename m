Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932972Ab3CECEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 21:04:10 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:39365 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659Ab3CECEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 21:04:09 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-ef-513552977f29
From: Jingoo Han <jg1.han@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004b01ce1945$79486af0$6bd940d0$%han@samsung.com>
In-reply-to: <004b01ce1945$79486af0$6bd940d0$%han@samsung.com>
Subject: [PATCH 3/3] misc: ep93xx_pwm: use module_platform_driver_probe()
Date: Tue, 05 Mar 2013 11:04:07 +0900
Message-id: <004d01ce1945$b845c0e0$28d142a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ZRXktbgD8B1v7QgSgtGTX79fL8QAACLYQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zA93pQaaBBrunG1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MV/tXMRVM56g4s30uawNjE3sXIyeHhICJxJ2dP9ggbDGJC/fW
	A9lcHEICyxgl7nVtgCs6P+skC0RiEaPEv39dzBDObCaJeb8uMYFUsQmoSXz5chisQ0QgQqKl
	tZmxi5GDg1nAReLoNBGQsJCArUTLnR+MIDangJ3EqQ3TWEFsYQFPiQMHz4HFWQRUJWY1TQMb
	yQtUv2baanYIW1Dix+R7LCA2s4CWxOZtTawQtrzE5jVvmUFWSQioSzz6qwtxgZHE4U0LoMpF
	JPa9eMcIcrKEwCJ2ie0rn7FB7BKQ+Db5EAtEr6zEpgPMEP9KShxccYNlAqPELCSbZyHZPAvJ
	5llIVixgZFnFKJpakFxQnJReZKRXnJhbXJqXrpecn7uJERJZfTsYbx6wPsSYDLR+IrOUaHI+
	MDLzSuINjY1NzExMTcwtTc1NSRNWEueVvyQTKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoEx
	yTrHeVr22/WXb73dt1j4heq3XOa7T3L9npoubRdP0xAKu1bSsiPBftmJmTlmTkIzf09jFUmY
	cK5EYL3xuy634hsLCr8vfiNr8pSfUfuM91R9y4hTQQbCB4JSBM2YMvYdOvX90soHtjZ8ag4F
	F49YGc63vZBWwSf1W0d/bgj7Ky7G1tkX3fmUWIozEg21mIuKEwFlg7nmwgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgO70INNAgzdndS0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxqv9q5gKpnNUnNk+l7WB
	sYm9i5GTQ0LAROL8rJMsELaYxIV769m6GLk4hAQWMUr8+9fFDOHMZpKY9+sSE0gVm4CaxJcv
	h8G6RQQiJFpamxm7GDk4mAVcJI5OEwEJCwnYSrTc+cEIYnMK2Emc2jCNFcQWFvCUOHDwHFic
	RUBVYlbTNLCRvED1a6atZoewBSV+TL4HdhCzgJbE5m1NrBC2vMTmNW+ZQVZJCKhLPPqrC3GB
	kcThTQugykUk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXr
	JefnbmIEx+0zqR2MKxssDjEKcDAq8fAyHDUJFGJNLCuuzD3EKMHBrCTCe5/XNFCINyWxsiq1
	KD++qDQntfgQYzLQoxOZpUST84EpJa8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1Kz
	U1MLUotgtjBxcEo1MNaYb/BQsk5ao3a+7Z/XasWK7n0vDgu8uZ0xqct5SVrXq2rF79I3Hup+
	5l1edZUvb+t3h8Azwmeysqdzm9/uD6wz2tanctNkpm5f/5fM2/1pjIeWVS6Iclja27J28b7G
	kLILm2U7HtdXnyy3qDuxoW+1zaGopo+NHKLn41/EsR0xt93990TqfSWW4oxEQy3mouJEAOpu
	PxcfAwAA
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
 drivers/misc/ep93xx_pwm.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
index 16d7179..96787ec 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -365,18 +365,7 @@ static struct platform_driver ep93xx_pwm_driver = {
 	.remove		= __exit_p(ep93xx_pwm_remove),
 };
 
-static int __init ep93xx_pwm_init(void)
-{
-	return platform_driver_probe(&ep93xx_pwm_driver, ep93xx_pwm_probe);
-}
-
-static void __exit ep93xx_pwm_exit(void)
-{
-	platform_driver_unregister(&ep93xx_pwm_driver);
-}
-
-module_init(ep93xx_pwm_init);
-module_exit(ep93xx_pwm_exit);
+module_platform_driver_probe(ep93xx_pwm_driver, ep93xx_pwm_probe);
 
 MODULE_AUTHOR("Matthieu Crapet <mcrapet@gmail.com>, "
 	      "H Hartley Sweeten <hsweeten@visionengravers.com>");
-- 
1.7.2.5


