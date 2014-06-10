Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaFJMFD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 08:05:03 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:1972
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750861AbaFJMFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 08:05:00 -0400
From: <subbaraya.sundeep.bhatta@xilinx.com>
To: <balbi@ti.com>, <devicetree@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <michals@xilinx.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sbhatta@xilinx.com>
Subject: [PATCH v3 1/2] usb: doc: udc-xilinx: Add devicetree bindings
Date: Tue, 10 Jun 2014 17:34:37 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
Message-ID: <b0dfcba4-7319-4687-a455-bfcddf61b7d1@BN1AFFO11FD028.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438001)(189002)(199002)(88136002)(87286001)(50466002)(87936001)(33646001)(102836001)(77156001)(79102001)(92566001)(76482001)(77982001)(92726001)(86152002)(104166001)(93916002)(21056001)(50986999)(31696002)(1496006)(86362001)(74316001)(99396002)(48376002)(6806004)(70736001)(53416003)(50226001)(46102001)(19580395003)(83322001)(44976005)(4396001)(47776003)(85852003)(104016001)(19580405001)(64706001)(89996001)(62966002)(83072002)(74502001)(81342001)(20776003)(74662001)(31966008)(80022001)(81542001)(23106003);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB025;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0238AEEDB0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=subbaraya.sundeep.bhatta@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>

Add devicetree bindings for Xilinx axi udc driver.

Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
---
Changes for v3:
	- None
Changes for v2:
	- replaced xlnx,include-dma with xlnx,has-builtin-dma

 .../devicetree/bindings/usb/udc-xilinx.txt         |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/udc-xilinx.txt

diff --git a/Documentation/devicetree/bindings/usb/udc-xilinx.txt b/Documentation/devicetree/bindings/usb/udc-xilinx.txt
new file mode 100644
index 0000000..7c24fac
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/udc-xilinx.txt
@@ -0,0 +1,20 @@
+Xilinx AXI USB2 device controller
+
+Required properties:
+- compatible		: Should be "xlnx,axi-usb2-device-4.00.a"
+- reg			: Physical base address and size of the Axi USB2
+			  device registers map.
+- interrupts		: Property with a value describing the interrupt
+			  number.
+- interrupt-parent	: Must be core interrupt controller
+- xlnx,include-dma	: if DMA is included
+
+Example:
+ 		axi-usb2-device@42e00000 {
+                        compatible = "xlnx,axi-usb2-device-4.00.a";
+                        interrupt-parent = <0x1>;
+                        interrupts = <0x0 0x39 0x1>;
+                        reg = <0x42e00000 0x10000>;
+                        xlnx,has-builtin-dma;
+                };
+
-- 
1.7.4


