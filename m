Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbaDPMkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:40:24 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47877 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755686AbaDPMkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:40:16 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, chris@printf.net, anton@enomsg.org
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] Documentation: bindings: add the sdhci-berlin
Date: Wed, 16 Apr 2014 14:40:09 +0200
Message-Id: <1397652011-21284-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1397652011-21284-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1397652011-21284-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the binding documentation for the Marvell Berlin SDHCI driver.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 Documentation/devicetree/bindings/mmc/sdhci-berlin.txt | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-berlin.txt

diff --git a/Documentation/devicetree/bindings/mmc/sdhci-berlin.txt b/Documentation/devicetree/bindings/mmc/sdhci-berlin.txt
new file mode 100644
index 000000000000..1a5591f85a64
--- /dev/null
+++ b/Documentation/devicetree/bindings/mmc/sdhci-berlin.txt
@@ -0,0 +1,18 @@
+* Marvell Berlin SDHCI controller
+
+All common properties are documented in mmc.txt
+
+Required properties:
+- compatible: "marvell,berlin2-sdhci",
+	      "marvell,berlin2cd-sdhci",
+	      "marvell,berlin2q-sdhci"
+- clocks: reference to the SDHCI controller clock
+
+Example:
+
+sdhci0: sdhci@ab0000 {
+	compatible = "marvell,berlin2q-sdhci";
+	reg = <0xab0000 0x200>;
+	clocks = <&sdio1clk>;
+	interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
+};
-- 
1.8.3.2

