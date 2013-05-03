Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762878Ab3ECGda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:33:30 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63955 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762770Ab3ECGd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:33:27 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-f2-51835a35c50c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 27/42] rtc: rtc-mxc: remove unnecessary platform_set_drvdata()
Date: Fri, 03 May 2013 15:33:25 +0900
Message-id: <002901ce47c8$1da1b010$58e51030$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyBzM9tIJOftdROqKIrZalUxImw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zI13TqOZAg2tHdCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKmPrhN0vBUs6KHxuXsTcwnmDvYuTkkBAwkZj44hMrhC0mceHeerYuRi4OIYFljBJr
	b+6GK9p4/BgLRGIRo8TWlx+hnF+MEjP3zWMCqWITUJP48uUwUAcHh4iAvkRbiwZIDbNAN6PE
	o+a5zCA1wgJ+Eo/a/oLVswioShxYf4UFxOYVsJSYdGMOK4QtKPFj8j2wOLOAlsT6nceZIGx5
	ic1r3jJDXKQgsePsa0YQW0RAT+LY6xWsEDUiEvtevGMEWSwhcIxdYt7R+WwQywQkvk0+xAJy
	nISArMSmA1BzJCUOrrjBMoFRbBaS1bOQrJ6FZPUsJCsWMLKsYhRNLUguKE5KLzLSK07MLS7N
	S9dLzs/dxAiJvr4djDcPWB9iTAZaP5FZSjQ5Hxi9eSXxhsZmRhamJqbGRuaWZqQJK4nzqrVY
	BwoJpCeWpGanphakFsUXleakFh9iZOLglGpgrGgUfmhp9UqknL3vVwnj82PrWNc1m4l+0imp
	t4hkV2j15eYucQ4T2Z0Sdvy1/MP/BqVCHQseODZb99x4+MRLUGGl6q5N/ItquFWFGGRePm/K
	51j/s/XbnscTfBbMXXHc66TQ49DbISVb73FOOR/5gfHFdY+Xnf9Mn7rWJNSKFMhXzT5YZcWv
	xFKckWioxVxUnAgAErH9ONQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAV3TqOZAg7MvNCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzJj64TdLwVLOih8bl7E3MJ5g72Lk5JAQMJHY
	ePwYC4QtJnHh3nq2LkYuDiGBRYwSW19+ZIFwfjFKzNw3jwmkik1ATeLLl8NA3RwcIgL6Em0t
	GiA1zALdjBKPmucyg9QIC/hJPGr7C1bPIqAqcWD9FbANvAKWEpNuzGGFsAUlfky+BxZnFtCS
	WL/zOBOELS+xec1bZoiLFCR2nH3NCGKLCOhJHHu9ghWiRkRi34t3jBMYBWYhGTULyahZSEbN
	QtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwbD+T3sG4qsHiEKMAB6MSD69CS1Og
	EGtiWXFl7iFGCQ5mJRFetx9AId6UxMqq1KL8+KLSnNTiQ4zJQJ9OZJYSTc4Hpp28knhDYxMz
	I0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamAUTSpO2rP10auvCZr2VbKX
	79ZJLC15cqJEc5eMuPC03/dvWsn2hz+eutdl4uLKUq99HtIHeQ9Z8eVc/Ls6ySk36vnpvx2W
	jBWGTCInf70J/S5ylMWSQUo4pOHWQfe1pzNOvDZbv+XQnv25uzhXH2C+9+zccvHag4zBOo/1
	I/gDelqChYsmZNxWYinOSDTUYi4qTgQA21kTzTEDAAA=
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
 drivers/rtc/rtc-mxc.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 9a3895b..57192c7 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -443,15 +443,13 @@ static int mxc_rtc_probe(struct platform_device *pdev)
 				  THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		ret = PTR_ERR(rtc);
-		goto exit_clr_drvdata;
+		goto exit_put_clk;
 	}
 
 	pdata->rtc = rtc;
 
 	return 0;
 
-exit_clr_drvdata:
-	platform_set_drvdata(pdev, NULL);
 exit_put_clk:
 	clk_disable_unprepare(pdata->clk);
 
@@ -465,7 +463,6 @@ static int mxc_rtc_remove(struct platform_device *pdev)
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
 	clk_disable_unprepare(pdata->clk);
-	platform_set_drvdata(pdev, NULL);
 
 	return 0;
 }
-- 
1.7.2.5


