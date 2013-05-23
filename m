Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757857Ab3EWKem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:34:42 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57702 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269Ab3EWKek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:34:40 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-d6-519df0bf5349
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] power: use platform_{get,set}_drvdata()
Date: Thu, 23 May 2013 19:34:39 +0900
Message-id: <002c01ce57a1$20ba3b30$622eb190$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5XoP8aOzboMTWiTGu5Wij9tTpQhA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zA939H+YGGsyaymdxcKumxcSVk5kt
	Li+8xGpxedccNgcWjwn9nxg9Nq/Q8ujbsorR4/MmuQCWKC6blNSczLLUIn27BK6Ml0efsBT8
	461YstGygbGRp4uRk0NCwERiw7KNbBC2mMSFe+uBbC4OIYFljBKz369ghymav+kBK0RiEaNE
	5/bPUM4vRonWu82sIFVsAmoSX74cBusQEdCQaFs9hQXEZhbIlzh86DKYLSxgIXF14RGwdSwC
	qhL3L+4Ai/MKWErcnHOCEcIWlPgx+R5Ur5bE+p3HmSBseYnNa94yQ1ykILHj7GtGiF16Eof7
	H7NC1IhI7HvxjhHkOAmBdewS+6d/gVomIPFt8iGgoRxACVmJTQeg5khKHFxxg2UCo9gsJKtn
	IVk9C8nqWUhWLGBkWcUomlqQXFCclF5kqFecmFtcmpeul5yfu4kREmO9OxhvH7A+xJgMtH4i
	s5Rocj4wRvNK4g2NzYwsTE1MjY3MLc1IE1YS51VrsQ4UEkhPLEnNTk0tSC2KLyrNSS0+xMjE
	wSnVwNj9rPtRX2gwl7Bpx8W0E3+D9pYe+trArRtd4f7t7SGhszsueb3WLuwpPLE4dIYp42IZ
	Cc2ad4cqPpss2/7tVLLPhxcPg+UvBtW/M5Y9kH9Pep+fSoHb8ruJEq9EPTNPaFlur7ydzZ8s
	ePpWoY2G3UFROYEdx217c2LeBbnY9rN2/mjVzxawVGIpzkg01GIuKk4EACXZdLzHAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd39H+YGGhzezmVxcKumxcSVk5kt
	Li+8xGpxedccNgcWjwn9nxg9Nq/Q8ujbsorR4/MmuQCWqAZGm4zUxJTUIoXUvOT8lMy8dFsl
	7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygjUoKZYk5pUChgMTiYiV9O0wTQkPcdC1g
	GiN0fUOC4HqMDNBAwjrGjJdHn7AU/OOtWLLRsoGxkaeLkZNDQsBEYv6mB6wQtpjEhXvr2boY
	uTiEBBYxSnRu/8wK4fxilGi92wxWxSagJvHly2F2EFtEQEOibfUUFhCbWSBf4vChy2C2sICF
	xNWFR9hAbBYBVYn7F3eAxXkFLCVuzjnBCGELSvyYfA+qV0ti/c7jTBC2vMTmNW+ZIS5SkNhx
	9jUjxC49icP9j1khakQk9r14xziBUWAWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6RUn
	5haX5qXrJefnbmIER/Az6R2MqxosDjEKcDAq8fBK3J4TKMSaWFZcmXuIUYKDWUmEd3PP3EAh
	3pTEyqrUovz4otKc1OJDjMlAn05klhJNzgcml7ySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcK
	CaQnlqRmp6YWpBbBbGHi4JRqYKz+cLyRmX/WvD/uL5ZKfPorzqdt4NIbxMk5+6zYwn8zqkKu
	671lCfOcZ77n0I1XCY+eCcb4Zx3i2/XWUCzZOYX5iqrFO/ljq2pesK1JL6j72Tk3YMq7pZl6
	zZm9rs9FVhx5c+909eynH1Z8ZnMrjw6yszPVq1PcMUvm5GRXq0OBnh8WhB86WKTEUpyRaKjF
	XFScCADC758dJAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/intel_mid_battery.c |    2 +-
 drivers/power/tps65090-charger.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/intel_mid_battery.c b/drivers/power/intel_mid_battery.c
index 18d136b..4520811 100644
--- a/drivers/power/intel_mid_battery.c
+++ b/drivers/power/intel_mid_battery.c
@@ -756,7 +756,7 @@ static int platform_pmic_battery_probe(struct platform_device *pdev)
 
 static int platform_pmic_battery_remove(struct platform_device *pdev)
 {
-	struct pmic_power_module_info *pbi = dev_get_drvdata(&pdev->dev);
+	struct pmic_power_module_info *pbi = platform_get_drvdata(pdev);
 
 	free_irq(pbi->irq, pbi);
 	cancel_delayed_work_sync(&pbi->monitor_battery);
diff --git a/drivers/power/tps65090-charger.c b/drivers/power/tps65090-charger.c
index 9fbca31..77ab856 100644
--- a/drivers/power/tps65090-charger.c
+++ b/drivers/power/tps65090-charger.c
@@ -218,7 +218,7 @@ static int tps65090_charger_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	dev_set_drvdata(&pdev->dev, cdata);
+	platform_set_drvdata(pdev, cdata);
 
 	cdata->dev			= &pdev->dev;
 	cdata->pdata			= pdata;
@@ -291,7 +291,7 @@ fail_unregister_supply:
 
 static int tps65090_charger_remove(struct platform_device *pdev)
 {
-	struct tps65090_charger *cdata = dev_get_drvdata(&pdev->dev);
+	struct tps65090_charger *cdata = platform_get_drvdata(pdev);
 
 	devm_free_irq(cdata->dev, cdata->irq, cdata);
 	power_supply_unregister(&cdata->ac);
-- 
1.7.10.4


