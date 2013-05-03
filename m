Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224Ab3ECGi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:38:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:61817 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933166Ab3ECGiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:38:25 -0400
X-AuditID: cbfee691-b7fe56d000004b96-9e-51835b608773
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>,
        "'Tony Prisk'" <linux@prisktech.co.nz>
Subject: [PATCH 38/42] rtc: rtc-vt8500: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:38:23 +0900
Message-id: <003401ce47c8$cf834140$6e89c3c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyMCJvi+FvwBYTtqptkYopqE4uQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKIsWRmVeSWpSXmKPExsVy+t8zY92E6OZAg84WeYslF6+yW8xZv4bN
	4vLCS6wWl3fNYbNoubyC2WJ/ZwejA5vHnokn2TxOzPjN4nH+fwu7R9+WVYwe0+f9ZPL4vEku
	gC2KyyYlNSezLLVI3y6BK+PN1y6WgoNsFTNvhzQwbmTtYuTkkBAwkfh5+SA7hC0mceHeerYu
	Ri4OIYFljBKLHzcxwhRd/3yCHSKxiFFi5rodQA4HkPOLUeKqDEgNm4CaxJcvh8HCIgL6Em0t
	GiDlzAKbGSVar7YygsSFBYIlJl2xBylnEVCV+NXSDjaeV8BSonfRShYIW1Dix+R7YDazgJbE
	+p3HmSBseYnNa94yQ5yjILHj7GtGiFV6Etd+WUCUiEjse/EO6uJz7BJn/4dBrBKQ+Db5EAtI
	uYSArMSmA1BTJCUOrrjBMoFRbBaSxbOQLJ6FZPEsJBsWMLKsYhRNLUguKE5KLzLVK07MLS7N
	S9dLzs/dxAiJwok7GO8fsD7EmAy0fiKzlGhyPjCK80riDY3NjCxMTUyNjcwtzUgTVhLnVW+x
	DhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAWDfvwwymte99Hh7hvbJ4guFd2yOLDN2NRGau
	Ltm00XfftMSTbQHK2zRTYi3u/20o/Npz7sqnaY1TWnJsOi8eN/yhMqlqYm5SuNRsxX9GUfOz
	T+QYzX0gsclLb9651cfDuD/FWagVbZIPKX3JXH1/0o8gpge7/bRLt1w5fqh7xaaNm9ZwX3K4
	xqfEUpyRaKjFXFScCABLLtYG2AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMKsWRmVeSWpSXmKPExsVy+t9jAd2E6OZAg7sbpS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h82i5fIKZov9nR2MDmweeyaeZPM4MeM3i8f5/y3sHn1bVjF6TJ/3k8nj8ya5
	ALaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKA7
	lBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZb752sRQcZKuYeTukgXEj
	axcjJ4eEgInE9c8n2CFsMYkL99azdTFycQgJLGKUmLluB1CCA8j5xShxVQakhk1ATeLLl8Ng
	YREBfYm2Fg2QcmaBzYwSrVdbGUHiwgLBEpOu2IOUswioSvxqaWcEsXkFLCV6F61kgbAFJX5M
	vgdmMwtoSazfeZwJwpaX2LzmLTPEOQoSO86+ZoRYpSdx7ZcFRImIxL4X7xgnMArMQjJpFpJJ
	s5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Ch/JrWDcWWDxSFGAQ5GJR5e
	hZamQCHWxLLiytxDjBIczEoivG4/gEK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0xAeSXx
	hsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAODFf3CfhYYHIb4PN
	f7+zLxSO/a3/Pn/XyVsa3xTevDOcutPLuyS2Vfgvt+hy0Vvbdp7fWBAyK9dwSZTFI/P/bM8Y
	d/95/eFN7JmTnImP5skVNLwL/5jOeHRf3wr+0o1pb5+XF5lNykj8flSy5cvDOQ1b9zPrl39e
	dfT1VM6KSP+++WGO029dNFFiKc5INNRiLipOBADo73P2NgMAAA==
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
 drivers/rtc/rtc-vt8500.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-vt8500.c b/drivers/rtc/rtc-vt8500.c
index d89efee..c2d6331 100644
--- a/drivers/rtc/rtc-vt8500.c
+++ b/drivers/rtc/rtc-vt8500.c
@@ -282,8 +282,6 @@ static int vt8500_rtc_remove(struct platform_device *pdev)
 	/* Disable alarm matching */
 	writel(0, vt8500_rtc->regbase + VT8500_RTC_IS);
 
-	platform_set_drvdata(pdev, NULL);
-
 	return 0;
 }
 
-- 
1.7.2.5


