Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758525AbaKUNuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:50:35 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:15300 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880AbaKUNub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:50:31 -0500
X-AuditID: cbfee68f-f791c6d000004834-6a-546f4325a231
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org, balbi@ti.com,
        kishon@ti.com
Cc: linux-omap@vger.kernel.org, gregkh@linuxfoundation.org,
        tomasz.figa@gmail.com, s.nawrocki@samsung.com, robh+dt@kernel.org,
        stern@rowland.harvard.edu, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 07/11] phy: exynos7-usbdrd: Update dependency for ARCH_EXYNOS
Date: Fri, 21 Nov 2014 19:05:50 +0530
Message-id: <1416576954-11997-8-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
References: <1416576954-11997-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42JZI2JSp6vqnB9isPSwrMXB+/UW84+cY7Vo
	u3KQ3aJ58Xo2i94FV9ksLjztYbO4vGsOm8XsJf0sFjPO72OyWLSsldmide8RdovDb9pZLSb8
	vsBmsWrXH0YHPo+ds+6ye2xa1cnmsX/uGnaP2Xd/MHr0bVnF6HH8xnYmj8+b5ALYo7hsUlJz
	MstSi/TtErgyJixPLDjJWvG0q4utgfEESxcjB4eEgInErt9+XYycQKaYxIV769lAbCGBpYwS
	P04HQMRNJFo2v2DqYuQCik9nlDh8eC0rhDOBSWLlzS0sIFVsAroSTW93MYLYIgKzGSXaDgqB
	FDEL3GOU+Pz+O1iRsICvxIyXS5lAbBYBVYlZk68xgVzBK+Ah8eMkG8RBChJzJtmAVHAKeEq0
	rL/MBHGQh8SaXbsZQUZKCNxil3hweiUrxBgBiW+TD0E9Iyux6QAzxNGSEgdX3GCZwCi8gJFh
	FaNoakFyQXFSepGxXnFibnFpXrpecn7uJkZg5Jz+96x/B+PdA9aHGAU4GJV4eD9MzwsRYk0s
	K67MPcRoCrRhIrOUaHI+MD7zSuINjc2MLExNTI2NzC3NlMR5F0r9DBYSSE8sSc1OTS1ILYov
	Ks1JLT7EyMTBKdXAWM+nE781yTC7W/jjFb3PXY+q1qv/nHjYgO158q85ASZ2Ny1zZuu8nmEn
	HtfyeN6ap+/9vCZLnfsjmyfkcLjydeWHLTPv2LWG/tks26p8xuhdRNSqS0qzNj0u2qNxc5JL
	+TnlrF/v4lN3iRkXLjx7zVW6+XXltM3THr090vux9N6KNRdWlB2dGqPEUpyRaKjFXFScCAAG
	tYKwlwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jQV1V5/wQgzcTRCwO3q+3mH/kHKtF
	25WD7BbNi9ezWfQuuMpmceFpD5vF5V1z2CxmL+lnsZhxfh+TxaJlrcwWrXuPsFscftPOajHh
	9wU2i1W7/jA68HnsnHWX3WPTqk42j/1z17B7zL77g9Gjb8sqRo/jN7YzeXzeJBfAHtXAaJOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdLOSQlliTilQ
	KCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMWPC8sSCk6wVT7u62BoYT7B0MXJySAiY
	SLRsfsEEYYtJXLi3nq2LkYtDSGA6o8Thw2tZIZwJTBIrb24B62AT0JVoeruLEcQWEZjNKNF2
	UAikiFngHqPE5/ffwYqEBXwlZrxcCjaWRUBVYtbka0A2BwevgIfEj5NsIKaEgILEnEk2IBWc
	Ap4SLesvg1ULAVWs2bWbcQIj7wJGhlWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwbH5TGoH
	48oGi0OMAhyMSjy8H6bnhQixJpYVV+YeYpTgYFYS4S0Xzg8R4k1JrKxKLcqPLyrNSS0+xGgK
	dNNEZinR5Hxg2sgriTc0NjE3NTa1NLEwMbNUEue9cTM3REggPbEkNTs1tSC1CKaPiYNTqoHR
	rXuqodVHvcBNbB0Xiw9UZ+5cbO7xcJHEmYY/01JeKjoxSX+MuFKm96xq1WX1ihnbnDk0Tz15
	2nyRr0IlkCfu3YIj0y8969h+UUqlqqAy9Xv0yrITf0RLFxXub9rnr2zI6lRgyjpx5Tc5m1cv
	CjXK31ueuhG5UWrXDou5J4OCVogKXFuxe5KZEktxRqKhFnNRcSIAPpe27uMCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This PHY controller is also present on Exynos7 platform
in arch-exynos family.
So PHY_EXYNOS5_USBDRD should now depend on ARCH_EXYNOS.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/phy/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 2a436e6..1514e40 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -193,7 +193,7 @@ config PHY_EXYNOS5250_USB2
 
 config PHY_EXYNOS5_USBDRD
 	tristate "Exynos5 SoC series USB DRD PHY driver"
-	depends on ARCH_EXYNOS5 && OF
+	depends on ARCH_EXYNOS && OF
 	depends on HAS_IOMEM
 	depends on USB_DWC3_EXYNOS
 	select GENERIC_PHY
-- 
1.7.10.4

