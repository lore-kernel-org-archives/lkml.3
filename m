Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaK0PR4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 10:17:56 -0500
Received: from mail-bn1bon0083.outbound.protection.outlook.com ([157.56.111.83]:44090
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751514AbaK0PRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 10:17:53 -0500
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: <dougthompson@xmission.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        <michal.simek@xilinx.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>, <bp@alien8.de>
CC: <kpc528@gmail.com>, <kalluripunnaiahchoudary@gmail.com>,
        <punnaia@xilinx.com>
Subject: [PATCH v5 1/2] Documentation: devicetree: Add ECC information to synopsys ddr controller
Date: Thu, 27 Nov 2014 20:47:33 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21132.007
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <1d7215b92ad4406b8bf5c593a9a13167@BN1BFFO11FD020.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(189002)(50986999)(86362001)(31966008)(92566001)(19580405001)(89996001)(77156002)(2201001)(99396003)(20776003)(108616004)(93916002)(120916001)(47776003)(48376002)(87286001)(106466001)(74316001)(50466002)(229853001)(44976005)(77096003)(6806004)(88136002)(21056001)(104016003)(50226001)(53416004)(19580395003)(4396001)(62966003)(87936001)(95666004)(46102003)(107046002)(64706001)(102836001)(33646002)(104166001)(1121002)(107986001)(921003)(24736002)(83996005)(2101003)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB060;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB060;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB060;
X-Forefront-PRVS: 040866B734
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=punnaiah.choudary.kalluri@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB060;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ECC information to synopsys ddr memory controller.

Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
---
 .../bindings/memory-controllers/synopsys.txt       |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/memory-controllers/synopsys.txt b/Documentation/devicetree/bindings/memory-controllers/synopsys.txt
index f9c6454..a43d26d 100644
--- a/Documentation/devicetree/bindings/memory-controllers/synopsys.txt
+++ b/Documentation/devicetree/bindings/memory-controllers/synopsys.txt
@@ -1,5 +1,9 @@
 Binding for Synopsys IntelliDDR Multi Protocol Memory Controller
 
+This controller has an optional ECC support in half-bus width (16-bit)
+configuration. The ECC controller corrects one bit error and detects
+two bit errors.
+
 Required properties:
  - compatible: Should be 'xlnx,zynq-ddrc-a05'
  - reg: Base address and size of the controllers memory area
-- 
1.7.4

