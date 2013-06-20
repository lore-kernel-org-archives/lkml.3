Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab3FTMn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:43:56 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18572 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757692Ab3FTMnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:43:53 -0400
X-AuditID: cbfee68f-b7f436d000000f81-2b-51c2f907390e
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
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Surendranath Gurivireddy Balla'" <suren.reddy@samsung.com>,
        "'Siva Reddy Kallam'" <siva.kallam@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Pratyush Anand'" <pratyush.anand@st.com>,
        "'Mohit KUMAR'" <Mohit.KUMAR@st.com>, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V8 2/4] ARM: EXYNOS: Enable PCIe support for Exynos5440
Date: Thu, 20 Jun 2013 21:43:51 +0900
Message-id: <00dc01ce6db3$d118a570$7349f050$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5ts8ybviqMEDxzQlWMpiv59kxARg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t8zA132n4cCDbonG1s0/9/OavF30jF2
	iyVNGRYvD2laHJj9kNXi1ZmNbBaXF15itfh+w9Sid8FVNotNj6+xWlzeNYfN4uy842wWM87v
	Y7LYOPUXo0X7JWWLFU1bGS0WX1zObLF+xmsWi90rl7BYHJuxhNHi6YMmJgdRjzXz1jB6/P41
	idGjb8pVNo8nmy4yeizYVOpx59oeNo/NS+o9zs9YyOjxfUcvUMGWVYweP1/qeDz9sZfZ4/Mm
	uQDeKC6blNSczLLUIn27BK6Mf9uPsRWcYq+499K9gXEWWxcjJ4eEgInEmSvHoGwxiQv31gPZ
	XBxCAssYJZ5NegNX9ObnB3aIxHRGiafTHrJAOL8YJVbNng9WxSagJvHly2F2EFtEwF/i2tVW
	sCJmgQ42iU3zNrGCJIQF3CVuL5gE1sAioCpxZf4OZhCbV8BS4vG+XnYIW1Dix+R7LCA2s4CW
	xPqdx5kgbHmJzWveMkOcpCCx4+xrRohlehLHunczQtSISOx78Y4RZLGEwBMOiW0T9jNDLBOQ
	+Db5ENBQDqCErMSmA1BzJCUOrrjBMoFRbBaS1bOQrJ6FZPUsJCsWMLKsYhRNLUguKE5KLzLW
	K07MLS7NS9dLzs/dxAhJL/07GO8esD7EmAy0fiKzlGhyPjA95ZXEGxqbGVmYmpgaG5lbmpEm
	rCTOq9ZiHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBMb6Ih+u5lPbGE0d/61bOsJy5lVNB
	eMnTjPbgow0X8zokOt4dXOqZ9pA50rRXJXrv9AuMRm3rJa7udL1cpfUk+KiE++TP780mzrqk
	cPjXHtmJaSe9bf9JFB26cfrs8baVn852HWJ2m8IQv7/4V2+c5cVi26NFKvPkmd/KhZuyxT+7
	1Xr5dLuotRJLcUaioRZzUXEiANIFkL1FAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42I5/e+xoC77z0OBBpev6Fg0/9/OavF30jF2
	iyVNGRYvD2laHJj9kNXi1ZmNbBaXF15itfh+w9Sid8FVNotNj6+xWlzeNYfN4uy842wWM87v
	Y7LYOPUXo0X7JWWLFU1bGS0WX1zObLF+xmsWi90rl7BYHJuxhNHi6YMmJgdRjzXz1jB6/P41
	idGjb8pVNo8nmy4yeizYVOpx59oeNo/NS+o9zs9YyOjxfUcvUMGWVYweP1/qeDz9sZfZ4/Mm
	uQDeqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	d5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGf+2H2MrOMVece+lewPj
	LLYuRk4OCQETiTc/P7BD2GISF+6tB4pzcQgJTGeUeDrtIQuE84tRYtXs+WAdbAJqEl++HAbr
	EBHwl7h2tRWsiFmgg01i07xNrCAJYQF3idsLJoE1sAioSlyZv4MZxOYVsJR4vK+XHcIWlPgx
	+R4LiM0soCWxfudxJghbXmLzmrfMECcpSOw4+5oRYpmexLHu3YwQNSIS+168Y5zAKDALyahZ
	SEbNQjJqFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCk9cz6R2MqxosDjEKcDAq
	8fBqXD4YKMSaWFZcmXuIUYKDWUmEN3XOoUAh3pTEyqrUovz4otKc1OJDjMlAn05klhJNzgcm
	1rySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRqYPQIt7yUtjpI
	aoOTtqBz9xpGnVu6bjtdi7+wbvi1OzIroc3gSJfBHssJDqJTTANmfmJOe2PaKFHieG5FZktb
	/+YOLelu9xW9TO37DmRt4np83S57L/++Zg39xaz/36oeumMm/DBmz5zvvteSLjotz5/3b2rn
	Rn/taQucsq2PtJ3TCdppzsXyRomlOCPRUIu5qDgRAEgO3cyiAwAA
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
 arch/arm/mach-exynos/Kconfig |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 804f41d..098eaef 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1427,6 +1427,7 @@ config PCI_HOST_ITE8152
 	select DMABOUNCE
 
 source "drivers/pci/Kconfig"
+source "drivers/pci/pcie/Kconfig"
 
 source "drivers/pcmcia/Kconfig"
 
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index 359af2c..f5f65b5 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -95,6 +95,8 @@ config SOC_EXYNOS5440
 	select ARCH_HAS_OPP
 	select HAVE_ARM_ARCH_TIMER
 	select AUTO_ZRELADDR
+	select MIGHT_HAVE_PCI
+	select PCI_DOMAINS if PCI
 	select PINCTRL_EXYNOS5440
 	select PM_OPP
 	help
-- 
1.7.10.4


