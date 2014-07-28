Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbaG1PqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:46:19 -0400
Received: from mail-by2lp0241.outbound.protection.outlook.com ([207.46.163.241]:22322
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750999AbaG1PqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:46:14 -0400
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
        <anirudh@xilinx.com>, <svemula@xilinx.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: [PATCH RFC v4 0/4] Add arm pl353 smc nand driver for xilinx zynq soc
Date: Mon, 28 Jul 2014 21:01:36 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
Message-ID: <5d452894-346b-45e7-afe4-28c67c59e563@BY2FFO11FD019.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(243025005)(199002)(189002)(81542001)(2201001)(64706001)(47776003)(15975445006)(92726001)(50986999)(21056001)(70736001)(89996001)(85306003)(77982001)(77096002)(44976005)(76482001)(74662001)(107046002)(99396002)(81342001)(93916002)(19580395003)(106466001)(92566001)(79102001)(83322001)(31966008)(50226001)(62966002)(74316001)(87286001)(104166001)(95666004)(20776003)(87936001)(229853001)(88136002)(1496007)(77156001)(50466002)(85852003)(4396001)(46102001)(104016003)(74502001)(53416004)(80022001)(6806004)(48376002)(31696002)(102836001)(86362001)(15202345003)(83072002)(107986001)(921003)(1121002)(83996005)(2101003)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB051;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0286D7B531
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
 drivers/mtd/nand/pl353_nand.c         | 1147 +++++++++++++++++++++++++++++++++
 4 files changed, 1247 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/mtd/nand/pl353-nand.txt
 create mode 100644 drivers/mtd/nand/pl353_nand.c

-- 
1.7.4


