Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab3B1KiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:38:04 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41397 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3B1Kh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:37:59 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-0d-512f33851dff
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000901ce159f$94e48270$bead8750$%han@samsung.com>
In-reply-to: <000901ce159f$94e48270$bead8750$%han@samsung.com>
Subject: [PATCH 2/7] rtc: rtc-davinci: add __exit annotation
Date: Thu, 28 Feb 2013 19:37:57 +0900
Message-id: <000a01ce159f$ac365bb0$04a31310$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vn5THVyS/kU1xRpiO8bTmT1G2WgAAAifw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zfd1WY/1Ag1e/1S0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGvUV32QqmclRs2nOPuYHxMVsXIyeHhICJxLpNP1kgbDGJC/fW
	A8W5OIQEljFK7Jp+lwmm6GzbWhaIxCJGiYPH9zBBOLOZJL4cuwpWxSagJvHly2H2LkYODhEB
	fYm2Fg2QGmaBXkaJM7272UFqhARsJVZ1t7KC2JwCdhJ75k8Cs4UFbCR2HtgHNodFQFXiyavX
	YPW8QPWTrv5ggrAFJX5Mvgd2KrOAlsTmbU2sELa8xOY1b5lB9koIqEs8+qsLEhYRMJLYeOgG
	VImIxL4X7xhB7pEQWMYu8ejzF2aIXQIS3yYfYoHolZXYdIAZ4mFJiYMrbrBMYJSYhWTzLCSb
	ZyHZPAvJigWMLKsYRVMLkguKk9KLjPSKE3OLS/PS9ZLzczcxQmKrbwfjzQPWhxiTgdZPZJYS
	Tc4HxmZeSbyhsbGJmYmpibmlqbkpacJK4rzyl2QChQTSE0tSs1NTC1KL4otKc1KLDzEycXBK
	NTBOy9hSXpTe9tQs98LGU4knt57h1oi5uWUP1xGpNPcvBkZXOyf0q7GzP/LTWD/TYLfa6wwm
	Jbcll4OZm446rWQ4+9dpWyvz5B8hV4x2Rhasztzs8XyywgePc5zbw+cYiLRPkePzmnPzCE94
	1W7uj1UmV80WFSae6T7XzKDaIK/J9PDzMtaH7beUWIozEg21mIuKEwHeLzDGwwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgG6rsX6gwbNPShaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x496iu2wFUzkqNu25x9zA
	+Jiti5GTQ0LAROJs21oWCFtM4sK99UBxLg4hgUWMEgeP72GCcGYzSXw5dpUJpIpNQE3iy5fD
	7F2MHBwiAvoSbS0aIDXMAr2MEmd6d7OD1AgJ2Eqs6m5lBbE5Bewk9syfBGYLC9hI7DywD2wO
	i4CqxJNXr8HqeYHqJ139wQRhC0r8mHwP7CJmAS2JzduaWCFseYnNa94yg+yVEFCXePRXFyQs
	ImAksfHQDagSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV5
	6XrJ+bmbGMGR+0xqB+PKBotDjAIcjEo8vB0meoFCrIllxZW5hxglOJiVRHhd+PUDhXhTEiur
	Uovy44tKc1KLDzEmAz06kVlKNDkfmFTySuINjU3MjCyNzCyMTMzNSRNWEudlPPUkQEggPbEk
	NTs1tSC1CGYLEwenVAOjUQv/UsHPwUGzuQ+f/DLn6IVNzOoNX2ZcO8p0dNWEqsmOm8Nntt5Z
	+8bn8iPeXtlNG+fskf0+NYSrr1O9yWblepnH2juKTiw6oZhm90hg3lKN2iWi6edu9374xJnO
	wrNc/Vbj3L0N61tLxae7TDjq4THBIc5D/+93xu8/lKW26qiZJDhqPb62VYmlOCPRUIu5qDgR
	AN03nrQgAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When platform_driver_probe() is used, bind/unbind via sysfs is
disabled. Thus, __init/__exit annotations can be added to
probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-davinci.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index 56b7308..db877e0 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -564,7 +564,7 @@ fail1:
 	return ret;
 }
 
-static int davinci_rtc_remove(struct platform_device *pdev)
+static int __exit davinci_rtc_remove(struct platform_device *pdev)
 {
 	struct davinci_rtc *davinci_rtc = platform_get_drvdata(pdev);
 
@@ -581,7 +581,7 @@ static int davinci_rtc_remove(struct platform_device *pdev)
 
 static struct platform_driver davinci_rtc_driver = {
 	.probe		= davinci_rtc_probe,
-	.remove		= davinci_rtc_remove,
+	.remove		= __exit_p(davinci_rtc_remove),
 	.driver		= {
 		.name = "rtc_davinci",
 		.owner = THIS_MODULE,
-- 
1.7.2.5


