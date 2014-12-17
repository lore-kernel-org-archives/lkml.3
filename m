Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaLQQzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 11:55:38 -0500
Received: from mail-bn1on0056.outbound.protection.outlook.com ([157.56.110.56]:36608
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751644AbaLQQzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 11:55:33 -0500
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
Subject: [PATCH v5 6/6] ARM: socfpga: defconfig: enable fpga manager
Date: Wed, 17 Dec 2014 10:54:49 -0600
Message-ID: <1418835289-15752-7-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1418835289-15752-1-git-send-email-atull@opensource.altera.com>
References: <1418835289-15752-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR00CA0007.namprd00.prod.outlook.com (25.160.102.17) To
 BN3PR0301MB1236.namprd03.prod.outlook.com (25.161.207.24)
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1236;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN3PR0301MB1236;
X-Forefront-PRVS: 042857DBB5
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(122386002)(99396003)(19580395003)(19580405001)(69596002)(120916001)(40100003)(81156004)(106356001)(105586002)(66066001)(50986999)(76176999)(64706001)(42186005)(47776003)(20776003)(87976001)(46102003)(101416001)(86362001)(92566001)(2201001)(86152002)(89996001)(31966008)(4396001)(2950100001)(50466002)(33646002)(50226001)(21056001)(97736003)(68736005)(48376002)(53416004)(229853001)(62966003)(77156002)(107046002)(7059030)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1236;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1236;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2014 16:55:26.0516 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB1236
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Enable FPGA manager for Altera socfpga.

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
v5: s/CONFIG_FPGA_MGR_ALTERA/CONFIG_FPGA_MGR_SOCFPGA/
---
 arch/arm/configs/socfpga_defconfig |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/configs/socfpga_defconfig b/arch/arm/configs/socfpga_defconfig
index a2956c3..f1d6a3b 100644
--- a/arch/arm/configs/socfpga_defconfig
+++ b/arch/arm/configs/socfpga_defconfig
@@ -86,6 +86,10 @@ CONFIG_USB_DWC2=y
 CONFIG_USB_DWC2_HOST=y
 CONFIG_MMC=y
 CONFIG_MMC_DW=y
+CONFIG_STAGING=y
+CONFIG_FPGA=y
+CONFIG_FPGA_MGR_SYSFS=y
+CONFIG_FPGA_MGR_SOCFPGA=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT2_FS_XATTR=y
 CONFIG_EXT2_FS_POSIX_ACL=y
-- 
1.7.9.5

