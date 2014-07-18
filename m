Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965765AbaGRPQL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:16:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57235 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965092AbaGRPQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:16:07 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v6 5/5] PCI: keystone: Update maintainer information
Date: Fri, 18 Jul 2014 11:14:29 -0400
Message-ID: <1405696469-7172-6-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405696469-7172-1-git-send-email-m-karicheri2@ti.com>
References: <1405696469-7172-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the MAINTAINERS file for the keystone PCIe driver

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Russell King <linux@arm.linux.org.uk>
CC: Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <robh+dt@kernel.org>
CC: Mohit Kumar <mohit.kumar@st.com>
CC: Jingoo Han <jg1.han@samsung.com>
CC: Bjorn Helgaas <bhelgaas@google.com>
CC: Pratyush Anand <pratyush.anand@st.com>
CC: Richard Zhu <r65037@freescale.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>
CC: Marek Vasut <marex@denx.de>
CC: Arnd Bergmann <arnd@arndb.de>
CC: Pawel Moll <pawel.moll@arm.com>
CC: Mark Rutland <mark.rutland@arm.com>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
CC: Kumar Gala <galak@codeaurora.org>
CC: Randy Dunlap <rdunlap@infradead.org>
CC: Grant Likely <grant.likely@linaro.org>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e31c874..8158f82 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6807,6 +6807,13 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/pci/host/*imx6*
 
+PCI DRIVER FOR keystone
+M:	Murali Karicheri <m-karicheri2@ti.com>
+L:	linux-pci@vger.kernel.org
+L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
+S:	Maintained
+F:	drivers/pci/host/*keystone*
+
 PCI DRIVER FOR MVEBU (Marvell Armada 370 and Armada XP SOC support)
 M:	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
 M:	Jason Cooper <jason@lakedaemon.net>
-- 
1.7.9.5

