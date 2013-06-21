Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423261Ab3FUHZf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:25:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28564 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422695Ab3FUHZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:25:32 -0400
X-AuditID: cbfee691-b7fef6d000002d62-dc-51c3ffeafbb9
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
Subject: [PATCH V10 2/4] ARM: EXYNOS: Enable PCIe support for Exynos5440
Date: Fri, 21 Jun 2013 16:25:29 +0900
Message-id: <003b01ce6e50$81fa0bd0$85ee2370$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5uUID+PajCCy1jSDS0BXX2k62OmA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSW0iTYRjHe/cdNgfC5/LwZlhhZCQe8vyKGaII34Ud7C4jbK4PJ3kY24zw
	xmGJZam5rVwrbOYoE0n97DAPydLaUDfUmUtLPJBGKgqV5SHSNmew2+7+7/P++P+ei4eHCVjC
	n5eTL2ek+cLcQJKPD2x+iQhd2OpNPzr1IQhd3XpFoD9KExfpS8RovucIMt6fIdCCpZVEI3U2
	Aq2OxaAK3SiJ2M92Ao10PCCRtdZMIs1gNwe13tkAqMx2EDWUvACofvgJhpo1izjqfKrHkUmj
	B2huuoST5EM31TYB+veGEtCV6lGSnmWHAa1jC+kJexdJt+mL6UFNHaBXDRUO4HkjoNfnQ+i5
	tdcY/YPdd9ozg3/sIpObc5mRhh+/wBc3sBZS0s+9Mv6yj1AALVkOPHiQioYa9Qzhyr5waLJ5
	ey6gHgNY0UX9Y251TGDlgO+YPwJwXFO389gA8JNFhTspkgqCKyu9XGf2pk5B+2gp7oQw6joJ
	2Vp2W7GbouHanHUbwqlDsEVXBZzZk4qHi0oj5specE01uV2KUcGwud3MceX9sK1pCXOtdAAa
	rIvAJQuD1nfvCRfjDbu/LgOnGFKzPNiiVO/IKPhL1eMo5Tk+AiBr3OnZA980jOG3ga/WTa11
	U2vd1Fo3hQ7gjcCHkYgksqxsaUyYTJgnK8zPDhMV5LHAdS/VBjBlTOgBIoe+GvP3ERU47ilf
	nhkRFRuJYqJjoiLj4mP/bxzo53n4WkK6gMoWyplLDCNhpJnSwlxG1gM4PA9/BYi2p5hnR0sV
	Z9L6cs8nzku9Qm6aVEm2e4m7ivofjtAZ1rsW9bS+L0vAh/aavmK8SB6ZlZp6MjQr9BxXrEm2
	J7Z9XG1PSQuqLJtesp0Iv9ERcLZ73ey3bOssekbZwwbygr69Tdm7yfpPK2qGur+vdlbJEkD9
	0M/kWcNGnEm2HIjLxMKIYEwqE/4FbkaVYUUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsVy+t9jAd1X/w8HGmyZo2DR/H87q8XfScfY
	LZY0ZVi8PKRpcWD2Q1aLV2c2sllcXniJ1eL7DVOL3gVX2Sw2Pb7GanF51xw2i7PzjrNZzDi/
	j8li49RfjBbtl5QtVjRtZbRYfHE5s8X6Ga9ZLHavXMJicWzGEkaLpw+amBxEPdbMW8Po8fvX
	JEaPvilX2TyebLrI6LFgU6nHnWt72Dw2L6n3OD9jIaPH9x29QAVbVjF6/Hyp4/H0x15mj8+b
	5AJ4oxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	3lVSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZqzYdIat4BR7xc1tJ1kb
	GGexdTFyckgImEj07LrDDGGLSVy4tx4ozsUhJLCIUeLmjIXMEM4vRonbZyazgFSxCahJfPly
	mB3EFhHwl7h2tZUFpIhZoINNYtO8TawgCWEBD4kfT8+CFbEIqEpsWNDPCGLzClhKvJ50gBnC
	FpT4Mfke2FBmAS2J9TuPM0HY8hKb17yFOklBYsfZ14wQy/Qkzh69wgpRIyKx78U7xgmMArOQ
	jJqFZNQsJKNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4fT2T2sG4ssHiEKMA
	B6MSD+8KlcOBQqyJZcWVuYcYJTiYlUR4g+8AhXhTEiurUovy44tKc1KLDzEmA306kVlKNDkf
	mFrzSuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoGx7IhRbkLK
	x+VNRUv651j5p5bc8md5pnnDeJffPfUgod2V1cX8yZFz9e/Yv7Y+YK4uFcCq2q/ip1x5xf+V
	1613egv7GnVvHfU2Lznht/4FX7PQxlAHRqPz+9otxD5lNCZN8rVN/jWPof9u3pc5E8r/JpjI
	e69ZJ1crIfyL0fHg/DXqvrL2TkosxRmJhlrMRcWJAONiW9KjAwAA
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


