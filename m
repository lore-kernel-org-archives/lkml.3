Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbaGVK51 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:57:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34874 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbaGVK5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:57:24 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 09/28] Documentation: Document Hisilicon hix5hd2 sata PHY
Date: Tue, 22 Jul 2014 16:26:32 +0530
Message-ID: <1406026611-30493-10-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406026611-30493-1-git-send-email-kishon@ti.com>
References: <1406026611-30493-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiancheng Xue <xuejiancheng@huawei.com>

Add necessary binding documentation SATA PHY on Hisilicon hix5hd2 soc.

Signed-off-by: Jiancheng Xue <xuejiancheng@huawei.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/phy/hix5hd2-phy.txt        |   22 ++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/hix5hd2-phy.txt

diff --git a/Documentation/devicetree/bindings/phy/hix5hd2-phy.txt b/Documentation/devicetree/bindings/phy/hix5hd2-phy.txt
new file mode 100644
index 0000000..296168b
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/hix5hd2-phy.txt
@@ -0,0 +1,22 @@
+Hisilicon hix5hd2 SATA PHY
+-----------------------
+
+Required properties:
+- compatible: should be "hisilicon,hix5hd2-sata-phy"
+- reg: offset and length of the PHY registers
+- #phy-cells: must be 0
+Refer to phy/phy-bindings.txt for the generic PHY binding properties
+
+Optional Properties:
+- hisilicon,peripheral-syscon: phandle of syscon used to control peripheral.
+- hisilicon,power-reg: offset and bit number within peripheral-syscon,
+	register of controlling sata power supply.
+
+Example:
+	sata_phy: phy@f9900000 {
+		compatible = "hisilicon,hix5hd2-sata-phy";
+		reg = <0xf9900000 0x10000>;
+		#phy-cells = <0>;
+		hisilicon,peripheral-syscon = <&peripheral_ctrl>;
+		hisilicon,power-reg = <0x8 10>;
+	};
-- 
1.7.9.5

