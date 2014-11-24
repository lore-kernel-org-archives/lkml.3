Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbaKXOmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:42:39 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38001 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbaKXOfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:41 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Catalin marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Robert Richter <robert.richter@caviumnetworks.com>,
        "Yun Wu (Abel)" <wuyun.wu@huawei.com>
Subject: [PATCH v3 01/13] arm64: PCI/MSI: Use asm-generic/msi.h
Date: Mon, 24 Nov 2014 14:35:08 +0000
Message-Id: <1416839720-18400-2-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com>
References: <1416839720-18400-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to support CONFIG_GENERIC_MSI_IRQ_DOMAIN, we need to
define msi_alloc_info_t. As the generic version exposed in
asm-generic/msi.h is perfectly convenient, import this file
as asm/msi.h.

Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/Kbuild | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index dc770bd..e315bd8 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -28,6 +28,7 @@ generic-y += local64.h
 generic-y += mcs_spinlock.h
 generic-y += mman.h
 generic-y += msgbuf.h
+generic-y += msi.h
 generic-y += mutex.h
 generic-y += pci.h
 generic-y += pci-bridge.h
-- 
2.1.3

