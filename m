Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbaEHDLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 23:11:15 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:48376
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752954AbaEHDLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 23:11:14 -0400
From: Prabhakar Kushwaha <prabhakar@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <arnd@arndb.de>, <scottwood@freescale.com>,
        Prabhakar Kushwaha <prabhakar@freescale.com>
Subject: [PATCH][v2] driver/memory:Add Kconfig help description for IFC
Date: Thu, 8 May 2014 08:40:55 +0530
Message-ID: <1399518656-2539-1-git-send-email-prabhakar@freescale.com>
X-Mailer: git-send-email 1.7.9.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(189002)(199002)(68736004)(6806004)(77156001)(48376002)(19580395003)(4396001)(62966002)(33646001)(50466002)(50226001)(69596002)(84676001)(19580405001)(44976005)(83322001)(46102001)(31966008)(74502001)(74662001)(79102001)(93916002)(92726001)(81542001)(81342001)(87286001)(77982001)(76482001)(21056001)(83072002)(2009001)(89996001)(77096999)(92566001)(99396002)(50986999)(36756003)(88136002)(97736001)(85852003)(47776003)(20776003)(87936001)(80022001)(81156002)(64706001)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB389;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Forefront-PRVS: 0205EDCD76
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=prabhakar@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Freescale's Integrated Flash controller(IFC) module is used to handle
devices such as NOR, NAND, FPGA and ASIC.

Update same in Help section of Kconfig for IFC.

Signed-off-by: Prabhakar Kushwaha <prabhakar@freescale.com>
---
Changes for v2: Resending again keeping maintainer in 'CC'

 drivers/memory/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
index c59e9c9..9a59581 100644
--- a/drivers/memory/Kconfig
+++ b/drivers/memory/Kconfig
@@ -64,5 +64,9 @@ config TEGRA30_MC
 config FSL_IFC
 	bool
 	depends on FSL_SOC
+	help
+	  This driver is for the Integrated Flash Controller(IFC) module
+	  available in Freescale SoCs. This controller allows to handle
+	  devices such as NOR, NAND, FPGA and ASIC etc.
 
 endif
-- 
1.7.9.5


