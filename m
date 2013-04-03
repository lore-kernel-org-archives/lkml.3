Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab3DCOvE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:51:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58666 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761500Ab3DCOp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:45:56 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 12/12] ARM: tegra: Update default configuration (PCIe)
Date: Wed,  3 Apr 2013 16:45:18 +0200
Message-Id: <1365000318-28256-13-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
References: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:xEaPuaHVp24//OpnYC64O4dpT/sw31vdp3IkqOLwB9V
 xyFX2je/0LW/Xu/Px7+YGI3A/5koY+G/ZtyZfEjNSgli/oB2AQ
 3YBEExcQFCTVfRfSGVN8vPe9GLS3KTv942b3DPdlhV/+lLbNaN
 BzeUWnQTD6+0h3E7Zb3gcmSF9PXjjarE1GddFweRG86sG1N4RR
 HTP53cKEVfKjLobBGOAc7aditrKo4mUM75cYyiLP5Aw8QD90WT
 RZMw0FqIGxwftucC3SxqKkw2XmdpK9ZUZSZBcznEVU3jwpDojT
 agGyBLweDAacbjDAsSlezIlM8JXECdGKW+UY17MPQsMrmNE2XJ
 Wt/jTNxMRiMpv6zjdNL8n0L7QkPefnMU6O0hDmARldOlbmiukI
 5nhlBnp/ASMXblTdLYtIQPjNHUw4H/cZlAy/7OEtULm4mfW9ks
 1+DAb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable PCI and MSI support as well as the new Tegra PCIe controller
driver.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/configs/tegra_defconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 2b42a2c..6cedaa1 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -26,8 +26,10 @@ CONFIG_GPIO_PCA953X=y
 CONFIG_ARCH_TEGRA_2x_SOC=y
 CONFIG_ARCH_TEGRA_3x_SOC=y
 CONFIG_ARCH_TEGRA_114_SOC=y
-CONFIG_TEGRA_PCI=y
 CONFIG_TEGRA_EMC_SCALING_ENABLE=y
+CONFIG_PCI=y
+CONFIG_PCI_MSI=y
+CONFIG_PCI_TEGRA=y
 CONFIG_SMP=y
 CONFIG_PREEMPT=y
 CONFIG_AEABI=y
-- 
1.8.2

