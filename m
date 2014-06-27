Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaF0DEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:04:32 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:7041
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752463AbaF0DEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:04:30 -0400
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rob@landley.net>, <michal.simek@xilinx.com>,
        <grant.likely@linaro.org>, <gregkh@linuxfoundation.org>,
        <jason@lakedaemon.net>, <ezequiel.garcia@free-electrons.com>,
        <arnd@arndb.de>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>,
        <artem.bityutskiy@linux.intel.com>, <pekon@ti.com>,
        <jussi.kivilinna@iki.fi>, <acourbot@nvidia.com>,
        <ivan.khoronzhuk@ti.com>, <joern@logfs.org>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <kpc528@gmail.com>, <kalluripunnaiahchoudary@gmail.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: [PATCH RFC v3 0/4] Add arm pl353 smc nand driver for xilinx zynq soc
Date: Fri, 27 Jun 2014 08:33:55 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
Message-ID: <e15ea1f7-ac67-49b3-aff4-7c388a5616cf@BL2FFO11FD021.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(243025005)(189002)(199002)(92726001)(50466002)(50226001)(81542001)(80022001)(93916002)(46102001)(106466001)(81342001)(74662001)(83072002)(92566001)(85852003)(86362001)(48376002)(15202345003)(79102001)(77156001)(31966008)(53416004)(33646001)(74502001)(2201001)(4396001)(15975445006)(21056001)(87286001)(85306003)(62966002)(76482001)(74316001)(70736001)(1496007)(77096002)(95666004)(6806004)(50986999)(31696002)(83322001)(77982001)(47776003)(87936001)(102836001)(89996001)(44976005)(20776003)(104166001)(19580395003)(104016002)(99396002)(88136002)(107046002)(1121002)(921003)(23106004)(217873001)(2101003)(83996005);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB017;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0255DF69B9
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patches add arm pl353 static memory controller driver for
xilinx zynq soc. The arm pl353 smc supports two interfaces i.e nand and
nor/sram memory interfaces. The current implementation supports only a
single SMC instance and nand specific configuration.

xilinx zynq TRM link:
http://www.xilinx.com/support/documentation/user_guides/ug585-Zynq-7000-TRM.pdf

ARM pl353 smc TRM link:
http://infocenter.arm.com/help/topic/com.arm.doc.ddi0380g/
DDI0380G_smc_pl350_series_r2p1_trm.pdf

Punnaiah Choudary Kalluri (4):
  nand: pl353: Add basic driver for arm pl353 smc nand interface
  nand: pl353: Add software ecc support
  nand: pl353: Add ONDIE ECC support
  Documentation: nand: pl353: Add documentation for controller and
    driver

 Documentation/mtd/nand/pl353-nand.txt |   92 +++
 drivers/mtd/nand/Kconfig              |    7 +
 drivers/mtd/nand/Makefile             |    1 +
 drivers/mtd/nand/pl353_nand.c         | 1141 +++++++++++++++++++++++++++++++++
 4 files changed, 1241 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/mtd/nand/pl353-nand.txt
 create mode 100644 drivers/mtd/nand/pl353_nand.c

-- 
1.7.4


