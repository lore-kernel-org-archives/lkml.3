Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3A2DSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:18:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:50347 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3A2DSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:18:13 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-7c-51073f71c541
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] rtc: rtc-s3c: Use dev_dbg() instaed of pr_debug()
Date: Tue, 29 Jan 2013 12:18:09 +0900
Message-id: <00a701cdfdcf$436d3320$ca479960$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac39z0KV18SdeDW1RF2NLHEfeNqfVg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zI91Ce/ZAg4ZPhhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugSvj8o5JrAX3pCpWH3zK2MA4QayLkZNDQsBEYvrt/8wQtpjEhXvr
	2boYuTiEBJYxSpzc0cMCUzR5wSlmiMQiRok3P5eAJYQEZjNJbP2cCGKzCahJfPlymL2LkYND
	REBfoq1FA6SeWaCXUeJM7252kBphASeJB3dOMYHYLAKqEm/67oPFeQVsJU5PPMICYQtK/Jh8
	D8xmFtCSWL/zOBOELS+xec1bZpD5EgLqEo/+6oKERQT0JI4t2MQGUSIise/FO0aQvRIC/ewS
	vXMeskLsEpD4NvkQC0SvrMSmA1APS0ocXHGDZQKj2Cwkm2ch2TwLyeZZSFYsYGRZxSiaWpBc
	UJyUnmuoV5yYW1yal66XnJ+7iRESKVI7GFc2WBxiFOBgVOLhbVjAFijEmlhWXJl7iFGCg1lJ
	hPedOHugEG9KYmVValF+fFFpTmrxIcZkoGMnMkuJJucDozivJN7Q2NjEzMTUxNzS1NyUNGEl
	cV7GU08ChATSE0tSs1NTC1KLYLYwcXBKNTAmeR6edLFJNEyNtUJ94VLFhfdfR267suBzxu7r
	krd5a5fdk+XuUbc7VNDh/nOT6cJn0laKmrPnGu/Q12G3mP70NdvORd+trv9rt398ulpjobaP
	mrlcs+B1ubK6tvtbL02eZ6r97bUc26JpAk87drzufj6xy5a95ktKbZfurzWvcv5PZjhfzLVA
	iaU4I9FQi7moOBEAngfAjdgCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAd1Ce/ZAg489OhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/KOSawF96QqVh98ytjA
	OEGsi5GTQ0LARGLyglPMELaYxIV769m6GLk4hAQWMUq8+bmEBSQhJDCbSWLr50QQm01ATeLL
	l8PsXYwcHCIC+hJtLRog9cwCvYwSZ3p3s4PUCAs4STy4c4oJxGYRUJV403cfLM4rYCtxeuIR
	FghbUOLH5HtgNrOAlsT6nceZIGx5ic1r3jKDzJcQUJd49FcXJCwioCdxbMEmNogSEYl9L94x
	TmAUmIVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMFx+ExqB+PK
	BotDjAIcjEo8vA0L2AKFWBPLiitzDzFKcDArifC+E2cPFOJNSaysSi3Kjy8qzUktPsSYDPTo
	RGYp0eR8YIrIK4k3NDYxM7I0MrMwMjE3J01YSZyX8dSTACGB9MSS1OzU1ILUIpgtTBycUg2M
	3o07dpbl1TMkrTWznlQccTZe8PY7i3d69Yq+v5d6lj+d9O6dhap06CXWdaW/y648DzjOc7/Q
	8cCupLNHnzRIWnrO5ZW7Gz7xQtB0Y0MrAYbQNX/V9Ld/dTua+n13SieTmeGrh4Xn5lWdd2a6
	vqElOvXmxw/L39r82Fi/QVwnJ011N1PMs0Y+JZbijERDLeai4kQAmRB/owcDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use dev_dbg() instaed of pr_debug() to be consistent.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-s3c.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 0c397ac..fb994e9 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -115,7 +115,7 @@ static int s3c_rtc_setaie(struct device *dev, unsigned int enabled)
 {
 	unsigned int tmp;
 
-	pr_debug("%s: aie=%d\n", __func__, enabled);
+	dev_dbg(dev, "%s: aie=%d\n", __func__, enabled);
 
 	clk_enable(rtc_clk);
 	tmp = readb(s3c_rtc_base + S3C2410_RTCALM) & ~S3C2410_RTCALM_ALMEN;
@@ -203,7 +203,7 @@ static int s3c_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 
 	rtc_tm->tm_year += 100;
 
-	pr_debug("read time %04d.%02d.%02d %02d:%02d:%02d\n",
+	dev_dbg(dev, "read time %04d.%02d.%02d %02d:%02d:%02d\n",
 		 1900 + rtc_tm->tm_year, rtc_tm->tm_mon, rtc_tm->tm_mday,
 		 rtc_tm->tm_hour, rtc_tm->tm_min, rtc_tm->tm_sec);
 
@@ -218,7 +218,7 @@ static int s3c_rtc_settime(struct device *dev, struct rtc_time *tm)
 	void __iomem *base = s3c_rtc_base;
 	int year = tm->tm_year - 100;
 
-	pr_debug("set time %04d.%02d.%02d %02d:%02d:%02d\n",
+	dev_dbg(dev, "set time %04d.%02d.%02d %02d:%02d:%02d\n",
 		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
 
@@ -259,7 +259,7 @@ static int s3c_rtc_getalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	alrm->enabled = (alm_en & S3C2410_RTCALM_ALMEN) ? 1 : 0;
 
-	pr_debug("read alarm %d, %04d.%02d.%02d %02d:%02d:%02d\n",
+	dev_dbg(dev, "read alarm %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alm_en,
 		 1900 + alm_tm->tm_year, alm_tm->tm_mon, alm_tm->tm_mday,
 		 alm_tm->tm_hour, alm_tm->tm_min, alm_tm->tm_sec);
@@ -310,7 +310,7 @@ static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	unsigned int alrm_en;
 
 	clk_enable(rtc_clk);
-	pr_debug("s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
+	dev_dbg(dev, "s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alrm->enabled,
 		 1900 + tm->tm_year, tm->tm_mon + 1, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
@@ -333,7 +333,7 @@ static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 		writeb(bin2bcd(tm->tm_hour), base + S3C2410_ALMHOUR);
 	}
 
-	pr_debug("setting S3C2410_RTCALM to %08x\n", alrm_en);
+	dev_dbg(dev, "setting S3C2410_RTCALM to %08x\n", alrm_en);
 
 	writeb(alrm_en, base + S3C2410_RTCALM);
 
@@ -459,7 +459,7 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 	int ret;
 	int tmp;
 
-	pr_debug("%s: probe=%p\n", __func__, pdev);
+	dev_dbg(&pdev->dev, "%s: probe=%p\n", __func__, pdev);
 
 	/* find the IRQs */
 
@@ -475,7 +475,7 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 		return s3c_rtc_alarmno;
 	}
 
-	pr_debug("s3c2410_rtc: tick irq %d, alarm irq %d\n",
+	dev_dbg(&pdev->dev, "s3c2410_rtc: tick irq %d, alarm irq %d\n",
 		 s3c_rtc_tickno, s3c_rtc_alarmno);
 
 	/* get the memory region */
@@ -504,7 +504,7 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 
 	s3c_rtc_enable(pdev, 1);
 
-	pr_debug("s3c2410_rtc: RTCCON=%02x\n",
+	dev_dbg(&pdev->dev, "s3c2410_rtc: RTCCON=%02x\n",
 		 readw(s3c_rtc_base + S3C2410_RTCCON));
 
 	device_init_wakeup(&pdev->dev, 1);
-- 
1.7.2.5


