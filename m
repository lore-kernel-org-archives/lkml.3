Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab3B0F5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 00:57:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:41652 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3B0F5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 00:57:45 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-a3-512da0577122
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jonghwa Lee'" <jonghwa3.lee@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <008f01ce14af$4283cf90$c78b6eb0$%han@samsung.com>
In-reply-to: <008f01ce14af$4283cf90$c78b6eb0$%han@samsung.com>
Subject: [PATCH 2/5] rtc: max77686: add missing module author name
Date: Wed, 27 Feb 2013 14:57:42 +0900
Message-id: <009001ce14af$5ba33ce0$12e9b6a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Ur0Jf3bJm/gOXS5uxDgC3uRXcVgAAAieQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zfd3wBbqBBsc38Vtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mp5tCCo6wVvzaNZmpgfEJSxcjJ4eEgInEhmVPGSFsMYkL99az
	dTFycQgJLGOUOH1gDztM0brb85khEosYJXbO/cQC4cxmkljXfIAJpIpNQE3iy5fDQB0cHCIC
	+hJtLRogNcwCOxklHq6+DbZCSMBWYtOPs2wgNqeAncTCr1vBbGEBJ4npSyHOYBFQlTh0/j/Y
	TF6g+qNfnjND2IISPybfAzubWUBLYv3O40wQtrzE5jVvmUH2SgioSzz6qwsSFhEwklhw+CxU
	iYjEvhfvoL5cxi7xfWssxCoBiW+TD7FAtMpKbDrADFEiKXFwxQ2WCYwSs5AsnoVk8Swki2ch
	2bCAkWUVo2hqQXJBcVJ6kZFecWJucWleul5yfu4mRkhc9e1gvHnA+hBjMtD6icxSosn5wLjM
	K4k3NDY2MTMxNTG3NDU3JU1YSZxX/pJMoJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbGaS+K
	ZuYH9KmWl71dZr9XV6W28NyZnBI3rj6X78m9T6MlxZcKHVrmLfzzwB/JPctvLl/oeuTiu4ry
	SS2n3nr/uTDzGItnwoErNyQ/m7BdmrdwbbZ+6bGl0buOnfLkditdE5rkqHag+k4AW6p6bf5n
	A/0fU5a6JUx/s9Rnufujx494NH/7ZqidV2Ipzkg01GIuKk4EAOj5gQjBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG74At1Ag/7b7BaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4+mmkIIjrBW/dk1mamB8
	wtLFyMkhIWAise72fGYIW0ziwr31bF2MXBxCAosYJXbO/cQC4cxmkljXfIAJpIpNQE3iy5fD
	7F2MHBwiAvoSbS0aIDXMAjsZJR6uvs0IUiMkYCux6cdZNhCbU8BOYuHXrWC2sICTxPSlT8Fq
	WARUJQ6d/w82kxeo/uiX58wQtqDEj8n3wK5jFtCSWL/zOBOELS+xec1bZpC9EgLqEo/+6oKE
	RQSMJBYcPgtVIiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0
	L10vOT93EyM4bp9J7WBc2WBxiFGAg1GJh3fBJZ1AIdbEsuLK3EOMEhzMSiK8Hw8AhXhTEiur
	Uovy44tKc1KLDzEmAz06kVlKNDkfmFLySuINjU3MjCyNzCyMTMzNSRNWEudlPPUkQEggPbEk
	NTs1tSC1CGYLEwenVAOj1s1b7SnKk78tN+T1VY7i+9S+WSqGa8dBzbx7+qdfTWBlLrtmItya
	a95bFC74qc1UfI5eg/CRS7FHPipwcEy9HXl4u+yK+YaXGcvMP+/7Y1oswD1/RnbA05mnJ/qK
	p2k/vzGrvl2hf+7fT5t3T4pI5PBVL3XnunnzpXBYy/FznPI1E7ben7NYiaU4I9FQi7moOBEA
	+UnCRh8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing module author name to MODULE_AUTHOR macro.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-max77686.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
index a8e31fc..4da2a55 100644
--- a/drivers/rtc/rtc-max77686.c
+++ b/drivers/rtc/rtc-max77686.c
@@ -627,5 +627,5 @@ static struct platform_driver max77686_rtc_driver = {
 module_platform_driver(max77686_rtc_driver);
 
 MODULE_DESCRIPTION("Maxim MAX77686 RTC driver");
-MODULE_AUTHOR("<woong.byun@samsung.com>");
+MODULE_AUTHOR("Chiwoong Byun <woong.byun@samsung.com>");
 MODULE_LICENSE("GPL");
-- 
1.7.2.5


