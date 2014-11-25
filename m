Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbaKYMky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:40:54 -0500
Received: from sci-ig2.spreadtrum.com ([222.66.158.135]:23004 "EHLO
	SHSQR01.spreadtrum.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754504AbaKYMkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:40:49 -0500
From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
To: <grant.likely@linaro.org>, <robh+dt@kernel.org>, <catalin.marinas@arm.com>,
        <gregkh@linuxfoundation.org>, <ijc+devicetree@hellion.org.uk>,
        <jslaby@suse.cz>, <galak@codeaurora.org>, <broonie@linaro.org>,
        <mark.rutland@arm.com>, <m-karicheri2@ti.com>, <pawel.moll@arm.com>,
        <artagnon@gmail.com>, <rrichter@cavium.com>, <will.deacon@arm.com>,
        <arnd@arndb.de>, <gnomes@lxorguk.ukuu.org.uk>, <corbet@lwn.net>,
        <jason@lakedaemon.net>, <broonie@kernel.org>, <heiko@sntech.de>,
        <shawn.guo@freescale.com>, <florian.vaussard@epfl.ch>,
        <andrew@lunn.ch>, <hytszk@gmail.com>, <orsonzhai@gmail.com>,
        <geng.ren@spreadtrum.com>, <zhizhou.zhang@spreadtrum.com>,
        <lanqing.liu@spreadtrum.com>, <zhang.lyra@gmail.com>,
        <wei.qiao@spreadtrum.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <sprdlinux@freelists.org>,
        <linux-doc@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <linux-api@vger.kernel.org>
Subject: [PATCH v3 2/5] Documentation: DT: Add bindings for Spreadtrum SoC Platform
Date: Tue, 25 Nov 2014 20:16:55 +0800
Message-ID: <1416917818-10506-3-git-send-email-chunyan.zhang@spreadtrum.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
References: <Sharkl64-v3>
 <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.0.67.103]
X-ClientProxiedBy: SHCAS01.spreadtrum.com (10.0.1.201) To
 SHMBX01.spreadtrum.com (10.0.1.203)
X-MAIL: SHSQR01.spreadtrum.com sAPCI8Sl065077
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
 .../devicetree/bindings/serial/sprd-uart.txt       |    6 ++++++
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 3 files changed, 18 insertions(+)
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
index 0000000..54e532f
--- /dev/null
+++ b/Documentation/devicetree/bindings/serial/sprd-uart.txt
@@ -0,0 +1,6 @@
+* Spreadtrum serial UART
+
+Required properties:
+- compatible: must be "sprd,sc9836-uart"
+- reg: offset and length of the register set for the device
+- interrupts: exactly one interrupt specifier
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index 723999d..ce99ecdfb 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -142,6 +142,7 @@ snps 	Synopsys, Inc.
 solidrun	SolidRun
 sony	Sony Corporation
 spansion	Spansion Inc.
+sprd	Spreadtrum Communications Inc.
 st	STMicroelectronics
 ste	ST-Ericsson
 stericsson	ST-Ericsson
-- 
1.7.9.5

