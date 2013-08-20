Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab3HTHFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:05:32 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:64224 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab3HTHFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:05:30 -0400
X-AuditID: cbfee68e-b7f276d000002279-d0-52131539dd4d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 4/6] mfd: pcf50633-adc: use devm_*() functions
Date: Tue, 20 Aug 2013 16:05:29 +0900
Message-id: <005801ce9d73$a75ec990$f61c5cb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6dc6HT5DuFR5IFQUK+wJABnkfSPQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zA11LUeEgg+s7zSwuL7zEanH/61FG
	i8u75rBZnO5mdWDxuHNtD5vHvJOBHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJXRs/wTe8E+
	toq102UaGFezdjFyckgImEjMmHaZGcIWk7hwbz1bFyMXh5DAMkaJaTN+scMU3dl0iwXEFhKY
	zihxaD4rhP0LqOi/NojNJqAm8eXLYaB6Dg4RAT+JhhVgrcwCThI/t8wEaxUWsJPYuGcxI4jN
	IqAqsbC/iQ2knFfAUmLvTjOQMK+AoMSPyfdYIFq1JNbvPM4EYctLbF7zFupMBYkdZ1+DjRER
	0JNY3rYGql5EYt+Ld4wg50sIrGKXuDLjGQvELgGJb5MPsYDskhCQldh0AGqOpMTBFTdYJjCK
	zUKyehaS1bOQrJ6FZMUCRpZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGCGx1beD8eYB60OM
	yUDrJzJLiSbnA2MzryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU
	4kOMTBycUg2M66Vfzlvo1f1ITXjbBG0LoxtWO2rsLves43t9T0SI/fqVzdfVX333uXjMcQZz
	8ceJq3c9Ky5PTrFYOsduj9uOL+v2PzjoOJdvT1D0VffyOJ3LKo+kBP4/PvrBfF283nrmHc/n
	KL2+MOGs9hPtGx0N7y9x7p8ts5W1cuJR/su80y6m7HMttTt0QEyJpTgj0VCLuag4EQBtqgaP
	wwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoK6lqHCQweMOY4vLCy+xWtz/epTR
	4vKuOWwWp7tZHVg87lzbw+Yx72SgR9+WVYwenzfJBbBENTDaZKQmpqQWKaTmJeenZOal2yp5
	B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBtVFIoS8wpBQoFJBYXK+nbYZoQGuKmawHT
	GKHrGxIE12NkgAYS1jFm9Cz/xF6wj61i7XSZBsbVrF2MnBwSAiYSdzbdYoGwxSQu3FvPBmIL
	CUxnlDg0nxXC/sUoMe2/NojNJqAm8eXLYfYuRg4OEQE/iYYV7CBhZgEniZ9bZoKNERawk9i4
	ZzEjiM0ioCqxsL+JDaScV8BSYu9OM5Awr4CgxI/J91ggWrUk1u88zgRhy0tsXvOWGeIaBYkd
	Z1+DjRER0JNY3rYGql5EYt+Ld4wTGAVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnqukV5x
	Ym5xaV66XnJ+7iZGcOQ+k97BuKrB4hCjAAejEg9vh5JQkBBrYllxZe4hRgkOZiURXpf/QCHe
	lMTKqtSi/Pii0pzU4kOMyUCPTmSWEk3OByaVvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJ
	pCeWpGanphakFsFsYeLglGpgTE4vnjxjs4PIqvwipSliVbIb1pVnzfjklSjmLtj+vl/q14ZX
	ExaqrQ8L2nZv73wNjkqV0D3GIXs5eLVbD7/ka/3VwyOw7KbT2eitO9RuMOelblofHyS2Y+le
	3uMavEv7d26x7/k8Q0JnaTPrzG17157efN5brlLt7T5L1teHjOem/N3KeyGSXYmlOCPRUIu5
	qDgRAOLVfmggAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/pcf50633-adc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/pcf50633-adc.c b/drivers/mfd/pcf50633-adc.c
index 18b53cb..b8941a5 100644
--- a/drivers/mfd/pcf50633-adc.c
+++ b/drivers/mfd/pcf50633-adc.c
@@ -203,7 +203,7 @@ static int pcf50633_adc_probe(struct platform_device *pdev)
 {
 	struct pcf50633_adc *adc;
 
-	adc = kzalloc(sizeof(*adc), GFP_KERNEL);
+	adc = devm_kzalloc(&pdev->dev, sizeof(*adc), GFP_KERNEL);
 	if (!adc)
 		return -ENOMEM;
 
@@ -236,7 +236,6 @@ static int pcf50633_adc_remove(struct platform_device *pdev)
 		kfree(adc->queue[i]);
 
 	mutex_unlock(&adc->queue_mutex);
-	kfree(adc);
 
 	return 0;
 }
-- 
1.7.10.4


