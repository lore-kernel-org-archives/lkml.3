Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaGVJJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:09:23 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:30821
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752664AbaGVJJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:09:20 -0400
From: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>
To: <balbi@ti.com>, <devicetree@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <michals@xilinx.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <svemula@xilinx.com>, <anirudh@xilinx.com>, <sbhatta@xilinx.com>
Subject: [PATCH v4 1/2] usb: doc: udc-xilinx: Add devicetree bindings
Date: Tue, 22 Jul 2014 14:38:49 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
Message-ID: <4affe9b7-db88-445d-bcc4-7bc69e7259a5@BY2FFO11FD025.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199002)(189002)(87936001)(48376002)(19580395003)(4396001)(88136002)(46102001)(77982001)(50986999)(77096002)(99396002)(74316001)(104016003)(74502001)(83322001)(44976005)(6806004)(106466001)(83072002)(19580405001)(85852003)(87286001)(81542001)(62966002)(81342001)(102836001)(1496007)(92726001)(50226001)(31696002)(104166001)(50466002)(92566001)(86362001)(93916002)(47776003)(85306003)(64706001)(89996001)(76482001)(70736001)(79102001)(80022001)(77156001)(31966008)(53416004)(21056001)(95666004)(107046002)(74662001)(229853001)(20776003)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB061;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02801ACE41
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=subbaraya.sundeep.bhatta@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree bindings for Xilinx udc driver.

Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
---
Changes for v4:
	- renamed xlnx,axi-usb2-device-4.00.a to xlnx,usb2-device-4.00.a
Changes for v3:
        - None
Changes for v2:
        - replaced xlnx,include-dma with xlnx,has-builtin-dma

 .../devicetree/bindings/usb/udc-xilinx.txt         |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/usb/udc-xilinx.txt

diff --git a/Documentation/devicetree/bindings/usb/udc-xilinx.txt b/Documentation/devicetree/bindings/usb/udc-xilinx.txt
new file mode 100644
index 0000000..47b4e39
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/udc-xilinx.txt
@@ -0,0 +1,18 @@
+Xilinx USB2 device controller
+
+Required properties:
+- compatible		: Should be "xlnx,usb2-device-4.00.a"
+- reg			: Physical base address and size of the USB2
+			  device registers map.
+- interrupts		: Should contain single irq line of USB2 device
+			  controller
+- xlnx,has-builtin-dma	: if DMA is included
+
+Example:
+ 		axi-usb2-device@42e00000 {
+                        compatible = "xlnx,usb2-device-4.00.a";
+                        interrupts = <0x0 0x39 0x1>;
+                        reg = <0x42e00000 0x10000>;
+                        xlnx,has-builtin-dma;
+                };
+
-- 
1.7.4


