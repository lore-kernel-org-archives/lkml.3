Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3BUIiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:38:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:18132 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3BUIiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:38:03 -0500
X-AuditID: cbfee691-b7f556d000001a24-31-5125dcea6c85
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
In-reply-to: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
Subject: [PATCH 12/12] rtc: rtc-davinci: use devm_*() functions
Date: Thu, 21 Feb 2013 17:38:02 +0900
Message-id: <00d701ce100e$c2a4a640$47edf2c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QDe9M0/OnFjrjTvSUwIYm7R1WAgAAMbZg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zQ91Xd1QDDSZe17O4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ09ZPZCloEau4tuMeUwPjIqEuRk4OCQETic45S1khbDGJC/fW
	s3UxcnEICSxjlGi5vIIVpujuxYVMEInpjBLHDj5lhnBmM0msPPSODaSKTUBN4suXw+xdjBwc
	IgL6Em0tGiA1zAK9jBJnenezg9QICdhKzPlwjRnE5hSwk7i87QvYBmEBe4n78y8zgdgsAqoS
	TRf+gMV5geoPnZzNCGELSvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmkL0SAuoSj/7qgoRFBIwk
	vm2CKReR2PfiHSPIPRICy9glds7tZofYJSDxbfIhFoheWYlNB5ghHpaUOLjiBssERolZSDbP
	QrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjJLYm7mC8f8D6EGMy0PqJ
	zFKiyfnA2MwriTc0NjYxMzE1Mbc0NTclTVhJnFf+kkygkEB6YklqdmpqQWpRfFFpTmrxIUYm
	Dk6pBsbiL+1fnhq3L/t79ofSH8n7AqIrxDNrqpc+ilipevLhmv4NL0IYQ/6uam+fxBK8lpul
	ZeqpT6w5vw4UzLiQmbdaLsHSx4Zhx6u4bOMNH6tYNFe2/k91rv3MdEqnznNh7mpZx9Y/09wd
	nTr7Fy9jt0vPEdbR1ndc/rgnyERlRVWt39YZU7jf/FZiKc5INNRiLipOBAD/XCTLwwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoO6rO6qBBvfvaFlc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjGnrJ7IUtIhVXNtxj6mB
	cZFQFyMnh4SAicTdiwuZIGwxiQv31rN1MXJxCAlMZ5Q4dvApM4Qzm0li5aF3bCBVbAJqEl++
	HGbvYuTgEBHQl2hr0QCpYRboZZQ407ubHaRGSMBWYs6Ha8wgNqeAncTlbV9YQWxhAXuJ+/Mv
	g21jEVCVaLrwByzOC1R/6ORsRghbUOLH5HssIDazgJbE+p3HmSBseYnNa94yg+yVEFCXePRX
	FyQsImAk8W0TTLmIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi
	0rx0veT83E2M4Mh9JrWDcWWDxSFGAQ5GJR7eBS9VAoVYE8uKK3MPMUpwMCuJ8CreVg0U4k1J
	rKxKLcqPLyrNSS0+xJgM9OhEZinR5HxgUskriTc0NjEzsjQyszAyMTcnTVhJnJfx1JMAIYH0
	xJLU7NTUgtQimC1MHJxSwETGcPV87o4oAbXYO5/z62xYWs7FbLre7ROfvGXxuRUPlog08U16
	fsL+UEi06yzOGiWJqinLPGvmnHzc90PrcATz4qONa6r8fIInu+5YbuLKrXSgRtz4U/Zaw/2e
	eZvfaDAE2oUquatbrZz6TLClPEU50Y5/4g6mPP2TU+4q/1j8vvg3q2L7ZiWW4oxEQy3mouJE
	AO1ZVwcgAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-davinci.c |   28 ++++++++++------------------
 1 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index 5f7982f..56b7308 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -506,19 +506,19 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 	davinci_rtc->pbase = res->start;
 	davinci_rtc->base_size = resource_size(res);
 
-	mem = request_mem_region(davinci_rtc->pbase, davinci_rtc->base_size,
-				 pdev->name);
+	mem = devm_request_mem_region(dev, davinci_rtc->pbase,
+				davinci_rtc->base_size, pdev->name);
 	if (!mem) {
 		dev_err(dev, "RTC registers at %08x are not free\n",
 			davinci_rtc->pbase);
 		return -EBUSY;
 	}
 
-	davinci_rtc->base = ioremap(davinci_rtc->pbase, davinci_rtc->base_size);
+	davinci_rtc->base = devm_ioremap(dev, davinci_rtc->pbase,
+					davinci_rtc->base_size);
 	if (!davinci_rtc->base) {
 		dev_err(dev, "unable to ioremap MEM resource\n");
-		ret = -ENOMEM;
-		goto fail2;
+		return -ENOMEM;
 	}
 
 	platform_set_drvdata(pdev, davinci_rtc);
@@ -529,7 +529,7 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 		ret = PTR_ERR(davinci_rtc->rtc);
 		dev_err(dev, "unable to register RTC device, err %d\n",
 				ret);
-		goto fail3;
+		goto fail1;
 	}
 
 	rtcif_write(davinci_rtc, PRTCIF_INTFLG_RTCSS, PRTCIF_INTFLG);
@@ -539,11 +539,11 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 	rtcss_write(davinci_rtc, 0, PRTCSS_RTC_CTRL);
 	rtcss_write(davinci_rtc, 0, PRTCSS_RTC_CCTRL);
 
-	ret = request_irq(davinci_rtc->irq, davinci_rtc_interrupt,
+	ret = devm_request_irq(dev, davinci_rtc->irq, davinci_rtc_interrupt,
 			  0, "davinci_rtc", davinci_rtc);
 	if (ret < 0) {
 		dev_err(dev, "unable to register davinci RTC interrupt\n");
-		goto fail4;
+		goto fail2;
 	}
 
 	/* Enable interrupts */
@@ -557,13 +557,10 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 
 	return 0;
 
-fail4:
+fail2:
 	rtc_device_unregister(davinci_rtc->rtc);
-fail3:
+fail1:
 	platform_set_drvdata(pdev, NULL);
-	iounmap(davinci_rtc->base);
-fail2:
-	release_mem_region(davinci_rtc->pbase, davinci_rtc->base_size);
 	return ret;
 }
 
@@ -575,13 +572,8 @@ static int davinci_rtc_remove(struct platform_device *pdev)
 
 	rtcif_write(davinci_rtc, 0, PRTCIF_INTEN);
 
-	free_irq(davinci_rtc->irq, davinci_rtc);
-
 	rtc_device_unregister(davinci_rtc->rtc);
 
-	iounmap(davinci_rtc->base);
-	release_mem_region(davinci_rtc->pbase, davinci_rtc->base_size);
-
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.2.5


