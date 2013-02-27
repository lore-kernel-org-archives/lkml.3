Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab3B0F6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 00:58:37 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:56629 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3B0F6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 00:58:32 -0500
X-AuditID: cbfee690-b7f6b6d000004563-19-512da08741e0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jonghwa Lee'" <jonghwa3.lee@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <008f01ce14af$4283cf90$c78b6eb0$%han@samsung.com>
In-reply-to: <008f01ce14af$4283cf90$c78b6eb0$%han@samsung.com>
Subject: [PATCH 4/5] rtc: max77686: fix indentation of bit definitions
Date: Wed, 27 Feb 2013 14:58:30 +0900
Message-id: <009201ce14af$78286a70$68793f50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Ur0Jf3bJm/gOXS5uxDgC3uRXcVgAACkNQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zI932BbqBBsubWCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGwbVb2Qp+clZc39nM3sD4i72LkZNDQsBE4tiHZ6wQtpjEhXvr
	2boYuTiEBJYxSpw5spgFpuju70XMEIlFjBJz7i1mBEkICcxmkliz2Q/EZhNQk/jy5TDQVA4O
	EQF9ibYWDZB6ZoGdjBIPV9+GqreV2PTjLBuIzSlgJ7Hw61YwW1jATaL1x1Ewm0VAVeL/2etM
	IDYvUP3FtUeZIWxBiR+T74EdxCygJbF+53EmCFteYvOat8wgeyUE1CUe/dUFCYsIGEm03W5k
	gygRkdj34h0jxC/L2CWe/giGWCUg8W3yIRaIVlmJTQeYIUokJQ6uuMEygVFiFpLFs5AsnoVk
	8SwkGxYwsqxiFE0tSC4oTkovMtErTswtLs1L10vOz93ECImrCTsY7x2wPsSYDLR+IrOUaHI+
	MC7zSuINjY1NzExMTcwtTc1NSRNWEueVvyQTKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHR
	KHhN2/WVUxcoVX9r18iy2bJAXGrtoQOx+f63Z3qkaSavMszNXL9qe5o2n5lnwYYlv04dFbq7
	OubjrDJFJ559yu4xT/9aXc5NzLvx7r998Z2jMnVvVqZvv1N54sH3LPaYlSYF/EIMfdqT1Y4c
	4+ox92ff6b5v7snqz7MNjyluE031M27X1d2rxFKckWioxVxUnAgAeMUXNsECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG7bAt1Ag7sbrSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxsG1W9kKfnJWXN/ZzN7A
	+Iu9i5GTQ0LAROLu70XMELaYxIV769m6GLk4hAQWMUrMubeYESQhJDCbSWLNZj8Qm01ATeLL
	l8NAzRwcIgL6Em0tGiD1zAI7GSUerr4NVW8rsenHWTYQm1PATmLh161gtrCAm0Trj6NgNouA
	qsT/s9eZQGxeoPqLa48yQ9iCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZZK+EgLrEo7+6IGER
	ASOJttuNbBAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz
	0vWS83M3MYLj9pn0DsZVDRaHGAU4GJV4eBdc0gkUYk0sK67MPcQowcGsJML78QBQiDclsbIq
	tSg/vqg0J7X4EGMy0KMTmaVEk/OBKSWvJN7Q2MTMyNLIzMLIxNycNGElcV7GU08ChATSE0tS
	s1NTC1KLYLYwcXBKNTAWFMpVv5lpfeF4aeL3c0ffNW2QTft+1YxFqsd9NuO/MqVJj+b/C9gU
	cKuQc6FjruZxzh+crPPvX3g1xSvuyPqmb9ZPk3UUpY4dUlqw9sPj9H+xh+qMRQ101HlkGMSm
	xcTIFkg8eL7gm/jxSbZvpfm//6nrNH/96Y/R8i9fr+4/HCV6cL6/rJSwEktxRqKhFnNRcSIA
	Pkc/vx8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes indentation of bit definitions to enhance the
readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-max77686.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index 36b1f5c..9de93e7 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -24,7 +24,7 @@
 
 /* RTC Control Register */
 #define BCD_EN_SHIFT			0
-#define BCD_EN_MASK				(1 << BCD_EN_SHIFT)
+#define BCD_EN_MASK			(1 << BCD_EN_SHIFT)
 #define MODEL24_SHIFT			1
 #define MODEL24_MASK			(1 << MODEL24_SHIFT)
 /* RTC Update Register1 */
@@ -33,12 +33,12 @@
 #define RTC_RBUDR_SHIFT			4
 #define RTC_RBUDR_MASK			(1 << RTC_RBUDR_SHIFT)
 /* WTSR and SMPL Register */
-#define WTSRT_SHIFT				0
-#define SMPLT_SHIFT				2
+#define WTSRT_SHIFT			0
+#define SMPLT_SHIFT			2
 #define WTSR_EN_SHIFT			6
 #define SMPL_EN_SHIFT			7
-#define WTSRT_MASK				(3 << WTSRT_SHIFT)
-#define SMPLT_MASK				(3 << SMPLT_SHIFT)
+#define WTSRT_MASK			(3 << WTSRT_SHIFT)
+#define SMPLT_MASK			(3 << SMPLT_SHIFT)
 #define WTSR_EN_MASK			(1 << WTSR_EN_SHIFT)
 #define SMPL_EN_MASK			(1 << SMPL_EN_SHIFT)
 /* RTC Hour register */
-- 
1.7.2.5


