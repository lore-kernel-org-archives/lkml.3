Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab3HBFVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 01:21:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:21929 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984Ab3HBFV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 01:21:29 -0400
X-AuditID: cbfee691-b7fef6d000002d62-72-51fb41d79121
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/2] mfd: ab8500-gpadc: add CONFIG_PM_SLEEP to suspend/resume
Date: Fri, 02 Aug 2013 14:21:26 +0900
Message-id: <000201ce8f40$2322df90$69689eb0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6PQB8LxgJ/mZ8yR3OGC0bl9Bxwqg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zfd3rjr8DDS6uELa4vPASq8X9r0cZ
	LS7vmsNmcbqb1YHF4861PWwe804GevRtWcXo8XmTXABLFJdNSmpOZllqkb5dAlfG9KXqBUc5
	K7r33mZtYOzl6GLk5JAQMJE4faWZFcIWk7hwbz1bFyMXh5DAMkaJXV83scIUzV/TD5VYxCjR
	P6ePHcL5xSjx/lA3E0gVm4CaxJcvh4ESHBwiAn4SDSvYQcLMAk4SP7fMZAGxhQV8JS7MeMsI
	YrMIqEq0/psDFucVsJSY3HqBGcIWlPgx+R4LRK+WxPqdx5kgbHmJzWveMkMcpCCx4+xrsDki
	AnoS2yeegaoXkdj34h0jRM0qdokJF6ogdglIfJt8iAXkNAkBWYlNB6DGSEocXHGDZQKj2Cwk
	m2ch2TwLyeZZSDYsYGRZxSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7iRESXxN3MN4/YH2IMRlo
	/URmKdHkfGB85pXEGxqbGVmYmpgaG5lbmpEmrCTOq95iHSgkkJ5YkpqdmlqQWhRfVJqTWnyI
	kYmDU6qBceZFxTP/Vr/sOZzLkjh/7fqDF/9dPzP3g2bytjnv0q99zHWVKTPW9OxRCDxate6D
	RYilOr9Hzg6F32tqZ/4ztc71mK0qbpO5+2T5K4mn7POnOS72/Wiw5LHMZKXTJ0zrz4dnfcvM
	Yms70mdXNp1Vrm3mvPW7hNcFJJsGiK3NseHcsya9/GscgxJLcUaioRZzUXEiAInprDPFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jAd3rjr8DDY4e5Le4vPASq8X9r0cZ
	LS7vmsNmcbqb1YHF4861PWwe804GevRtWcXo8XmTXABLVAOjTUZqYkpqkUJqXnJ+SmZeuq2S
	d3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QRiWFssScUqBQQGJxsZK+HaYJoSFuuhYw
	jRG6viFBcD1GBmggYR1jxvSl6gVHOSu6995mbWDs5ehi5OSQEDCRmL+mnw3CFpO4cG89kM3F
	ISSwiFGif04fO4Tzi1Hi/aFuJpAqNgE1iS9fDgMlODhEBPwkGlawg4SZBZwkfm6ZyQJiCwv4
	SlyY8ZYRxGYRUJVo/TcHLM4rYCkxufUCM4QtKPFj8j0WiF4tifU7jzNB2PISm9e8ZYY4SEFi
	x9nXYHNEBPQktk88A1UvIrHvxTvGCYwCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk911Cv
	ODG3uDQvXS85P3cTIzh+n0ntYFzZYHGIUYCDUYmH90Hmr0Ah1sSy4srcQ4wSHMxKIrx/ZgOF
	eFMSK6tSi/Lji0pzUosPMSYDfTqRWUo0OR+YWvJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0o
	JJCeWJKanZpakFoEs4WJg1OqgbH5yNMdfkvWLVUWb5tjfOuM11rLPLXUUNl8m7L24PAFp5+e
	jU/h0rcv/WkV3Lf6QIbc3kUSIQVrPhjxXyixvCEVxPv6iUa5duXzrfG3pt646eejLeB25VXh
	2j8FMZ0BqRoBL95+O3y0QsaOpSxxi+MzFQNfyUVblJcvubZ+Bb+qk88arWs/K5VYijMSDbWY
	i4oTAUzKOgUjAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CONFIG_PM_SLEEP to suspend/resume functions to fix the build
warnings when CONFIG_PM_SLEEP is not selected. This is because
sleep PM callbacks defined by SET_SYSTEM_SLEEP_PM_OPS are only used
when the CONFIG_PM_SLEEP is enabled.

drivers/mfd/ab8500-gpadc.c:891:12: warning: 'ab8500_gpadc_suspend' defined but not used [-Wunused-function]
drivers/mfd/ab8500-gpadc.c:903:12: warning: 'ab8500_gpadc_resume' defined but not used [-Wunused-function]

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/ab8500-gpadc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/ab8500-gpadc.c b/drivers/mfd/ab8500-gpadc.c
index 77c616f..36000f9 100644
--- a/drivers/mfd/ab8500-gpadc.c
+++ b/drivers/mfd/ab8500-gpadc.c
@@ -888,6 +888,7 @@ static int ab8500_gpadc_runtime_resume(struct device *dev)
 }
 #endif
 
+#ifdef CONFIG_PM_SLEEP
 static int ab8500_gpadc_suspend(struct device *dev)
 {
 	struct ab8500_gpadc *gpadc = dev_get_drvdata(dev);
@@ -915,6 +916,7 @@ static int ab8500_gpadc_resume(struct device *dev)
 	mutex_unlock(&gpadc->ab8500_gpadc_lock);
 	return ret;
 }
+#endif
 
 static int ab8500_gpadc_probe(struct platform_device *pdev)
 {
-- 
1.7.10.4


