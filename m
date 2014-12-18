Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbaLRW3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:29:19 -0500
Received: from mail-by2on0078.outbound.protection.outlook.com ([207.46.100.78]:48864
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751125AbaLRW3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:29:17 -0500
From: <atull@opensource.altera.com>
To: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <rdunlap@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devel@driverdev.osuosl.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v6 0/4] FPGA Manager Framework
Date: Thu, 18 Dec 2014 16:29:04 -0600
Message-ID: <1418941748-16111-1-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0022.namprd02.prod.outlook.com (10.141.56.22) To
 CY1PR0301MB1241.namprd03.prod.outlook.com (25.161.212.151)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atull@opensource.altera.com; 
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1241;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB1241;
X-Forefront-PRVS: 042957ACD7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(77156002)(47776003)(21056001)(62966003)(68736005)(19580405001)(42186005)(81156004)(120916001)(89996001)(106356001)(122386002)(2201001)(92566001)(229853001)(20776003)(50986999)(53416004)(46102003)(50466002)(33646002)(50226001)(87976001)(66066001)(4396001)(97736003)(86152002)(64706001)(105586002)(99396003)(86362001)(19580395003)(69596002)(107046002)(48376002)(40100003)(101416001)(31966008)(7059030)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1241;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1241;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0650;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Dropping the changes to socfpga DTS and defconfig from this
patch set.

Kernel doc fixes and other minor fixes as listed in the patches.

Alan

Alan Tull (4):
  doc: add bindings document for altera fpga manager
  fpga manager: add sysfs interface document
  staging: fpga manager: framework core
  staging: fpga manager: add driver for socfpga fpga manager

 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    1 +
 .../Documentation/ABI/sysfs-class-fpga-manager     |   38 ++
 .../Documentation/bindings/altera-fpga-mgr.txt     |   17 +
 drivers/staging/fpga/Kconfig                       |   29 +
 drivers/staging/fpga/Makefile                      |    9 +
 drivers/staging/fpga/fpga-mgr.c                    |  551 ++++++++++++++++
 drivers/staging/fpga/socfpga.c                     |  694 ++++++++++++++++++++
 include/linux/fpga/fpga-mgr.h                      |  124 ++++
 9 files changed, 1465 insertions(+)
 create mode 100644 drivers/staging/fpga/Documentation/ABI/sysfs-class-fpga-manager
 create mode 100644 drivers/staging/fpga/Documentation/bindings/altera-fpga-mgr.txt
 create mode 100644 drivers/staging/fpga/Kconfig
 create mode 100644 drivers/staging/fpga/Makefile
 create mode 100644 drivers/staging/fpga/fpga-mgr.c
 create mode 100644 drivers/staging/fpga/socfpga.c
 create mode 100644 include/linux/fpga/fpga-mgr.h

-- 
1.7.9.5

