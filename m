Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaCYAf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 20:35:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44444 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbaCYAf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 20:35:56 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-pci@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>, Jingoo Han <jg1.han@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Richard Zhu <r65037@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Mohit Kumar <mohit.kumar@st.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [RESEND: RFC PATCH 1/3] ARM: keystone: add pcie related options
Date: Mon, 24 Mar 2014 20:35:25 -0400
Message-ID: <1395707726-20437-3-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1395707726-20437-1-git-send-email-m-karicheri2@ti.com>
References: <1395707726-20437-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add pcie related options by default for keystone architecture

CC: Jingoo Han <jg1.han@samsung.com>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: Richard Zhu <r65037@freescale.com>
CC: Shawn Guo <shawn.guo@linaro.org>
CC: Mohit Kumar <mohit.kumar@st.com>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 arch/arm/mach-keystone/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-keystone/Kconfig b/arch/arm/mach-keystone/Kconfig
index 7e16d07..22c2174 100644
--- a/arch/arm/mach-keystone/Kconfig
+++ b/arch/arm/mach-keystone/Kconfig
@@ -17,6 +17,8 @@ config ARCH_KEYSTONE
 	select TI_KEYSTONE
 	select ARCH_SUPPORTS_BIG_ENDIAN
 	select ZONE_DMA if ARM_LPAE
+	select MIGHT_HAVE_PCI
+	select ARCH_SUPPORTS_MSI
 	help
 	  Support for boards based on the Texas Instruments Keystone family of
 	  SoCs.
-- 
1.7.9.5

