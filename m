Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901AbbAVNpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 08:45:31 -0500
Received: from sci-ig2.spreadtrum.com ([222.66.158.135]:22383 "EHLO
	SHSQR01.spreadtrum.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750832AbbAVNp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:45:27 -0500
From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
To: <gregkh@linuxfoundation.org>, <robh+dt@kernel.org>
CC: <mark.rutland@arm.com>, <arnd@arndb.de>, <gnomes@lxorguk.ukuu.org.uk>,
        <peter@hurleysoftware.com>, <shawn.guo@linaro.org>,
        <pawel.moll@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <jslaby@suse.cz>, <grant.likely@linaro.org>,
        <heiko@sntech.de>, <jason@lakedaemon.net>, <florian.vaussard@epfl.ch>,
        <andrew@lunn.ch>, <hytszk@gmail.com>, <antonynpavlov@gmail.com>,
        <orsonzhai@gmail.com>, <geng.ren@spreadtrum.com>,
        <zhizhou.zhang@spreadtrum.com>, <lanqing.liu@spreadtrum.com>,
        <zhang.lyra@gmail.com>, <wei.qiao@spreadtrum.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <linux-api@vger.kernel.org>
Subject: [PATCH v6 1/2] Documentation: DT: Add bindings for Spreadtrum SoC Platform
Date: Thu, 22 Jan 2015 21:35:05 +0800
Message-ID: <1421933706-4277-2-git-send-email-chunyan.zhang@spreadtrum.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421933706-4277-1-git-send-email-chunyan.zhang@spreadtrum.com>
References: <sprd-serial-v6>
 <1421933706-4277-1-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.0.67.142]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 SHMBX01.spreadtrum.com (10.0.1.203)
X-MAIL: SHSQR01.spreadtrum.com t0MDZZZG071286
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds Spreadtrum's prefix "sprd" to vendor-prefixes file.
Adds the devicetree binding documentations for Spreadtrum's sc9836-uart
and SC9836 SoC based on the Sharkl64 Platform which is a 64-bit SoC
Platform of Spreadtrum.

Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
---
 Documentation/devicetree/bindings/arm/sprd.txt     |   11 +++++++++++
 .../devicetree/bindings/serial/sprd-uart.txt       |    7 +++++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 3 files changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/sprd.txt
 create mode 100644 Documentation/devicetree/bindings/serial/sprd-uart.txt

diff --git a/Documentation/devicetree/bindings/arm/sprd.txt b/Documentation/devicetree/bindings/arm/sprd.txt
new file mode 100644
index 0000000..31a629d
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/sprd.txt
@@ -0,0 +1,11 @@
+Spreadtrum SoC Platforms Device Tree Bindings
+----------------------------------------------------
+
+Sharkl64 is a Spreadtrum's SoC Platform which is based
+on ARM 64-bit processor.
+
+SC9836 openphone board with SC9836 SoC based on the
+Sharkl64 Platform shall have the following properties.
+
+Required root node properties:
+        - compatible = "sprd,sc9836-openphone", "sprd,sc9836";
diff --git a/Documentation/devicetree/bindings/serial/sprd-uart.txt b/Documentation/devicetree/bindings/serial/sprd-uart.txt
new file mode 100644
index 0000000..2aff0f2
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/sprd-uart.txt
@@ -0,0 +1,7 @@
+* Spreadtrum serial UART
+
+Required properties:
+- compatible: must be "sprd,sc9836-uart"
+- reg: offset and length of the register set for the device
+- interrupts: exactly one interrupt specifier
+- clocks: phandles to input clocks.
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index b1df0ad..0a8384f 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -153,6 +153,7 @@ snps	Synopsys, Inc.
 solidrun	SolidRun
 sony	Sony Corporation
 spansion	Spansion Inc.
+sprd	Spreadtrum Communications Inc.
 st	STMicroelectronics
 ste	ST-Ericsson
 stericsson	ST-Ericsson
-- 
1.7.9.5

