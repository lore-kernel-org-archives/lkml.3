Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3AXNjf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 08:39:35 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:43200 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab3AXNjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 08:39:23 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-8b-510139898243
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, stern@rowland.harvard.edu, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        dianders@chromium.org, jg1.han@samsung.com, cpgs@samsung.com
Subject: [PATCH v2 1/2] usb: ehci-s5p/ohci-exynos: Fix compatible strings for
 the device
Date: Thu, 24 Jan 2013 19:15:29 +0530
Message-id: <1359035130-22667-2-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1359035130-22667-1-git-send-email-gautam.vivek@samsung.com>
References: <1359035130-22667-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkVrfTkjHQYNVKMYvLu+awWcw4v4/J
	YtGyVmYHZo/Pm+QCGKO4bFJSczLLUov07RK4Mta9FSxo4K6YNf8qWwPjSs4uRk4OCQETiTXn
	pjBC2GISF+6tZ+ti5OIQEljKKLFm5XIWmKI9H3uZIBLTGSX6Tm5mh3AmM0kce7aLGaSKTUBX
	ountLrBRIgKyEoev/GYGKWIW+Mkkca5rExtIQlggSuLV9resIDaLgKpEx4xpYDavgIfEoq8d
	zBDrFCTe3H4GZnMKeErMmdUM1isEVNPc3s8CMlRC4DGbxKJ519kgBglIfJt8CCjBAZSQldh0
	AGqOpMTBFTdYJjAKL2BkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRGJin/z2T2sG4ssHi
	EKMAB6MSD6+CKkOgEGtiWXFl7iFGCQ5mJRHe9SyMgUK8KYmVValF+fFFpTmpxYcYk4GWT2SW
	Ek3OB0ZNXkm8obGJuamxqaWRkZmpKWnCSuK8jKeeBAgJpCeWpGanphakFsFsYeLglGpg3CmY
	NV0uS9H1Hqv7kWKJCb++7RNntM3ouXkx/sqG49zbPEvD+Nw/8zryXV0nnjrxbMemUL4LZ2Ys
	2qvzrbmvq9jP64rasXfnrzssdyg4coGpJbB765zp8/T1Jp+y3WbW2nD9RUGfhvXvW8xMtyS2
	vIn++nBPnWrUVeELWUs4Py74M23rmbjr65RYijMSDbWYi4oTAfU8hoWQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t9jQd1OS8ZAg8UHmS0u75rDZjHj/D4m
	i0XLWpkdmD0+b5ILYIxqYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
	tVVy8QnQdcvMAZqvpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcxY91aw
	oIG7Ytb8q2wNjCs5uxg5OSQETCT2fOxlgrDFJC7cW8/WxcjFISQwnVGi7+RmdghnMpPEsWe7
	mEGq2AR0JZre7mIEsUUEZCUOX/nNDFLELPCTSeJc1yY2kISwQJTEq+1vWUFsFgFViY4Z08Bs
	XgEPiUVfO5gh1ilIvLn9DMzmFPCUmDOrGaxXCKimub2fZQIj7wJGhlWMoqkFyQXFSem5hnrF
	ibnFpXnpesn5uZsYwWH/TGoH48oGi0OMAhyMSjy8CqoMgUKsiWXFlbmHGCU4mJVEeNezMAYK
	8aYkVlalFuXHF5XmpBYfYkwGumois5Rocj4wJvNK4g2NTcxNjU0tTSxMzCxJE1YS52U89SRA
	SCA9sSQ1OzW1ILUIZgsTB6dUA+Pu9h51E7+N570EFuYpn3q50HLjwhVbHaeLBswtMGa/5nfq
	wUoD163BWxaLLH9+brn3RYmYc8sE85z2GGTqBbzcK/tlzeoJHG8c/2bVLpluZBuaqTD1Z119
	tPnZrSxzHXOj6s8+TLcTVuZq8N3NviBSufeR3bRPkWuOpvQt365SsPSm8emK1D4lluKMREMt
	5qLiRAAB0S8BvwIAAA==
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
 drivers/usb/host/ehci-s5p.c    |    2 +-
 drivers/usb/host/ohci-exynos.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
index 319dcfa..f18e6ac 100644
--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -266,7 +266,7 @@ static const struct dev_pm_ops s5p_ehci_pm_ops = {
 
 #ifdef CONFIG_OF
 static const struct of_device_id exynos_ehci_match[] = {
-	{ .compatible = "samsung,exynos-ehci" },
+	{ .compatible = "samsung,exynos4210-ehci" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, exynos_ehci_match);
diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
index aa3b884..77f2017 100644
--- a/drivers/usb/host/ohci-exynos.c
+++ b/drivers/usb/host/ohci-exynos.c
@@ -267,7 +267,7 @@ static const struct dev_pm_ops exynos_ohci_pm_ops = {
 
 #ifdef CONFIG_OF
 static const struct of_device_id exynos_ohci_match[] = {
-	{ .compatible = "samsung,exynos-ohci" },
+	{ .compatible = "samsung,exynos4210-ohci" },
 	{},
 };
 MODULE_DEVICE_TABLE(of, exynos_ohci_match);
-- 
1.7.6.5

