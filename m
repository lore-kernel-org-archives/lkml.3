Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab3HWBWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 21:22:10 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11040 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab3HWBVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 21:21:51 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-52-5216b92e605c
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        gregkh@linuxfoundation.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 3/3] extcon: arizona: Fix up minor coding style to remove
 unnecessary braces
Date: Fri, 23 Aug 2013 10:21:39 +0900
Message-id: <1377220899-4367-3-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1377220899-4367-1-git-send-email-cw00.choi@samsung.com>
References: <1377220899-4367-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkWFdvp1iQwYnb1hZTHz5hs/g35Qa7
	xfUvz1ktmhevZ7M42/SG3eLyrjlsFrcbV7A5sHtsWtXJ5rF/7hp2j5cTf7N59G1ZxejxeZNc
	AGsUl01Kak5mWWqRvl0CV8aTW7dYCtZyVpx/9p+1gXE9excjJ4eEgInEvbc72CBsMYkL99YD
	2VwcQgJLGSV29jeywBRt2/SVCSIxnVHi/72dYN1CAo1MEgs6/EFsNgEtif0vboBNEhFQkNjc
	+4wVpIFZ4BqjxMUly8AahAXiJK78n8kEYrMIqEqsuXmPGcTmFXCR+HLkItQZchIf9jwCq+cU
	cJXo/dPCDLHMRWLSgt1gQyUE5rFLXD54lwVikIDEt8mHgGwOoISsxKYDzBBzJCUOrrjBMoFR
	eAEjwypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MwEA//e9Z7w7G2wesDzEmA42byCwlmpwP
	jJS8knhDYzMjC1MTU2Mjc0sz0oSVxHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDO
	Dn4QoLvDJV1+tsjj127mX36UZ3mH8J5/mWxWVaFts6dc6qeaZomhh0PGslOdM/UaHVs0i3iv
	CTNNuiWbPJEh9M46nfLn3qq518xUa64suHHtyE8uj9cseyzNxe8YbVZ7+9pOc57zrKYtJh83
	bk2/aJ73qPnZo16P34/rdAIXhLUFsK64elKJpTgj0VCLuag4EQDzjV8sigIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jQV29nWJBBs9/mVhMffiEzeLflBvs
	Fte/PGe1aF68ns3ibNMbdovLu+awWdxuXMHmwO6xaVUnm8f+uWvYPV5O/M3m0bdlFaPH501y
	AaxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUB3
	KCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJaxgznty6xVKwlrPi/LP/rA2M
	69m7GDk5JARMJLZt+soEYYtJXLi3nq2LkYtDSGA6o8T/ezvBioQEGpkkFnT4g9hsAloS+1/c
	YAOxRQQUJDb3PmMFaWAWuMYocXHJMrAGYYE4iSv/Z4JNZRFQlVhz8x4ziM0r4CLx5chFNoht
	chIf9jwCq+cUcJXo/dPCDLHMRWLSgt2sExh5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P
	3cQIjqNn0jsYVzVYHGIU4GBU4uGd4CwWJMSaWFZcmXuIUYKDWUmE12YVUIg3JbGyKrUoP76o
	NCe1+BBjMtBVE5mlRJPzgTGeVxJvaGxiZmRpZG5oYWRsTpqwkjjvwVbrQCGB9MSS1OzU1ILU
	IpgtTBycUg2M/vwKCg82mb16aaridcfAXXeie2rLNb9LAecufGNcrpwq33uVg2Pp97Lof5I3
	nlZNSTRispwZbfG+dW5P5ZO0zwmiBRIdi6VNrSdZapvFnND0XT7pzNY+nri/yZcz1i5UmOSy
	ZsWOX/6TXnzfIZo5kct/72Ylc63/u3lqEzM2vQryzZpe3BCixFKckWioxVxUnAgAi7amlecC	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes up braces coding style issue by using checkpatch script.

Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Mark Brown <broonie@kernel.org>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-arizona.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
index 08c4590..72fc28e 100644
--- a/drivers/extcon/extcon-arizona.c
+++ b/drivers/extcon/extcon-arizona.c
@@ -564,11 +564,10 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 	}
 
 	ret = arizona_hpdet_read(info);
-	if (ret == -EAGAIN) {
+	if (ret == -EAGAIN)
 		goto out;
-	} else if (ret < 0) {
+	else if (ret < 0)
 		goto done;
-	}
 	reading = ret;
 
 	/* Reset back to starting range */
@@ -578,11 +577,10 @@ static irqreturn_t arizona_hpdet_irq(int irq, void *data)
 			   0);
 
 	ret = arizona_hpdet_do_id(info, &reading, &mic);
-	if (ret == -EAGAIN) {
+	if (ret == -EAGAIN)
 		goto out;
-	} else if (ret < 0) {
+	else if (ret < 0)
 		goto done;
-	}
 
 	/* Report high impedence cables as line outputs */
 	if (reading >= 5000)
-- 
1.8.0

