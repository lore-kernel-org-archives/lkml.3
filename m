Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbbAFSEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:04:55 -0500
Received: from mail-bl2on0057.outbound.protection.outlook.com ([65.55.169.57]:36419
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751453AbbAFSEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:04:51 -0500
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
Subject: [PATCH v5 0/2] Add arm pl353 smc driver for xilinx zynq soc
Date: Tue, 6 Jan 2015 23:19:15 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21228.000
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <5f8185b5a31b4a49b33e7eb511fcf93b@BN1BFFO11FD009.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(243025005)(189002)(50466002)(62966003)(77156002)(31966008)(64706001)(47776003)(86362001)(20776003)(229853001)(33646002)(50986999)(92726002)(15975445007)(107046002)(106466001)(89996001)(48376002)(46102003)(21056001)(87936001)(19580395003)(74316001)(6806004)(120916001)(53416004)(99396003)(4396001)(2201001)(92566001)(50226001)(107986001)(921003)(24736002)(83996005)(23106004)(1121003)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB063;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB063;
X-Forefront-PRVS: 0448A97BF2
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2015 17:49:25.9660
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1BFFO11HUB063
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

 .../bindings/memory-controllers/pl353-smc.txt      |   37 ++
 drivers/memory/Kconfig                             |    6 +
 drivers/memory/Makefile                            |    1 +
 drivers/memory/pl353-smc.c                         |  525 ++++++++++++++++++++
 include/linux/memory/pl353-smc.h                   |   37 ++
 5 files changed, 606 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/pl353-smc.txt
 create mode 100644 drivers/memory/pl353-smc.c
 create mode 100644 include/linux/memory/pl353-smc.h

-- 
1.7.4

