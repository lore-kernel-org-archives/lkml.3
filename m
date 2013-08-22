Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab3HVCSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:18:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34057 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3HVCSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:18:47 -0400
X-AuditID: cbfee691-b7fef6d000002d62-6d-52157505ca18
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Rodolfo Giometti'" <giometti@enneenne.com>,
        linuxpps@ml.enneenne.com, "'Jan Luebbe'" <jlu@pengutronix.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] pps: clients: pps-gpio: remove unnecessary
 platform_set_drvdata()
Date: Thu, 22 Aug 2013 11:18:45 +0900
Message-id: <002801ce9edd$edf2b3b0$c9d81b10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6e3egNvjWBBns1Sw+jeWIx+vwx5w==
Content-language: ko
x-cr-hashedpuzzle: MOne R/ev W3aq fNGi n0TM qPav rAun r9bx sG+r v/oi zva5 06FB
 1bbD 50D5 AAar4Q==
 AAoLzQ==;6;YQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGcAaQBvAG0AZQB0AHQAaQBAAGUAbgBuAGUAZQBuAG4AZQAuAGMAbwBtADsAagBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA7AGoAbAB1AEAAcABlAG4AZwB1AHQAcgBvAG4AaQB4AC4AZABlADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeABwAHAAcwBAAG0AbAAuAGUAbgBuAGUAZQBuAG4AZQAuAGMAbwBtAA==;Sosha1_v1;7;{74F1D6E8-D3F0-4908-B274-6413C1936AC4};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 22 Aug 2013 02:18:35
 GMT;WwBQAEEAVABDAEgAXQAgAHAAcABzADoAIABjAGwAaQBlAG4AdABzADoAIABwAHAAcwAtAGcAcABpAG8AOgAgAHIAZQBtAG8AdgBlACAAdQBuAG4AZQBjAGUAcwBzAGEAcgB5ACAAcABsAGEAdABmAG8AcgBtAF8AcwBlAHQAXwBkAHIAdgBkAGEAdABhACgAKQA=
x-cr-puzzleid: {74F1D6E8-D3F0-4908-B274-6413C1936AC4}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zQ13WUtEgg2fTrSzmrF/DZjHh9WtG
	i8sLL7FafJ0zj9Xi8q45bBY9X/vZHNg8+le7e5yY8ZvFo7X7ALNH/18Dj74tqxg9Pm+SC2CL
	4rJJSc3JLEst0rdL4MrYeegeS8EqtopNa7wbGJezdjFyckgImEism/CdBcIWk7hwbz1bFyMX
	h5DAMkaJNQ9vsMAULbjzCaxBSGA6o8TuDewQRb8YJT7s28sMkmATUJP48uUwUIKDQ0RAX6Kt
	RQOkhllgI6PE0a67YIOEBUIkdh17zARSwyKgKrF8pw9ImFfAVqLl/U4mCFtQ4sfke2DlzAJa
	Eut3HmeCsOUlNq95ywzSKiGgLvHory5IWERAT2LLpLusECUiEvtevGMEWSshsINNYv3dL4wQ
	95tKLGnbzgSReMsu8efAJbCbWQQEJL5NPsQCMVRWYtMBZoh6SYmDK26wTGCUmIXkpFlITpqF
	5KRZSHYvYGRZxSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7iREStxN3MN4/YH2IMRlo/URmKdHk
	fGDc55XEGxqbGVmYmpgaG5lbmpEmrCTOq95iHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qB
	cfN33bYSw0k3mUsjt0SHz5PbrWz78JCU5b2cbO+FX2274m/PqnyRNEOsLSDjXVKsfNjBtPMF
	D6XbJgXuVa0M9OE3yX39fhPbNI15+WWtrUkzjXSPFcdaaVh0Zk6tC6y6f297WOLCqz1eviv2
	54v5GHFfY77MLBM0UeJVNNOZ99PK1s+ad5xLiaU4I9FQi7moOBEAL1mU2/ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jQV3WUtEgg+MNZhZz1q9hs5jw+jWj
	xeWFl1gtvs6Zx2pxedccNouer/1sDmwe/avdPU7M+M3i0dp9gNmj/6+BR9+WVYwenzfJBbBF
	NTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBdoaRQ
	lphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM2HnoHkvBKraKTWu8GxiXs3Yx
	cnJICJhILLjzCcoWk7hwbz0biC0kMJ1RYvcG9i5GLiD7F6PEh317mUESbAJqEl++HAZKcHCI
	COhLtLVogNQwC2xklDjadZcFpEZYIERi17HHTCA1LAKqEst3+oCEeQVsJVre72SCsAUlfky+
	B1bOLKAlsX7ncSYIW15i85q3zCCtEgLqEo/+6oKERQT0JLZMussKUSIise/FO0aQtRICO9gk
	1t/9wghxv6nEkrbtTBMYhWYhWTELyYpZSFbMQjJrASPLKkbR1ILkguKk9FwjveLE3OLSvHS9
	5PzcTYzgpPBMegfjqgaLQ4wCHIxKPLwXdooECbEmlhVX5h5ilOBgVhLhldYSDRLiTUmsrEot
	yo8vKs1JLT7EmAwMgInMUqLJ+cCElVcSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs
	1NSC1CKYLUwcnFINjIseTp9arVsm7qS/a5pe3NJOX2+RcMlbr+MT/y0uWlC1JkYs/Io0d2ZJ
	w7nNSmdXnylc9IbzQor/JoZsl5yceVukLeKEjO4VnmpdUdzltV9ofdGPa4/mtP4puLJTpcLI
	8czOrxl1//9rOGY6KzepOP92uht3JDr49d87UoopDBtsVhrnHzvQrcRSnJFoqMVcVJwIACRJ
	1vlOAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/pps/clients/pps-gpio.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pps/clients/pps-gpio.c b/drivers/pps/clients/pps-gpio.c
index eae0eda..9966124 100644
--- a/drivers/pps/clients/pps-gpio.c
+++ b/drivers/pps/clients/pps-gpio.c
@@ -184,7 +184,6 @@ static int pps_gpio_remove(struct platform_device *pdev)
 {
 	struct pps_gpio_device_data *data = platform_get_drvdata(pdev);
 
-	platform_set_drvdata(pdev, NULL);
 	pps_unregister_source(data->pps);
 	dev_info(&pdev->dev, "removed IRQ %d as PPS source\n", data->irq);
 	return 0;
-- 
1.7.10.4


