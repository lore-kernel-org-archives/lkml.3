Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3AXNkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:40:15 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43289 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab3AXNkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:40:08 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-bb-510139b7f12a
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, stern@rowland.harvard.edu, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        dianders@chromium.org, jg1.han@samsung.com, cpgs@samsung.com
Subject: [PATCH v2 2/2] usb: dwc3-exynos: Fix compatible strings for the device
Date: Thu, 24 Jan 2013 19:15:30 +0530
Message-id: <1359035130-22667-3-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1359035130-22667-1-git-send-email-gautam.vivek@samsung.com>
References: <1359035130-22667-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkRne7JWOgwepWY4vLu+awWcw4v4/J
	YtGyVmYHZo/Pm+QCGKO4bFJSczLLUov07RK4Mh4sn8lY0MhesXXeLZYGxj+sXYycHBICJhKv
	NpxmgrDFJC7cW8/WxcjFISSwlFFi8qqDcEXLph1ihEhMZ5TYdGcBE4QzmUli45tb7CBVbAK6
	Ek1vdzGC2CICshKHr/xmBiliFvjJJHGuaxMbSEJYwF/iSPt5ZhCbRUBV4urEr0A2BwevgIfE
	5iYhiG0KEm9uPwMr4RTwlJgzqxmsVQiopLm9nwVkpoTAYzaJwz8vsELMEZD4NvkQC8gcCaDF
	mw4wQ8yRlDi44gbLBEbhBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzECA/P0v2fSOxhX
	NVgcYhTgYFTi4a1QZwgUYk0sK67MPcQowcGsJMK7noUxUIg3JbGyKrUoP76oNCe1+BBjMtDy
	icxSosn5wKjJK4k3NDYxNzU2tTQyMjM1JU1YSZyX8dSTACGB9MSS1OzU1ILUIpgtTBycUg2M
	PjXK/2oSQy0aOf/4sq5n3at8YV2+5l4dWy+lhI3G24t4NFY9tVIQPdfoqruweqkim8WkewmP
	K7crTy7wEHXNfpjTFPDx5Q0O+/yqZPl3274kWPIwtvpN+rtITOrywpfC6x0XC/6q7F33+ej2
	v3dCnFwFGdqtf4avbu6YHcy++n6DD9+9xOlKLMUZiYZazEXFiQCCOtdgkAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t9jQd3tloyBBpv7VCwu75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIxqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
	tVVy8QnQdcvMAZqvpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcx4sHwm
	Y0Eje8XWebdYGhj/sHYxcnJICJhILJt2iBHCFpO4cG89WxcjF4eQwHRGiU13FjBBOJOZJDa+
	ucUOUsUmoCvR9HYXWIeIgKzE4Su/mUGKmAV+Mkmc69rEBpIQFvCXONJ+nhnEZhFQlbg68SuQ
	zcHBK+AhsblJCGKbgsSb28/ASjgFPCXmzGoGaxUCKmlu72eZwMi7gJFhFaNoakFyQXFSeq6R
	XnFibnFpXrpecn7uJkZw2D+T3sG4qsHiEKMAB6MSD2+FOkOgEGtiWXFl7iFGCQ5mJRHe9SyM
	gUK8KYmVValF+fFFpTmpxYcYk4GOmsgsJZqcD4zJvJJ4Q2MTc1NjU0sTCxMzS9KElcR5GU89
	CRASSE8sSc1OTS1ILYLZwsTBKdXAmFYTp8Cj7vIlL9Qi3Vnp1bQF3qmf9GyXdKxh9153WahR
	mp+9+RXnm/Uq6/+w9oS4cKw5F3lo2e7PHY/LqxYXBxgfuGOUFfhE71se74GGbt+1dk1f/m2X
	WX92h8fBqg0nt76Js1l265MkX9bHFQI+dzmWfrH61VKrX8DaHMqsH1J3snZxwaElSizFGYmG
	WsxFxYkAX+ioa78CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using specific chip in compatible strings. Newer SOCs can claim
device by using older string in the compatible list.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Reviewed-by: Doug Anderson <dianders@chromium.org>
---
 drivers/usb/dwc3/dwc3-exynos.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index aae5328..e2207a6 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -188,7 +188,7 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
 
 #ifdef CONFIG_OF
 static const struct of_device_id exynos_dwc3_match[] = {
-	{ .compatible = "samsung,exynos-dwc3" },
+	{ .compatible = "samsung,exynos5250-dwusb3" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, exynos_dwc3_match);
-- 
1.7.6.5

