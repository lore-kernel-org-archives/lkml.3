Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbbAHAxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:53:16 -0500
Received: from mailout.micron.com ([137.201.242.129]:37539 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbbAHAxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:53:14 -0500
From: =?gb2312?B?UGV0ZXIgUGFuIMXLtrAgKHBldGVycGFuZG9uZyk=?= 
	<peterpandong@micron.com>
To: "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "Ezequiel Garcia" <ezequiel.garcia@imgtec.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?gb2312?B?UWkgV2FuZyDN9cbwIChxaXdhbmcp?= <qiwang@micron.com>,
        =?gb2312?B?RnJhbmsgTGl1IMH1yLogKGZyYW5rbGl1KQ==?= 
	<frankliu@micron.com>,
        =?gb2312?B?TWVsYW5pZSBaaGFuZyDVxdHgIChtZWxhbmllemhhbmcp?= 
	<melaniezhang@micron.com>,
        =?gb2312?B?UGV0ZXIgUGFuIMXLtrAgKHBldGVycGFuZG9uZyk=?= 
	<peterpandong@micron.com>
Subject: [PATCH 3/3] mtd: spi-nand: add devicetree binding
Thread-Topic: [PATCH 3/3] mtd: spi-nand: add devicetree binding
Thread-Index: AdAq2xIAAWi2EYo2S7+rJwTqE708CAAAgENw
Date: Thu, 8 Jan 2015 00:52:26 +0000
Message-ID: <87F60714EC601C4C83DFF1D2E3D390A04AB425@NTXXIAMBX02.xacn.micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.84.5]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-21230.002
X-TM-AS-Result: No--4.512600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t080rLvg027802

This commit adds the devicetree binding document that specifies the
spi nand devices support.

Signed-off-by: Peter Pan <peterpandong@micron.com>
---
 Documentation/devicetree/bindings/mtd/spi-nand.txt | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/spi-nand.txt

diff --git a/Documentation/devicetree/bindings/mtd/spi-nand.txt b/Documentation/devicetree/bindings/mtd/spi-nand.txt
new file mode 100644
index 0000000..9dd3efd
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/spi-nand.txt
@@ -0,0 +1,22 @@
+* NAND driver for MT29F, GD5F and similar SPI NAND flash chips
+
+Required properties:
+- #address-cells, #size-cells : Must be present if the device has sub-nodes
+  representing partitions.
+- compatible : Should be the manufacturer and the name of the chip. Bear in mind
+               the DT binding is not Linux-only, but in case of Linux, see the
+               "spi_nand_id_table" array in drivers/mtd/spi-nand/spi-nand-device.c
+               for the list of supported chips.
+- reg : Chip-Select number
+- spi-max-frequency : Maximum frequency of the SPI bus the chip can operate at
+
+Example:
+
+	flash: flash@0 {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		compatible = "micron,mt29f";
+		reg = <0>;
+		spi-max-frequency = <50000000>;
+	};
+
-- 
1.9.1
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
