Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab3HUJpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:45:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40091 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3HUJph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:45:37 -0400
X-AuditID: cbfee68e-b7f276d000002279-b3-52148c3f080d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vinod Koul'" <vinod.koul@intel.com>
Cc: "'Dan Williams'" <djbw@fb.com>, linux-kernel@vger.kernel.org,
        "'Simon Horman'" <horms+renesas@verge.net.au>,
        "'Guennadi Liakhovetski'" <g.liakhovetski@gmx.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] dma: sh: remove unnecessary platform_set_drvdata()
Date: Wed, 21 Aug 2013 18:45:35 +0900
Message-id: <002801ce9e53$2f63b1e0$8e2b15a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6eUy9M4qfpJa1qQgCgMBLck+jjLQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t8zA137HpEgg+Utehab+x+wWbzfOI/J
	4sLbD2wWlxdeYrW4vGsOm8XLvv0sDmweE5vfsXt8+BjnsXjPSyaPvi2rGD3m/PzG4vF5k1wA
	WxSXTUpqTmZZapG+XQJXxvI7/5gLGnkqevadYW9gbOHqYuTkkBAwkZi9s5cFwhaTuHBvPVsX
	IxeHkMAyRolfvedZYIpOnehmhUhMZ5RYfKeTGcL5xShxevZTsCo2ATWJL18Os3cxcnCICKhL
	LL0uA1LDLHCMUeL4hsVsIDXCAs4S1/b/YgWpYRFQlZjxMgAkzCtgK7FxTScThC0o8WPyPbCR
	zAJaEut3HmeCsOUlNq95ywzSKgE0/tFfXZCwiICexMoTx9kgSkQk9r14xwiyVkLgGrvEs9/n
	GUESLAICEt8mH2KB6JWV2HSAGeIvSYmDK26wTGAUm4Vk8ywkm2ch2TwLyYoFjCyrGEVTC5IL
	ipPSi4z0ihNzi0vz0vWS83M3MUJisW8H480D1ocYk4HWT2SWEk3OB8ZyXkm8obGZkYWpiamx
	kbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYnaV+tmy8I3yFTe1zrKN+
	iqmvyUv/J7p9ClKHJH49Pe0+Re73u68Xyp+7r98Yup0pSvv2pr+q2+61Bl39t9Bfu+LunH1S
	a7c3Tzod9iSV7cv76nKXxCrNRUc4trhfbHsxcXbr4kcVQaYbA7e9XyBze2PUpzda8//WLfDp
	Yl3Aofwye9IJjfMbFJVYijMSDbWYi4oTARkLMJbbAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t9jQV37HpEgg10vNC029z9gs3i/cR6T
	xYW3H9gsLi+8xGpxedccNouXfftZHNg8Jja/Y/f48DHOY/Gel0wefVtWMXrM+fmNxePzJrkA
	tqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoDOU
	FMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBnL7/xjLmjkqejZd4a9gbGF
	q4uRk0NCwETi1IluVghbTOLCvfVsXYxcHEIC0xklFt/pZIZwfjFKnJ79lAWkik1ATeLLl8Ps
	XYwcHCIC6hJLr8uA1DALHGOUOL5hMRtIjbCAs8S1/b9YQWpYBFQlZrwMAAnzCthKbFzTyQRh
	C0r8mHwPbCSzgJbE+p3HmSBseYnNa94yg7RKAI1/9FcXJCwioCex8sRxNogSEYl9L94xTmAU
	mIVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGR/kxqB+PKBotD
	jAIcjEo8vBeURYKEWBPLiitzDzFKcDArifAuqgYK8aYkVlalFuXHF5XmpBYfYkwG+nMis5Ro
	cj4wCeWVxBsam5gZWRqZWRiZmJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA2P0k8kM
	G0r5Iz4d93PKLvVjyV+6s/LYRdnVh749b7G8qLrwFPN2SeVdH7dKC7ZdSfAq4z+cZHDQ+/m/
	5+Uz14s0uEr0TfwZrV0mutlwZdctk+CDjWEqL/eLTnFJ0vi9ZZurJVvomvTWjMRlB+bXtNTG
	e16u4rv8T+P2s5vaCvV5B97Pt/+Q91iJpTgj0VCLuag4EQBPrL/jOAMAAA==
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
 drivers/dma/sh/shdma.c  |    3 ---
 drivers/dma/sh/sudmac.c |    2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/dma/sh/shdma.c b/drivers/dma/sh/shdma.c
index 211e2f1..208de0f 100644
--- a/drivers/dma/sh/shdma.c
+++ b/drivers/dma/sh/shdma.c
@@ -873,7 +873,6 @@ rst_err:
 	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
-	platform_set_drvdata(pdev, NULL);
 	shdma_cleanup(&shdev->shdma_dev);
 eshdma:
 	if (dmars)
@@ -917,8 +916,6 @@ static int sh_dmae_remove(struct platform_device *pdev)
 		iounmap(shdev->dmars);
 	iounmap(shdev->chan_reg);
 
-	platform_set_drvdata(pdev, NULL);
-
 	synchronize_rcu();
 	kfree(shdev);
 
diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
index c494417..23fffc8 100644
--- a/drivers/dma/sh/sudmac.c
+++ b/drivers/dma/sh/sudmac.c
@@ -393,7 +393,6 @@ static int sudmac_probe(struct platform_device *pdev)
 chan_probe_err:
 	sudmac_chan_remove(su_dev);
 
-	platform_set_drvdata(pdev, NULL);
 	shdma_cleanup(&su_dev->shdma_dev);
 
 	return err;
@@ -407,7 +406,6 @@ static int sudmac_remove(struct platform_device *pdev)
 	dma_async_device_unregister(dma_dev);
 	sudmac_chan_remove(su_dev);
 	shdma_cleanup(&su_dev->shdma_dev);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.10.4


