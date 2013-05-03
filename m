Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762739Ab3ECGbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:31:23 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21781 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762722Ab3ECGbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:31:20 -0400
X-AuditID: cbfee690-b7f136d000000fea-50-518359b7fb64
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 20/42] rtc: rtc-lpc32xx: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:31:18 +0900
Message-id: <002201ce47c7$d226b860$76742920$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hx9FMbiiI9x4DQ4SO12OWWZQZ2w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zA93tkc2BBms6eS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKuNLwnbVgD0fFvelcDYy/2boYOTkkBEwkHs3bzQxhi0lcuLceKM7FISSwjFFiYds/
	dpiiK+8vskAkpjNKnG/ZCdYhJPCLUeJddyKIzSagJvHly2GgBg4OEQF9ibYWDZB6ZoFuRolH
	zXPB6oUFQiTubNoKNpRFQFXiz59nTCA2r4ClRNvnU8wQtqDEj8n3WEBsZgEtifU7jzNB2PIS
	m9e8hbpUQWLH2deMILaIgJ7ExS+PGSFqRCT2vXjHCLJYQuAYu8SFOV+YIZYJSHybfIgF5DgJ
	AVmJTQeg5khKHFxxg2UCo9gsJKtnIVk9C8nqWUhWLGBkWcUomlqQXFCclF5kolecmFtcmpeu
	l5yfu4kREnkTdjDeO2B9iDEZaP1EZinR5Hxg5OaVxBsamxlZmJqYGhuZW5qRJqwkzqveYh0o
	JJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgZFJpTDQPzRdcXfS3xNvrayWrvUW1ezcf+ikLOfx
	uvVRFz8/yG9VUJsf5zrh7dWyRft/f7/wOPRuG7tYevCV1RLewRE6HEZH3nKxHGG9pLb3ff/z
	zTMLyyWUfoYdfeZptOF3zYQzldemn/7b7i9mU3qEwdrKLrnisXZw0YbZ2gt2HZxTnH/mU6QS
	S3FGoqEWc1FxIgBC/aIl0gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQd3tkc2BBrvmcVosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHGl4TtrwR6OinvTuRoYf7N1MXJySAiYSFx5
	f5EFwhaTuHBvPVCci0NIYDqjxPmWncwgCSGBX4wS77oTQWw2ATWJL18Os3cxcnCICOhLtLVo
	gNQzC3QzSjxqngtWLywQInFn01Z2EJtFQFXiz59nTCA2r4ClRNvnU8wQtqDEj8n3wBYzC2hJ
	rN95nAnClpfYvOYtM8RBChI7zr5mBLFFBPQkLn55zAhRIyKx78U7xgmMArOQjJqFZNQsJKNm
	IWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4rp9J72Bc1WBxiFGAg1GJh1ehpSlQ
	iDWxrLgy9xCjBAezkgiv2w+gEG9KYmVValF+fFFpTmrxIcZkoE8nMkuJJucDU05eSbyhsYmZ
	kaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTByMxdyNPbs9+P0TJqnfUmu
	qDnit912lZaDr3j2K4ubP1O3trtqHXnJanfc9rduN53Tw9fo/AmZGd7zKPOAh4B4XmNYYsyJ
	doZ7R/R+v7yxgjWok+FN3NlTP7pLTizPO7byjnkw/zLBbDXWqcn7P0UoTNiZ7d4RbVT2LclY
	vvHx8V3uL4OCJiqxFGckGmoxFxUnAgCHhzwPLwMAAA==
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
 drivers/rtc/rtc-lpc32xx.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-lpc32xx.c b/drivers/rtc/rtc-lpc32xx.c
index 787550d..8276ae9 100644
--- a/drivers/rtc/rtc-lpc32xx.c
+++ b/drivers/rtc/rtc-lpc32xx.c
@@ -277,7 +277,6 @@ static int lpc32xx_rtc_probe(struct platform_device *pdev)
 					&lpc32xx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		dev_err(&pdev->dev, "Can't get RTC\n");
-		platform_set_drvdata(pdev, NULL);
 		return PTR_ERR(rtc->rtc);
 	}
 
@@ -306,8 +305,6 @@ static int lpc32xx_rtc_remove(struct platform_device *pdev)
 	if (rtc->irq >= 0)
 		device_init_wakeup(&pdev->dev, 0);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


