Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762632Ab3ECGYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:24:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58958 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762377Ab3ECGYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:24:54 -0400
X-AuditID: cbfee68d-b7f016d000007930-0f-51835834c8e6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 05/42] rtc: rtc-at32ap700x: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:24:52 +0900
Message-id: <001301ce47c6$ebd1b950$c3752bf0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hxuh/KnvOERtGQZOPSGL/Y1aO2g==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zQ12TiOZAg87V2hZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBlbG07zF7QIFSxaGsfYwPjZr4uRk4OCQETiQXXlrBB2GISF+6tB7K5OIQEljFKrOm6
	zg5T1H7iBztEYjqjxJ+GTVBVvxglWt4/AqtiE1CT+PLlMJDNwSEioC/R1qIBUsMs0M0o8ah5
	LjNIjbBAuMSkaQvA1rEIqEpM334HzOYVsJTYe3YpM4QtKPFj8j0WEJtZQEti/c7jTBC2vMTm
	NW+ZIS5SkNhx9jUjiC0ioCfx6sN+ZogaEYl9L94xgiyWEDjELtF+7TsrxDIBiW+TD7GAHCch
	ICux6QDUHEmJgytusExgFJuFZPUsJKtnIVk9C8mKBYwsqxhFUwuSC4qT0osM9YoTc4tL89L1
	kvNzNzFCoq93B+PtA9aHGJOB1k9klhJNzgdGb15JvKGxmZGFqYmpsZG5pRlpwkrivGot1oFC
	AumJJanZqakFqUXxRaU5qcWHGJk4OKUaGLMjBD9ePLNkV0t2qdPxu20c7MlrbDbfWfTtjcSM
	+aapsy61bOpd9OYI7zxzxeStTHeXtUXJC33fcdxfbp3vF4W5DK/ees12j+SZZOD0LNFqiqZJ
	gfkFpzTe1vuPBWO0WIUynr4oL+OQu8t5/a/7SQY7ifbW0ti58ytTgq/8Til5btj9baqNlhJL
	cUaioRZzUXEiAEwozaPUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQV2TiOZAgzPb1S2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNjadpi9oEGoYtHWPsYGxs18XYycHBICJhLt
	J36wQ9hiEhfurWfrYuTiEBKYzijxp2ETlPOLUaLl/SOwKjYBNYkvXw4D2RwcIgL6Em0tGiA1
	zALdjBKPmucyg9QIC4RLTJq2gA3EZhFQlZi+/Q6YzStgKbH37FJmCFtQ4sfkeywgNrOAlsT6
	nceZIGx5ic1r3jJDXKQgsePsa0YQW0RAT+LVh/3MEDUiEvtevGOcwCgwC8moWUhGzUIyahaS
	lgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmP7mfQOxlUNFocYBTgYlXh4FVqaAoVY
	E8uKK3MPMUpwMCuJ8Lr9AArxpiRWVqUW5ccXleakFh9iTAb6dCKzlGhyPjDt5JXEGxqbmBlZ
	GplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo/IG6YziqbNMtn+femnbPQXu
	sj1/cib8E2/dmrt68SOBIqHD580ecUzR3njkyJODXJu+XS+Y5XVoyU1dHQuff8wKV3Wn19V6
	SYn86y2//dTy58F0hdRrXF+artm+jeqO1fiUY9y8bd6nrjlH3IwWW1U2GehliWyVFjzQIzCx
	bPGF1bGOuUq21kosxRmJhlrMRcWJAJgftOIxAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-at32ap700x.c |   20 +++++---------------
 1 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/rtc/rtc-at32ap700x.c b/drivers/rtc/rtc-at32ap700x.c
index f47fbb5..4a5ccf1 100644
--- a/drivers/rtc/rtc-at32ap700x.c
+++ b/drivers/rtc/rtc-at32ap700x.c
@@ -212,23 +212,20 @@ static int __init at32_rtc_probe(struct platform_device *pdev)
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!regs) {
 		dev_dbg(&pdev->dev, "no mmio resource defined\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 
 	irq = platform_get_irq(pdev, 0);
 	if (irq <= 0) {
 		dev_dbg(&pdev->dev, "could not get irq\n");
-		ret = -ENXIO;
-		goto out;
+		return -ENXIO;
 	}
 
 	rtc->irq = irq;
 	rtc->regs = devm_ioremap(&pdev->dev, regs->start, resource_size(regs));
 	if (!rtc->regs) {
-		ret = -ENOMEM;
 		dev_dbg(&pdev->dev, "could not map I/O memory\n");
-		goto out;
+		return -ENOMEM;
 	}
 	spin_lock_init(&rtc->lock);
 
@@ -249,7 +246,7 @@ static int __init at32_rtc_probe(struct platform_device *pdev)
 				"rtc", rtc);
 	if (ret) {
 		dev_dbg(&pdev->dev, "could not request irq %d\n", irq);
-		goto out;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, rtc);
@@ -258,8 +255,7 @@ static int __init at32_rtc_probe(struct platform_device *pdev)
 				&at32_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		dev_dbg(&pdev->dev, "could not register rtc device\n");
-		ret = PTR_ERR(rtc->rtc);
-		goto out;
+		return PTR_ERR(rtc->rtc);
 	}
 
 	device_init_wakeup(&pdev->dev, 1);
@@ -268,18 +264,12 @@ static int __init at32_rtc_probe(struct platform_device *pdev)
 			(unsigned long)rtc->regs, rtc->irq);
 
 	return 0;
-
-out:
-	platform_set_drvdata(pdev, NULL);
-	return ret;
 }
 
 static int __exit at32_rtc_remove(struct platform_device *pdev)
 {
 	device_init_wakeup(&pdev->dev, 0);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


