Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbaKUNq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:46:27 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14981 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758640AbaKUNqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:46:24 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-a5-546f422c8501
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org, balbi@ti.com,
        kishon@ti.com
Cc: linux-omap@vger.kernel.org, gregkh@linuxfoundation.org,
        tomasz.figa@gmail.com, s.nawrocki@samsung.com, robh+dt@kernel.org,
        stern@rowland.harvard.edu, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 03/11] dwc3: exynos: Add provision for suspend clock
Date: Fri, 21 Nov 2014 19:05:46 +0530
Message-id: <1416576954-11997-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
References: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42JZI2JSq6vjlB9icOIPv8XB+/UW84+cY7Vo
	u3KQ3aJ58Xo2i94FV9ksLjztYbO4vGsOm8XsJf0sFjPO72OyWLSsldmide8RdovDb9pZLSb8
	vsBmsWrXH0YHPo+ds+6ye2xa1cnmsX/uGnaP2Xd/MHr0bVnF6HH8xnYmj8+b5ALYo7hsUlJz
	MstSi/TtErgyLs+6zlrwn7eiY/5n9gbGB9xdjJwcEgImEstvbGSEsMUkLtxbz9bFyMUhJLCU
	UeLrsQVMMEVPFr5ih0hMZ5S4/q6PFcKZwCTR8ncRM0gVm4CuRNPbXWCjRARmM0q0HRQCKWIW
	uMco8fn9dxaQhLCAi8TiqatYQWwWAVWJZX9ega3gFfCQWL/oK1CcA2idgsScSTYgYU4BT4mW
	9ZfBSoSAStbs2s0IMlNC4B67RNfS6UwQcwQkvk0+xALRKyux6QAzxNWSEgdX3GCZwCi8gJFh
	FaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZgBJ3+92zCDsZ7B6wPMQpwMCrx8H6YnhcixJpY
	VlyZe4jRFGjDRGYp0eR8YJzmlcQbGpsZWZiamBobmVuaKYnzvpb6GSwkkJ5YkpqdmlqQWhRf
	VJqTWnyIkYmDU6qB0Xhvyd8ivkV6108svHx/ItMipgW7Wc+1VHRzBW2T9E+Vm2t3Subz9x/G
	X88+VuZr8fy8q0Bxke7unxc8lfcX+F3YcfOty0WZzZWiKgx6TlxfhQJPfH390XTyRcdrl/Oe
	W+/4fH9C+8Espm9rMqIjQ2q6F65/ZHbU2zhBLfy8e6z93xY535teHkosxRmJhlrMRcWJANiC
	j26bAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jQV0dp/wQg/ktbBYH79dbzD9yjtWi
	7cpBdovmxevZLHoXXGWzuPC0h83i8q45bBazl/SzWMw4v4/JYtGyVmaL1r1H2C0Ov2lntZjw
	+wKbxapdfxgd+Dx2zrrL7rFpVSebx/65a9g9Zt/9wejRt2UVo8fxG9uZPD5vkgtgj2pgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBullJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmHF51nXWgv+8FR3zP7M3MD7g7mLk5JAQ
	MJF4svAVO4QtJnHh3nq2LkYuDiGB6YwS19/1sUI4E5gkWv4uYgapYhPQlWh6u4sRxBYRmM0o
	0XZQCKSIWeAeo8Tn999ZQBLCAi4Si6euYgWxWQRUJZb9ecUEYvMKeEisX/QVKM4BtE5BYs4k
	G5Awp4CnRMv6y2AlQkAla3btZpzAyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnB8
	PpPawbiyweIQowAHoxIP74fpeSFCrIllxZW5hxglOJiVRHjLhfNDhHhTEiurUovy44tKc1KL
	DzGaAh01kVlKNDkfmDrySuINjU3MTY1NLU0sTMwslcR5b9zMDRESSE8sSc1OTS1ILYLpY+Lg
	lGpgzHr58cnqtY9zdpzgDYmZ+DjJWq9w6ZV9uS278/7v+WTCcJ59iTbfsXP8K9Vbjq5vPVhz
	otdlt37CyY+Rkp7sZiEJqRvtmfOlW0V/PQ+yndL5+H7CXO3qyEr9iuz4vH2rBHwUvQsUBRXP
	nSl4/1vn5Kk+n7Xh3xbfYEjg/PNyQWfmnNX+d7aHKrEUZyQaajEXFScCAGXDDHTlAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DWC3 controller on Exynos SoC series have separate control for
suspend clock which replaces pipe3_rx_pclk as clock source to
a small part of DWC3 core that operates when SS PHY is in its
lowest power state (P3) in states SS.disabled and U3.

Suggested-by: Anton Tikhomirov <av.tikhomirov@samsung.com>
Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/dwc3/dwc3-exynos.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 7109de7..af15ab3 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -35,6 +35,8 @@ struct dwc3_exynos {
 	struct device		*dev;
 
 	struct clk		*clk;
+	struct clk		*susp_clk;
+
 	struct regulator	*vdd33;
 	struct regulator	*vdd10;
 };
@@ -141,6 +143,13 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 	}
 	clk_prepare_enable(exynos->clk);
 
+	exynos->susp_clk = devm_clk_get(dev, "usbdrd30_susp_clk");
+	if (IS_ERR(exynos->susp_clk)) {
+		dev_dbg(dev, "no suspend clk specified\n");
+		exynos->susp_clk = NULL;
+	}
+	clk_prepare_enable(exynos->susp_clk);
+
 	exynos->vdd33 = devm_regulator_get(dev, "vdd33");
 	if (IS_ERR(exynos->vdd33)) {
 		ret = PTR_ERR(exynos->vdd33);
@@ -182,6 +191,7 @@ err4:
 err3:
 	regulator_disable(exynos->vdd33);
 err2:
+	clk_disable_unprepare(exynos->susp_clk);
 	clk_disable_unprepare(exynos->clk);
 	return ret;
 }
@@ -194,6 +204,7 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
 	platform_device_unregister(exynos->usb2_phy);
 	platform_device_unregister(exynos->usb3_phy);
 
+	clk_disable_unprepare(exynos->susp_clk);
 	clk_disable_unprepare(exynos->clk);
 
 	regulator_disable(exynos->vdd33);
-- 
1.7.10.4

