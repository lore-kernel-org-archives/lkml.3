Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964992AbaE2Gkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:40:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59845 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756044AbaE2Gk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:40:28 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <arnd@arndb.de>, <tony@atomide.com>, <jg1.han@samsung.com>,
        <kishon@ti.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH v2 16/18] ARM: OMAP: Enable PCI for DRA7
Date: Thu, 29 May 2014 12:08:18 +0530
Message-ID: <1401345500-20188-17-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401345500-20188-1-git-send-email-kishon@ti.com>
References: <1401345500-20188-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have added PCIe driver for DRA7 SOCs, enable PCI on
DRA7 SOCs.

Cc: Tony Lindgren <tony@atomide.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/mach-omap2/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index cb31d43..b179e80 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -75,6 +75,8 @@ config SOC_DRA7XX
 	select ARM_GIC
 	select HAVE_ARM_ARCH_TIMER
 	select IRQ_CROSSBAR
+	select MIGHT_HAVE_PCI
+	select ARCH_SUPPORTS_MSI
 
 config ARCH_OMAP2PLUS
 	bool
-- 
1.7.9.5

