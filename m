Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaHHXU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 19:20:29 -0400
Received: from [207.46.163.185] ([207.46.163.185]:10591 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757679AbaHHXUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 19:20:20 -0400
X-WSS-ID: 0NA0GPQ-08-MJI-02
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
Subject: [PATCH 2/4] irqchip: gic-v2m: Remove the matching name gic-400-v2m
Date: Fri, 8 Aug 2014 18:17:14 -0500
Message-ID: <1407539836-9768-3-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1407539836-9768-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1407539836-9768-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019004)(6009001)(428002)(199002)(189002)(88136002)(86362001)(79102001)(76482001)(50466002)(44976005)(87286001)(2201001)(92726001)(97736001)(77156001)(84676001)(21056001)(86152002)(19580395003)(93916002)(87936001)(48376002)(74662001)(92566001)(83322001)(83072002)(68736004)(4396001)(50226001)(102836001)(19580405001)(101416001)(31966008)(74502001)(64706001)(46102001)(105586002)(77982001)(62966002)(107046002)(106466001)(33646002)(77096002)(229853001)(99396002)(95666004)(36756003)(80022001)(47776003)(53416004)(20776003)(50986999)(104166001)(76176999)(85306004)(89996001)(81342001)(81542001)(85852003);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR02MB172;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02973C87BC
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch remove the matching name gic-400-v2m.
It will use the "gic-400" instead

Signed-off-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Mark Rutland <Mark.Rutland@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>
Cc: Jason Cooper <jason@lakedaemon.net>
---
 drivers/irqchip/irq-gic-v2m.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
index 94ed8d6..57b5a51 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -245,7 +245,4 @@ gicv2m_of_init(struct device_node *node, struct device_node *parent)
 
 	return gicv2m_msi_init(node, &gic->v2m_data);
 }
-
-IRQCHIP_DECLARE(arm_gic_400_v2m, "arm,gic-400-v2m", gicv2m_of_init);
-
 #endif /* CONFIG_OF */
-- 
1.9.0

