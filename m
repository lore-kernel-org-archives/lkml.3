Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423138Ab3FUDWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 23:22:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:51931 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965601Ab3FUDWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 23:22:47 -0400
X-AuditID: cbfee691-b7fef6d000002d62-4b-51c3c6ed9ce8
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
Subject: [PATCH V9 2/4] ARM: EXYNOS: Enable PCIe support for Exynos5440
Date: Fri, 21 Jun 2013 12:22:21 +0900
Message-id: <002101ce6e2e$8aafa180$a00ee480$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5uLokEFTP5rpj6QtWj9H0fJzPgXw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t8zfd23xw4HGpz+ZGrR/H87q8XfScfY
	LZY0ZVi8PKRpcWD2Q1aLV2c2sllcXniJ1eL7DVOL3gVX2Sw2Pb7GanF51xw2i7PzjrNZzDi/
	j8li49RfjBbtl5QtVjRtZbRYfHE5s8X6Ga9ZLHavXMJicWzGEkaLpw+amBxEPdbMW8Po8fvX
	JEaPvilX2TyebLrI6LFgU6nHnWt72Dw2L6n3OD9jIaPH9x29QAVbVjF6/Hyp4/H0x15mj8+b
	5AJ4o7hsUlJzMstSi/TtErgyVmw6w1Zwir3i5raTrA2Ms9i6GDk5JARMJL7NescCYYtJXLi3
	HijOxSEksIxR4k1DPztM0YbWNnaIxHRGiVlrHkBV/WKUWL7kByNIFZuAmsSXL4fBOkQE/CWu
	XW1lASliFuhgk9g0bxNrFyMHh7CAu8TZWyEgNSwCqhKfpm1mBrF5BSwlHq/8DmULSvyYfA/s
	JGYBLYn1O48zQdjyEpvXvGWGuEhBYsfZ14wQu/QkNi9cCFUvIrHvxTtGkL0SAi84JFpm3mOG
	WCYg8W3yIRaQGyQEZCU2HYCaIylxcMUNlgmMYrOQrJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFS
	epGpXnFibnFpXrpecn7uJkZIepm4g/H+AetDjMlA6ycyS4km5wPTU15JvKGxmZGFqYmpsZG5
	pRlpwkrivOot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGE/5CKg9q0gNXJF+peRcikPN
	HhP1zpqIFWFqYdbWr51L4zLebhF4OL9gQdKmuZzbIm6cOXvjdqux9OGiGc+Pt0tphc15enl/
	Me9/vcZ5EVeDz/y2f+HxfEX5grAfT84biman3gxpCY1UD131/qiEad6bKfv73mgk/fK5Jhp3
	QyxR+nWEhOSn00osxRmJhlrMRcWJAHfRykJFAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42I5/e+xoO7bY4cDDT5/0bNo/r+d1eLvpGPs
	FkuaMixeHtK0ODD7IavFqzMb2SwuL7zEavH9hqlF74KrbBabHl9jtbi8aw6bxdl5x9ksZpzf
	x2SxceovRov2S8oWK5q2Mlosvric2WL9jNcsFrtXLmGxODZjCaPF0wdNTA6iHmvmrWH0+P1r
	EqNH35SrbB5PNl1k9FiwqdTjzrU9bB6bl9R7nJ+xkNHj+45eoIItqxg9fr7U8Xj6Yy+zx+dN
	cgG8UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	7yoplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM1ZsOsNWcIq94ua2k6wN
	jLPYuhg5OSQETCQ2tLaxQ9hiEhfurQeKc3EICUxnlJi15gGU84tRYvmSH4wgVWwCahJfvhwG
	6xAR8Je4drWVBaSIWaCDTWLTvE2sXYwcHMIC7hJnb4WA1LAIqEp8mraZGcTmFbCUeLzyO5Qt
	KPFj8j0WEJtZQEti/c7jTBC2vMTmNW+ZIS5SkNhx9jUjxC49ic0LF0LVi0jse/GOcQKjwCwk
	o2YhGTULyahZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAhOXs+kdzCuarA4xCjA
	wajEwxugdDhQiDWxrLgy9xCjBAezkgiv2ESgEG9KYmVValF+fFFpTmrxIcZkoE8nMkuJJucD
	E2teSbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTSE0tSs1NTC1KLYLYwcXBKNTAGnbdSP5dt
	rpAR8e5HUFJhWca2U2GLTqg+nX71yjL2RPuSeY9PPq5TX2/6avvB5BvLHMQift1duynwo6rD
	+UguFb/fuydbf9/sHMjTG5vRb7x+GoPTc6O7C0/v9DiXpuN94lrAn0C3htcGqZ4ijSrlepL7
	/z99zdfvlx2iGbr39MSAzheih4OVWIozEg21mIuKEwEFRJSXogMAAA==
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
index ca30d75..421ce68 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1428,6 +1428,7 @@ config PCI_HOST_ITE8152
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


