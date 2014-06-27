Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaF0DDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 23:03:00 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:2209
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751139AbaF0DC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 23:02:58 -0400
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
Subject: [PATCH RFC v3 0/2] Add arm pl353 smc driver for xilinx zynq soc
Date: Fri, 27 Jun 2014 08:32:40 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
Message-ID: <637e4278-66b3-4a40-8fe2-9dc97ea643ba@BN1AFFO11FD026.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(189002)(199002)(243025005)(44976005)(50466002)(15975445006)(53416004)(81542001)(81342001)(87286001)(70736001)(33646001)(83072002)(74316001)(62966002)(107046002)(48376002)(50986999)(85852003)(99396002)(15202345003)(92566001)(88136002)(31696002)(85306003)(2201001)(80022001)(92726001)(87936001)(104016002)(20776003)(50226001)(74662001)(86362001)(79102001)(74502001)(104166001)(77096002)(95666004)(19580395003)(93916002)(46102001)(4396001)(21056001)(77156001)(102836001)(31966008)(76482001)(89996001)(47776003)(83322001)(77982001)(6806004)(1496007)(106466001)(921003)(1121002)(2101003)(217873001)(83996005)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB011;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
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

Punnaiah Choudary Kalluri (2):
  Devicetree: Add pl353 smc controller devicetree binding information
  memory: pl353: Add driver for arm pl353 static memory controller

 .../bindings/memory-controllers/pl353-smc.txt      |   53 ++
 drivers/memory/Kconfig                             |    6 +
 drivers/memory/Makefile                            |    1 +
 drivers/memory/pl353-smc.c                         |  569 ++++++++++++++++++++
 include/linux/memory/pl353-smc.h                   |   34 ++
 5 files changed, 663 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/pl353-smc.txt
 create mode 100644 drivers/memory/pl353-smc.c
 create mode 100644 include/linux/memory/pl353-smc.h

-- 
1.7.4


