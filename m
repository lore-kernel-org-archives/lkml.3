Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbaHHXTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 19:19:44 -0400
Received: from [207.46.163.143] ([207.46.163.143]:11749 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751588AbaHHXTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 19:19:40 -0400
X-WSS-ID: 0NA0GOW-07-QNJ-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <marc.zyngier@arm.com>, <mark.rutland@arm.com>, <jason@lakedaemon.net>
CC: <pawel.moll@arm.com>, <Catalin.Marinas@arm.com>, <Will.Deacon@arm.com>,
        <tglx@linutronix.de>, <Harish.Kasiviswanathan@amd.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH 0/4] irqchip: gic-v2m: Rework GICv2m Initialization
Date: Fri, 8 Aug 2014 18:17:12 -0500
Message-ID: <1407539836-9768-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.9.0
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019004)(6009001)(428002)(199002)(189002)(19580405001)(83322001)(74662001)(47776003)(86152002)(93916002)(53416004)(19580395003)(86362001)(50226001)(88136002)(64706001)(62966002)(33646002)(95666004)(74502001)(50466002)(80022001)(83072002)(20776003)(85852003)(2201001)(4396001)(44976005)(99396002)(68736004)(107046002)(104166001)(21056001)(31966008)(87936001)(36756003)(81342001)(50986999)(89996001)(77982001)(87286001)(84676001)(77156001)(101416001)(79102001)(97736001)(92726001)(81542001)(106466001)(105586002)(92566001)(77096002)(85306004)(229853001)(48376002)(46102001)(102836001)(76482001);DIR:OUT;SFP:1102;SCL:1;SRVR:CO1PR02MB048;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02973C87BC
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>

This patch set reworks the GICv2m initialization based on Marc Zyngier
review comments.

* Rebase to git://git.infradead.org/users/jcooper/linux.git irqchip/gic-v2m

Suravee Suthikulpanit (1):
  irqchip/gic-v2m: Restructure the initalization code for v2m

 Documentation/devicetree/bindings/arm/gic.txt |  37 +++++++--
 drivers/irqchip/irq-gic-v2m.c                 | 115 +++++++++-----------------
 drivers/irqchip/irq-gic.c                     |  30 +++----
 drivers/irqchip/irq-gic.h                     |  10 +--
 4 files changed, 91 insertions(+), 101 deletions(-)

-- 
1.9.0

