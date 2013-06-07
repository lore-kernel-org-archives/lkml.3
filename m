Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3FGJXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 05:23:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:58732 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067Ab3FGJXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 05:23:40 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-ec-51b1a69b224a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-pci@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Andrew Murray'" <andrew.murray@arm.com>,
        "'Thomas Petazzoni'" <thomas.petazzoni@free-electrons.com>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jason Gunthorpe'" <jgunthorpe@obsidianresearch.com>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V3 2/3] ARM: EXYNOS: Enable PCIe support for Exynos5440
Date: Fri, 07 Jun 2013 18:23:38 +0900
Message-id: <000e01ce6360$b1b20fd0$15162f70$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5jYK+13XTfPtCURYWCLm4bg8WPwA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t8zI93ZyzYGGmzbI2TR/H87q8WSpgyL
	A7Mfslq8OrORzeLywkusFt9vmFr0LrjKZrHp8TVWi8u75rBZnJ13nM1ixvl9TBYrmrYyWiy+
	uJzZYvfKJSwWx2YsYbR4+qCJyUHAY828NYwefVOusnk82XSR0WPBplKPO9f2sHlsXlLvcX7G
	QkaP7zt6gQq2rGL0+PlSx+PzJrkA7igum5TUnMyy1CJ9uwSujIcfPjMWTGevmLJtDUsD42vW
	LkZODgkBE4k9F48wQthiEhfurWfrYuTiEBJYxijxYHsTUIIDrOh1pyNEfBGjxLRVO8EahAR+
	MUpcvu0NYrMJqEl8+XKYHcQWEfCXuHa1lQWkgVngPYvE7R/7wLYJC7hLLNu2FKyZRUBV4u2/
	o2BxXgFLiZV/JkDZghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGeJSBYkdZ18zQizTk9jY84oV
	okZEYt+Ld4wgiyUEDnBIdBy6zQKxTEDi2+RDLBDfyEpsOgA1R1Li4IobLBMYxWYhWT0LyepZ
	SFbPQrJiASPLKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYyQ1DBhB+O9A9aHGJOB1k9klhJN
	zgemlrySeENjMyMLUxNTYyNzSzPShJXEedVbrAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1
	MPK+sdmeYeT028RExbOyn6Fl0dKq3dWXuNW3rJd+dLTm/oMzyS6XD685/XPF//YZW6ZtPqa+
	MjJTXLQ8YQtj+cOtpRGeG+1vHVc2Lep9qWQjK1Pp6jDJtvr4xstPDNQFKm7t2P0y+KGcqQiT
	06TYE7xvo2r0Ptp1bDj21jH9iqH6rpkSyxu2OimxFGckGmoxFxUnAgDXHObGIwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsVy+t9jAd3ZyzYGGszu4rVo/r+d1WJJU4bF
	gdkPWS1endnIZnF54SVWi+83TC16F1xls9j0+BqrxeVdc9gszs47zmYx4/w+JosVTVsZLRZf
	XM5ssXvlEhaLYzOWMFo8fdDE5CDgsWbeGkaPvilX2TyebLrI6LFgU6nHnWt72Dw2L6n3OD9j
	IaPH9x29QAVbVjF6/Hyp4/F5k1wAd1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6h
	pYW5kkJeYm6qrZKLT4CuW2YO0DdKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQ
	QMI6xoyHHz4zFkxnr5iybQ1LA+Nr1i5GDg4JAROJ152OXYycQKaYxIV769m6GLk4hAQWMUpM
	W7WTESQhJPCLUeLybW8Qm01ATeLLl8PsILaIgL/EtautLCANzALvWSRu/9jHCpIQFnCXWLZt
	KVgzi4CqxNt/R8HivAKWEiv/TICyBSV+TL7HAmIzC2hJrN95nAnClpfYvOYtM8RFChI7zr5m
	hFimJ7Gx5xUrRI2IxL4X7xgnMArMQjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi
	0rx0veT83E2M4MTzTHoH46oGi0OMAhyMSjy8P1ZtCBRiTSwrrsw9xCjBwawkwvty1sZAId6U
	xMqq1KL8+KLSnNTiQ4zJQJ9OZJYSTc4HJsW8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmk
	J5akZqemFqQWwWxh4uCUamDMtLfxmFXF+rvhb0TOwTk81Xo+Ci3n7A4db1IUkKi6YGF3KL+q
	/OwT6zuPw/gWVwTkbg1tXaWasZbtf8WkT5xJi8/uCXmYzfFE596ytpUPJVLrFm7tzVOPVDv0
	143j5tV3CxZ6txttaFykJfCy4cYzjjuvGPYnKXUdlhZTXH9mxrXpH1bZyf5UYinOSDTUYi4q
	TgQACZBTi4ADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable PCIe support for Exynos5440 which has two PCIe controllers.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 arch/arm/Kconfig             |    1 +
 arch/arm/mach-exynos/Kconfig |    1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 42d6ea2..53b3b2d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1395,6 +1395,7 @@ config PCI_HOST_ITE8152
 	select DMABOUNCE
 
 source "drivers/pci/Kconfig"
+source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pcmcia/Kconfig"
 
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 6aa228d..ecd1a3d 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -81,6 +81,7 @@ config SOC_EXYNOS5440
 	select PINCTRL
 	select PINCTRL_EXYNOS5440
 	select PM_OPP
+	select MIGHT_HAVE_PCI
 	help
 	  Enable EXYNOS5440 SoC support
 
-- 
1.7.10.4


