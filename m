Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965024AbaGCO3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 10:29:08 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:63793 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965005AbaGCO3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 10:29:03 -0400
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>, arnd@arndb.de,
        mark.rutland@arm.com, haifeng.yan@linaro.org, jchxue@gmail.com,
        zhangfei.gao@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Jiancheng Xue <xuejiancheng@huawei.com>
Subject: [PATCH v3 1/2] Documentation: Document Hisilicon hix5hd2 sata PHY
Date: Thu,  3 Jul 2014 22:28:37 +0800
Message-Id: <1404397718-11495-2-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404397718-11495-1-git-send-email-zhangfei.gao@linaro.org>
References: <1404397718-11495-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiancheng Xue <xuejiancheng@huawei.com>

Add necessary binding documentation SATA PHY on Hisilicon hix5hd2 soc.

Signed-off-by: Jiancheng Xue <xuejiancheng@huawei.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
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

