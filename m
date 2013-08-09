Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3HIEFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 00:05:44 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:41730 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3HIEFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 00:05:43 -0400
X-AuditID: cbfee68f-b7f436d000000f81-49-52046a958b94
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/3] block: mg_disk: Staticize mg_times_out()
Date: Fri, 09 Aug 2013 13:05:40 +0900
Message-id: <001901ce94b5$b6c2bc50$244834f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Content-language: ko
Thread-index: Ac6UtZ4tz9fYRmYlTv6f2zmsQoN/Hw==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zQ91pWSxBBo+tLeasX8NmsfpuP5vF
	5YWXWC0u75rD5sDicflsqceJGb9ZPPq2rGL0+LxJLoAlissmJTUnsyy1SN8ugSvj4+oFzAVX
	WStenT/F2MB4jaWLkYNDQsBE4vKTgi5GTiBTTOLCvfVsXYxcHEICyxglet7sYYJImEgce3WX
	GSKxiFFi0uMdTBDOL0aJe6/PsYJUsQmoSXz5cpgdZKqIgL5EW4sGSJhZIEnix4XPLCC2sICt
	xPWz18GGsgioSjz8vZAJpJxXwFJi4XstkDCvgKDEj8n3WCBatSQ2b2tihbDlJTavecsMcY+C
	xI6zrxkh4iIS+168A7NFBPQkZt16BnanhMA2dokrE96wQuwSkPg2+RDUw7ISmw5AzZGUOLji
	BssERrFZSFbPQrJ6FpLVs5CsW8DIsopRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJL76dzDe
	PWB9iDEZaP1EZinR5HxgfOaVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0oJJCeWJKanZpakFoU
	X1Sak1p8iJGJg1OqgZFFWc/ix3avwKTCvmU5fAplzavnlbT96lDw2KKUNfdj5f+T4pMPv/KJ
	Z/eoum6TbnC48bSIj3g0wwHHr4rt9/8+z/d755vHybTW7VHUqbi3l846ewb3nM4+X++yfuUu
	4YJvNQX3D9/tTFPrbG9ZplViU61QF3vg+60sHV9zO+/AW10c8YUrlFiKMxINtZiLihMBUOL5
	ycUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd2pWSxBBns/WlrMWb+GzWL13X42
	i8sLL7FaXN41h82BxePy2VKPEzN+s3j0bVnF6PF5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8bH1QuYC66yVrw6f4qxgfEaSxcjJ4eEgInEsVd3mSFsMYkL99az
	dTFycQgJLGKUmPR4BxOE84tR4t7rc6wgVWwCahJfvhxm72Lk4BAR0Jdoa9EACTMLJEn8uPAZ
	bKiwgK3E9bPXmUBsFgFViYe/FzKBlPMKWEosfK8FEuYVEJT4MfkeC0SrlsTmbU2sELa8xOY1
	b6HuUZDYcfY1I0RcRGLfi3dgtoiAnsSsW8+YJzAKzEIyahaSUbOQjJqFpH0BI8sqRtHUguSC
	4qT0XEO94sTc4tK8dL3k/NxNjOAIfia1g3Flg8UhRgEORiUeXsXtzEFCrIllxZW5hxglOJiV
	RHhfZAGFeFMSK6tSi/Lji0pzUosPMSYDPTqRWUo0OR+YXPJK4g2NTcyMLI3MLIxMzM1JE1YS
	5z3Qah0oJJCeWJKanZpakFoEs4WJg1OqgTHyOZfo649qoh+PNqxn42ybrn9b/uiG8pJTTy42
	fZqeFCvQ8vTWk4anG219A4NjL3Ir36wXFpnbdCrSdFbegudhIlsTLws57GVcMVXkufAZEQbf
	mtvP7urkxE0xj3U5syGpQnGHksG2izsPSzsnJBsJN858NT1m6Zr7qU27r30J5HP5tmvv104l
	luKMREMt5qLiRABK5HFZJAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mg_times_out() is used only in this file.
Fix the following sparse warning:

drivers/block/mg_disk.c:639:6: warning: symbol 'mg_times_out' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/block/mg_disk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index a56cfcd..77a60be 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -636,7 +636,7 @@ ok_to_write:
 		mg_request(host->breq);
 }
 
-void mg_times_out(unsigned long data)
+static void mg_times_out(unsigned long data)
 {
 	struct mg_host *host = (struct mg_host *)data;
 	char *name;
-- 
1.7.10.4


