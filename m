Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528AbaFXAdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 20:33:16 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:16200
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752597AbaFXAdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 20:33:13 -0400
X-WSS-ID: 0N7NDJ6-08-AXT-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 0/2] Introduce ARM GICv2m MSI(-X) support
Date: Mon, 23 Jun 2014 19:32:58 -0500
Message-ID: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428002)(189002)(199002)(85306003)(83072002)(20776003)(21056001)(15975445006)(79102001)(19580405001)(77982001)(53416004)(76482001)(50226001)(19580395003)(81342001)(83322001)(86152002)(80022001)(87286001)(46102001)(85852003)(77156001)(4396001)(36756003)(99396002)(62966002)(87936001)(97736001)(102836001)(89996001)(50466002)(88136002)(48376002)(33646001)(81542001)(84676001)(68736004)(93916002)(2201001)(47776003)(50986999)(101416001)(31966008)(86362001)(105586002)(92566001)(74662001)(92726001)(104166001)(74502001)(77096002)(106466001)(44976005)(64706001)(95666004);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR0201MB0926;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02524402D6
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch set introduces support for MSI(-X) in GICv2m specification,
which is implemented in some variation of GIC400.

This depends on and has been tested with the V7 of "Add support for PCI in AArch64"
(https://lkml.org/lkml/2014/3/14/320).

Suravee Suthikulpanit (2):
  arm/gic: Add binding probe for GIC400
  arm/gic: Add supports for GICv2m MSI(-X)

 Documentation/devicetree/bindings/arm/gic.txt |  18 +-
 drivers/irqchip/Kconfig                       |   6 +
 drivers/irqchip/Makefile                      |   1 +
 drivers/irqchip/gic-msi-v2m.c                 | 249 ++++++++++++++++++++++++++
 drivers/irqchip/gic-msi-v2m.h                 |  20 +++
 drivers/irqchip/irq-gic.c                     |  23 ++-
 6 files changed, 313 insertions(+), 4 deletions(-)
 create mode 100644 drivers/irqchip/gic-msi-v2m.c
 create mode 100644 drivers/irqchip/gic-msi-v2m.h

-- 
1.9.0

