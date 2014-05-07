Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbaEGIes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:34:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:55122 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaEGIep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:34:45 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-0f-5369f0223ed8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "=?ISO-8859-1?Q?'Heiko_St=FCbner'?=" <heiko@sntech.de>
References: <020f01cf69ce$bf617b50$3e2471f0$%han@samsung.com>
In-reply-to: <020f01cf69ce$bf617b50$3e2471f0$%han@samsung.com>
Subject: [PATCH 2/5] rtc: rtc-hym8563: Make of_device_id array const
Date: Wed, 07 May 2014 17:34:42 +0900
Message-id: <021301cf69cf$316ff000$944fd000$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9pzr9CTHGzqjsGTXmFpMFJp7KU/wAAFlxw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zfV2lD5nBBlueG1gsuXiV3WLO+jVs
	Fv8fvWa1uLzwEpDYNYfNYn9nB6MDm8eeiSfZPE7M+M3i0bdlFaPH9mvzmD2mz/vJ5PF5k1wA
	WxSXTUpqTmZZapG+XQJXxtQVL9kKNrFWbLx3iq2BcTdLFyMnh4SAicTtcwvYIGwxiQv31gPZ
	XBxCAssYJS6sfQtXtPleAwtEYhGjxIe7e5ghnN+MEr82PWMFqWITUJP48uUwexcjB4eIgL5E
	W4sGSA2zwFFGibNPnoNNEhKwlVjb/BVsHaeAncTkI1PZQWxhAReJ9ls3mEBsFgFViTMTdzKD
	2LxA9bd6vjNB2IISPybfA5vDLKAjsb91GhuELS+xec1bZpC9EgLqEo/+6oKERQSMJG7tfMkK
	USIise/FO0aQeyQEPrJLdBzfygaxS0Di2+RDLBC9shKbDjBDPCwpcXDFDZYJjBKzkGyehWTz
	LCSbZyFZsYCRZRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGSPxO3MF4/4D1IcZkoPUTmaVE
	k/OB8Z9XEm9obGZkYWpiamxkbmlGmrCSOG/6o6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxS
	DYzrfiZffMrNyaro483StHQd47swaSOhgp2Nceud7LQPB6QER/xk6W8SKknzeRN2e830K8df
	Xij8tmFrsdLlQ6ocu0OzWd+pbKqOavjEFGZWt1Xo6uPOC7wCryaqrtT1Pj7jpPWrghBeh7eN
	huEr5/A7Sc3gWF6fcDR1/xajHy/qriqJ/YnlvaDEUpyRaKjFXFScCADmDAPi9QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jAV2lD5nBBve/6lgsuXiV3WLO+jVs
	Fv8fvWa1uLzwEpDYNYfNYn9nB6MDm8eeiSfZPE7M+M3i0bdlFaPH9mvzmD2mz/vJ5PF5k1wA
	W1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0B1K
	CmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMI6xoypK16yFWxirdh47xRbA+Nu
	li5GTg4JAROJzfcaoGwxiQv31rN1MXJxCAksYpT4cHcPM4Tzm1Hi16ZnrCBVbAJqEl++HGbv
	YuTgEBHQl2hr0QCpYRY4yihx9slzsElCArYSa5u/soHYnAJ2EpOPTGUHsYUFXCTab91gArFZ
	BFQlzkzcyQxi8wLV3+r5zgRhC0r8mHwPbA6zgI7E/tZpbBC2vMTmNW+ZQfZKCKhLPPqrCxIW
	ETCSuLXzJStEiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLS
	vHS95PzcTYzg5PBMegfjqgaLQ4wCHIxKPLwWbzOChVgTy4orcw8xSnAwK4nw7rqYGSzEm5JY
	WZValB9fVJqTWnyIMRno0YnMUqLJ+cDElVcSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTE
	ktTs1NSC1CKYLUwcnFINjOwr/s3Sta0+l/i3h9WBp/ajU8ff51GzpTdtVdglui77eh5TfoVf
	XfEO1we14Ub2zbYbhVb7xHBc9bjZ/0FbJTHfS3JTzqMPFY8cp5e+tntT+d+0InZH1yv5YLOy
	XZ2RFzfs3/rs0fonlo3+s71Znp88f4zdJdavrV1tM7PEZTsDdts96odWKbEUZyQaajEXFScC
	AD9Nl4xSAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions
handle it as const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-hym8563.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-hym8563.c b/drivers/rtc/rtc-hym8563.c
index bd628a6..5620c24 100644
--- a/drivers/rtc/rtc-hym8563.c
+++ b/drivers/rtc/rtc-hym8563.c
@@ -582,7 +582,7 @@ static const struct i2c_device_id hym8563_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, hym8563_id);
 
-static struct of_device_id hym8563_dt_idtable[] = {
+static const struct of_device_id hym8563_dt_idtable[] = {
 	{ .compatible = "haoyu,hym8563" },
 	{},
 };
-- 
1.7.10.4


