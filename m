Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3CWEIv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 00:08:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31048 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3CWEIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 00:08:49 -0400
X-AuditID: cbfee690-b7f656d0000007e3-9b-514d2ad0ba5b
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
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
In-reply-to: <00c001ce277b$92b26ab0$b8174010$%han@samsung.com>
Subject: [PATCH 5/6] ARM: EXYNOS: Enable PCIe support for Exynos5440
Date: Sat, 23 Mar 2013 13:08:47 +0900
Message-id: <00c401ce277c$1e4b91a0$5ae2b4e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4ne5IlJNJTIxgLT4K5aVV6JypTrgAAGFyA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t8zfd0LWr6BBgumcFk0/9/OarGkKcPi
	wOyHrBavzmxks7i88BKrxfcbpha9C66yWWx6fI3V4vKuOWwWZ+cdZ7OYcX4fk8WKpq2MFosv
	Lme22L1yCYvFsRlLGC2ePmhichDwWDNvDaNH35SrbB5PNl1k9FiwqdTjzrU9bB6bl9R7nJ+x
	kNHj+45eoIItqxg9fr7U8fi8SS6AO4rLJiU1J7MstUjfLoErY8b7VuaCtewV0z7YNDD+Z+1i
	5OSQEDCRWHRqDzuELSZx4d56NhBbSGAZo8Tn/kSYmilHDzJ2MXIBxaczSkw4dIEJwvnFKHHl
	6h+wSWwCahJfvhwGmyQi4C9x7WorC0gRs8BnFonlk8+wQ4y1lbh7ci4ziM0pYCfxuBWkiJND
	WMBFYtecSWCrWQRUJY5ePwhWwwtUv+3xJnYIW1Dix+R7YPXMAloS63ceZ4Kw5SU2r3kLVM8B
	dKq6xKO/uhA3GEnseb0IqkREYt+Ld2AfSAhc4JD48/gPI8QuAYlvkw+xQPTKSmw6wAzxsaTE
	wRU3WCYwSsxCsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UUmesWJucWleel6yfm5mxghiWTC
	DsZ7B6wPMSYDrZ/ILCWanA9MRHkl8YbGZkYWpiamxkbmlmakCSuJ86q3WAcKCaQnlqRmp6YW
	pBbFF5XmpBYfYmTi4JRqYFy67dy2f1vjOi7o8vF/Py6waweHttwE83P/rv2RFn0tvWiTl2kt
	SznbOcNoi4sXnHcs+ngj82tm88f8s+G33hVtfbX7n4DG87z1qa5ZB8Xl/Zfwbkv1u1Fxsfer
	5+IH9SU3Y/il1wQWBNad7ePOtngZeJ7x3jXNlQsl4u8IWcvpeBcXKPrJ9CuxFGckGmoxFxUn
	AgCPXonROgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42I5/e+xoO4FLd9Ag86VLBbN/7ezWixpyrA4
	MPshq8WrMxvZLC4vvMRq8f2GqUXvgqtsFpseX2O1uLxrDpvF2XnH2SxmnN/HZLGiaSujxeKL
	y5ktdq9cwmJxbMYSRounD5qYHAQ81sxbw+jRN+Uqm8eTTRcZPRZsKvW4c20Pm8fmJfUe52cs
	ZPT4vqMXqGDLKkaPny91PD5vkgvgjmpgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0
	tDBXUshLzE21VXLxCdB1y8wB+kZJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEa
	SFjHmDHjfStzwVr2imkfbBoY/7N2MXJySAiYSEw5epARwhaTuHBvPVsXIxeHkMB0RokJhy4w
	QTi/GCWuXP0D1sEmoCbx5cthdhBbRMBf4trVVhaQImaBzywSyyefAUsICdhK3D05lxnE5hSw
	k3jcClLEySEs4CKxa84kNhCbRUBV4uj1g2A1vED12x5vYoewBSV+TL4HVs8soCWxfudxJghb
	XmLzmrdA9RxAp6pLPPqrC3GDkcSe14ugSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGK
	phYkFxQnpeca6hUn5haX5qXrJefnbmIEJ6pnUjsYVzZYHGIU4GBU4uENqPYJFGJNLCuuzD3E
	KMHBrCTCe0/DN1CINyWxsiq1KD++qDQntfgQYzLQoxOZpUST84FJNK8k3tDYxMzI0sjMwsjE
	3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4OKUaGBdy1wW6pqwRKN2063No0OqUBaxPr2zW
	ZXwkEBDgzJmZGOFg11G8LvemJsfChQsT3W66O3QwZnaK+GVUiD+e7//dIjg2dZNfXGVOs86n
	VyFTLfok0w9VVf3Z3rlucdK57ZV7+Dm+hYT25SkzdJ/cH79eU3vF9lexAVJ939hzL+aunbCd
	3/SUEktxRqKhFnNRcSIAwa8HWZgDAAA=
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
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5e34364..76c0f75 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1442,6 +1442,7 @@ config PCI_HOST_ITE8152
 	select DMABOUNCE
 
 source "drivers/pci/Kconfig"
+source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pcmcia/Kconfig"
 
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index ef3b69a..023e178 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -77,6 +77,7 @@ config SOC_EXYNOS5440
 	select AUTO_ZRELADDR
 	select PINCTRL
 	select PINCTRL_EXYNOS5440
+	select MIGHT_HAVE_PCI
 	help
 	  Enable EXYNOS5440 SoC support
 
-- 
1.7.2.5


