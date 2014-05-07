Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbaEGIbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:31:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37426 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbaEGIbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:31:33 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-33-5369ef633985
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Alexander Shiyan'" <shc_work@mail.ru>
Subject: [PATCH 1/5] rtc: rtc-ds1742: Make of_device_id array const
Date: Wed, 07 May 2014 17:31:31 +0900
Message-id: <020f01cf69ce$bf617b50$3e2471f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9pzr9CTHGzqjsGTXmFpMFJp7KU/w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zI93k95nBBo8OylgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORotJO6Qc2Dz2TDzJ5nFixm8Wjylzj7B69G1Zxegxfd5PJo/Pm+QC
	2KK4bFJSczLLUov07RK4Mia+/MhesJO1YsuzzawNjAdYuhg5OSQETCQedb6AssUkLtxbz9bF
	yMUhJLCMUWLd3GXMMEXTt+1ihEhMZ5TY+GYeVNVvRonps1YyglSxCahJfPlymL2LkYNDREBf
	oq1FAyTMLLCNUeLn+hoQW1jAWaK9v5kNpIRFQFXi6DRWkDCvgK3E70V/WSBsQYkfk++xQLRq
	SazfeZwJwpaX2LzmLTNIq4SAusSjv7ogYREBPYnFi/8zQ5SISOx78Q7sTAmBS+wSO49/A5vP
	IiAg8W3yIRaIXlmJTQeg3pKUOLjiBssERrFZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3I
	RK84Mbe4NC9dLzk/dxMjJBIn7GC8d8D6EGMy0PqJzFKiyfnASM4riTc0NjOyMDUxNTYytzQj
	TVhJnFftUVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkbxrxMz6rTsVomdnz2zv3lG7Z6D
	P/2v1ntFm2+bFaF90jLDtzdQKPTnNIejfV8553/eGfR9l/4B3rtxOkJ/5/l61UwS1K+daT1p
	AdPLb6lRPyRXpHqZb5flXONm4S+2d/kmfcUjTxVePI/NP8DEOm/JsVvtwhtedIu+4ow7ryEu
	ILO5gVExOkGJpTgj0VCLuag4EQCPaD1h2gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t9jQd3k95nBBqseS1gsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORotJO6Qc2Dz2TDzJ5nFixm8Wjylzj7B69G1Zxegxfd5PJo/Pm+QC
	2KIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5Q
	UihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWZMfPmRvWAna8WWZ5tZGxgP
	sHQxcnJICJhITN+2ixHCFpO4cG89WxcjF4eQwHRGiY1v5kE5vxklps9aCVbFJqAm8eXLYfYu
	Rg4OEQF9ibYWDZAws8A2Romf62tAbGEBZ4n2/mY2kBIWAVWJo9NYQcK8ArYSvxf9ZYGwBSV+
	TL7HAtGqJbF+53EmCFteYvOat8wgrRIC6hKP/uqChEUE9CQWL/7PDFEiIrHvxTvGCYwCs5BM
	moVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzjOn0nvYFzVYHGIUYCD
	UYmH1+JtRrAQa2JZcWXuIUYJDmYlEd5dFzODhXhTEiurUovy44tKc1KLDzEmA/05kVlKNDkf
	mILySuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoGx4WqPAovo
	Cb2qbVPLjqopS82zkV65xS590aP1RtsPtWfe4sq0T/kY3c9+v+KlxaZtRzYxeN0MXia3d4Zz
	drnNF4a/F2s3trFuyWP+Uq3Nz73x6ecA2fQJM36Jat66erP9yD++H9F368yb/muvPHAt3UXo
	6xLj4A69xpbSH8kz5t3kDNu8psBdiaU4I9FQi7moOBEANyGtVzcDAAA=
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
 drivers/rtc/rtc-ds1742.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index 942103d..c6b2191 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -219,7 +219,7 @@ static int ds1742_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static struct of_device_id __maybe_unused ds1742_rtc_of_match[] = {
+static const struct of_device_id __maybe_unused ds1742_rtc_of_match[] = {
 	{ .compatible = "maxim,ds1742", },
 	{ }
 };
-- 
1.7.10.4


