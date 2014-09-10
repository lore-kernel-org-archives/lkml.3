Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaIJNyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:54:19 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:13488
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751038AbaIJNyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:54:16 -0400
From: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>
To: <balbi@ti.com>, <devicetree@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <michals@xilinx.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <svemula@xilinx.com>, <anirudh@xilinx.com>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Subject: [PATCH v5 1/2] usb: doc: udc-xilinx: Add devicetree bindings
Date: Wed, 10 Sep 2014 19:24:03 +0530
X-Mailer: git-send-email 1.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20940.006
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <33b86c3c-4de1-47c9-9bd8-71d5a7325447@BY2FFO11FD055.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199003)(189002)(50986999)(89996001)(83072002)(92726001)(92566001)(85852003)(102836001)(81342001)(81542001)(74316001)(99396002)(21056001)(76482001)(1496007)(79102001)(93916002)(31696002)(86362001)(77096002)(53416004)(90102001)(64706001)(20776003)(47776003)(87936001)(74662001)(87286001)(88136002)(74502001)(95666004)(31966008)(107046002)(46102001)(104016003)(85306004)(229853001)(44976005)(50466002)(77156001)(19580405001)(83322001)(48376002)(77982001)(6806004)(80022001)(70736001)(104166001)(19580395003)(62966002)(4396001)(50226001)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB068;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=subbaraya.sundeep.bhatta@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add devicetree bindings for Xilinx udc driver.

Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
---
Changes for v5:
	- None
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

