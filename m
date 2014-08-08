Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbaHHXUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 19:20:15 -0400
Received: from [207.46.163.183] ([207.46.163.183]:24015 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751520AbaHHXUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 19:20:12 -0400
X-WSS-ID: 0NA0GP7-08-MJF-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <jason@lakedaemon.net>
CC: <pawel.moll@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>,
        <tglx@linutronix.de>, <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "Marc Zyngier" <Marc.Zyngier@arm.com>
Subject: [PATCH 1/4] irqchip: gic-v2m: Remove irq-gic-v2m.h file
Date: Fri, 8 Aug 2014 18:17:13 -0500
Message-ID: <1407539836-9768-2-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407539836-9768-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1407539836-9768-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019004)(6009001)(428002)(189002)(199002)(102836001)(62966002)(48376002)(95666004)(106466001)(97736001)(229853001)(105586002)(87286001)(50986999)(53416004)(76176999)(76482001)(107046002)(33646002)(81342001)(101416001)(50466002)(81542001)(50226001)(68736004)(4396001)(2201001)(92566001)(92726001)(85852003)(83072002)(46102001)(86362001)(93916002)(104166001)(77156001)(64706001)(80022001)(85306004)(36756003)(86152002)(47776003)(20776003)(87936001)(74662001)(77982001)(99396002)(44976005)(31966008)(74502001)(21056001)(89996001)(83322001)(77096002)(79102001)(88136002)(84676001)(19580405001)(19580395003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB044;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 02973C87BC
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

Remove irq-gic-v2m.h file which is no longer used

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>
---
 drivers/irqchip/irq-gic-v2m.h | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v2m.h b/drivers/irqchip/irq-gic-v2m.h
index 2d93a87..e69de29 100644
--- a/drivers/irqchip/irq-gic-v2m.h
+++ b/drivers/irqchip/irq-gic-v2m.h
@@ -1,13 +0,0 @@
-#ifndef _IRQ_GIC_V2M_H_
-#define _IRQ_GIC_V2M_H_
-
-struct v2m_data {
-	spinlock_t msi_cnt_lock;
-	struct resource res;      /* GICv2m resource */
-	void __iomem *base;       /* GICv2m virt address */
-	unsigned int spi_start;   /* The SPI number that MSIs start */
-	unsigned int nr_spis;     /* The number of SPIs for MSIs */
-	unsigned long *bm;        /* MSI vector bitmap */
-};
-
-#endif /*_IRQ_GIC_V2M_H_*/
-- 
1.9.0

