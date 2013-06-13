Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040Ab3FMNXH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:23:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:65278 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756419Ab3FMNXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:23:04 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-5f-51b9c7b75130
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
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH V5 2/3] ARM: EXYNOS: Enable PCIe support for Exynos5440
Date: Thu, 13 Jun 2013 22:23:03 +0900
Message-id: <000c01ce6839$2217c210$66474630$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5oORt+dgO9kmJnSI2uLSS9asrucA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA5WSXUySURjHd+DlBV26V1I7sb7GFheuSETsmOW6870x9bYvQnrzGxHENdcm
	Q2PLRuXHikgNJpU5NibqhFKntIFbovkBc6s5nNVMzJscGmYFvV5w293vPM//nN95tofD5D5l
	8TgVinpKpZBV8/FE7P3vr+LTI15XSeZmQIia/4yw0F67h42sunI08WyFhdanB3C0YJlnoe0l
	CTKY/ThyrAZYaOFNF458PV4cGWfHGahPNwxQ79wrJnr72oohj9EK0JegjnExhbT12AC5G2kH
	5INOP05+dswB0uzQkJ8Cozg5aG0iZ40WQG47DdHAUD8gf347Rf5wHCs+cDnx/E2quqKBUp3J
	v5FYHh4vVa6xb6+s3gdaMIC3Ag4HEtnQG7jWChKimA4/LNuj5UQOl3gJYPdiF043sqFxz8mk
	G08ADG7e2z9EADSFDaxYCicEcGvrHTvGqUQRDPjvYrEQk2hnwUjbPCPWOEgUwKC/E8QYI07C
	Rb3n34UkIheudj1n0JwCdzqWsRgziQxod3kZNB+Hg7bvTPpLJ6DTFwKxEVIJIQzZZXQkFY6v
	bYKYFxJTHPird4ZNuwgY7nBj9MhHoWNi/5nDcLJvCXsE0k1xZlOc2RRnNsUpzADrB2mUUq5U
	l5apREK1rEatUZQJ5bU1DkCvhcEJPk7kuYE8qm9j8tLktdG1UdRLReKcLCTJloizzubm/F+Z
	fyhJ0JJXwiXKZPVUFUUpKZVUpamm1G7A4CTwtKD4kmWsZmrGzDNvBI/opDbFdMrDO2pOEXes
	6JamOcDj7zWFL6wXaolz4qzGUEduUglbM7zY4Hix0ZwcLlybqdRJ61w9WIL+asEVsaFbG6jy
	7JQm6y39pkhlXYvdPWQVZOolk9clAZ3E4pKGGn16oc33uEEwKsrfzdTK+Zi6XCbKYKrUsr/M
	NsCQLAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsVy+t9jQd3tx3cGGpxs0rRo/r+d1eLvpGPs
	FkuaMiwOzH7IavHqzEY2i8sLL7FafL9hatG74CqbxabH11gtLu+aw2Zxdt5xNosZ5/cxWaxo
	2sposfjicmaL3SuXsFgcm7GE0eLpgyYmB0GPNfPWMHr8/jWJ0aNvylU2jyebLjJ6LNhU6nHn
	2h42j81L6j3Oz1jI6PF9Ry9QwZZVjB4/X+p4fN4kF8AT1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQP0l5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsI4x49u+pIIX7BUPH3czNjBuZOti5OSQEDCRmPF3BzOELSZx4d56oDgX
	h5DAdEaJB+86mSGcX4wSs771soJUsQmoSXz5cpgdxBYR8Je4drWVBaSIWWASq8SviZeYQBLC
	Au4SD65OYQSxWQRUJa60HQNr4BWwlHg8Zz4ThC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b6FO
	UpDYcfY10BwOoGV6Eq/XJ0KUiEjse/GOcQKjwCwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5K
	zzXUK07MLS7NS9dLzs/dxAhORs+kdjCubLA4xCjAwajEw/uidUegEGtiWXFl7iFGCQ5mJRHe
	m1N3BgrxpiRWVqUW5ccXleakFh9iTAZ6dCKzlGhyPjBR5pXEGxqbmBlZGplZGJmYm5MmrCTO
	e6DVOlBIID2xJDU7NbUgtQhmCxMHp1QD40KtqPlOTe7crTo+XUk+HH8Eep9HHzwWmCc3q5Pr
	icB6ofLEzLtxd8rszx9tM7B/mvLvnN/xzYbcj/98TbU70NX9N9t/bbxn5q2J8Qt/+MeLSl26
	bM9ssuCrmkCw05K/0XMjnnt1COYeO7vaus3xf2mDyhLG+o6t+0K6T7Hz32i7dO50PGeZEktx
	RqKhFnNRcSIA6AJ4K4oDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable PCIe support for Exynos5440 which has two PCIe controllers.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Tested on Exynos5440.

 arch/arm/Kconfig             |    1 +
 arch/arm/mach-exynos/Kconfig |    2 ++
 2 files changed, 3 insertions(+)

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
index 6aa228d..773b5ee 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -78,6 +78,8 @@ config SOC_EXYNOS5440
 	select ARCH_HAS_OPP
 	select ARM_ARCH_TIMER
 	select AUTO_ZRELADDR
+	select MIGHT_HAVE_PCI
+	select PCI_DOMAINS if PCI
 	select PINCTRL
 	select PINCTRL_EXYNOS5440
 	select PM_OPP
-- 
1.7.10.4


