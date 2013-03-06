Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab3CFFeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:34:36 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26058 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3CFFec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:34:32 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-d8-5136d5689120
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 22/30] rtc: rtc-spear: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:34:31 +0900
Message-id: <005801ce1a2c$4750bd80$d5f23880$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAQJvw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t8zI92Mq2aBBtfmMVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mj+t/shUs4qzYN1OpgfETexcjB4eEgInE3odpXYycQKaYxIV7
	69m6GLk4hASWMUo03lnNBpEwkbhwZi8jiC0ksIhR4vIab4ii2UwSx170s4Mk2ATUJL58OQw2
	VERAX6KtRQOkhlmgl1HiTO9udohmW4mr3auYQWxOATuJ5Y9nsYDUCwu4ShxoqQYJswioSnRc
	XwW2lxeo/MThySwQtqDEj8n3wGxmAS2J9TuPM0HY8hKb17xlhvhFXeLRX12QsIiAkcTexw3s
	ECUiEvtevGMEOUdCYBG7xMqLn5ghdglIfJt8iAWiV1Zi0wFmiHclJQ6uuMEygVFiFpLNs5Bs
	noVk8ywkKxYwsqxiFE0tSC4oTkovMtUrTswtLs1L10vOz93ECImpiTsY7x+wPsSYDLR+IrOU
	aHI+MCbzSuINjY1NzExMTcwtTc1NSRNWEueVvyQTKCSQnliSmp2aWpBaFF9UmpNafIiRiYNT
	qoGxjnsm75mcIt545X9GS558EH199M1VnxWLwsq6e5kMHsb7/Pj41cl3Gd/6Q5um8slsaJu3
	4/pGt/a6uS33HTT3NTw+b5Ql5j0/+wuXpXvXQTNZjW0XlK4fUTM9cmG+6w3nBbLxfmYLQua5
	X903ucnsQbXvzEBZ9dc3qn5zaQhsl+R6+/Hd9S+JSizFGYmGWsxFxYkABTtM9b8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgG76VbNAgxu/rCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxsf1P9kKFnFW7Jup1MD4
	ib2LkZNDQsBE4sKZvYwQtpjEhXvr2UBsIYFFjBKX13h3MXIB2bOZJI696AdrYBNQk/jy5TCQ
	zcEhIqAv0daiAVLDLNDLKHGmdzc7RLOtxNXuVcwgNqeAncTyx7NYQOqFBVwlDrRUg4RZBFQl
	Oq6vAtvFC1R+4vBkFghbUOLH5HtgNrOAlsT6nceZIGx5ic1r3jKDjJEQUJd49FcXJCwiYCSx
	93EDO0SJiMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k
	/NxNjOCYfSa9g3FVg8UhRgEORiUe3gkqZoFCrIllxZW5hxglOJiVRHi5zgCFeFMSK6tSi/Lj
	i0pzUosPMSYDPTqRWUo0OR+YTvJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRASCA9sSQ1OzW1
	ILUIZgsTB6dUA+OCVwk81yY3SpwJCglkOT+TIXPJ+qo5K9IT1T9Ncz7UcEDGOiKK4+teh2dX
	2/dy7ZRnT9F7+WM2+85Fscf4pyjcDPb1be+b/cQ9o6P7j3vi9w92Osu5uMv/r09w3ZL35Msa
	g+PMxiq/dk04MVOpMGHNnsNdbVO+bosu8NU4mLcke3V4yrKwbfJKLMUZiYZazEXFiQDf0n1V
	HQMAAA==
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
 drivers/rtc/rtc-spear.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-spear.c b/drivers/rtc/rtc-spear.c
index a18c319..ceee291 100644
--- a/drivers/rtc/rtc-spear.c
+++ b/drivers/rtc/rtc-spear.c
@@ -400,8 +400,8 @@ static int spear_rtc_probe(struct platform_device *pdev)
 	spin_lock_init(&config->lock);
 	platform_set_drvdata(pdev, config);
 
-	config->rtc = rtc_device_register(pdev->name, &pdev->dev,
-			&spear_rtc_ops, THIS_MODULE);
+	config->rtc = devm_rtc_device_register(pdev->name, &pdev->dev,
+					&spear_rtc_ops, THIS_MODULE);
 	if (IS_ERR(config->rtc)) {
 		dev_err(&pdev->dev, "can't register RTC device, err %ld\n",
 				PTR_ERR(config->rtc));
@@ -427,7 +427,6 @@ static int spear_rtc_remove(struct platform_device *pdev)
 {
 	struct spear_rtc_config *config = platform_get_drvdata(pdev);
 
-	rtc_device_unregister(config->rtc);
 	spear_rtc_disable_interrupt(config);
 	clk_disable_unprepare(config->clk);
 	device_init_wakeup(&pdev->dev, 0);
-- 
1.7.2.5


