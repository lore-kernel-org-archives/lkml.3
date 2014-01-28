Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaA1Ajq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:39:46 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:61602 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaA1Ajn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:39:43 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 01/21] devicetree: bindings: add missing Marvell Dove SoC documentation
Date: Tue, 28 Jan 2014 01:39:13 +0100
Message-Id: <1390869573-27624-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marvell Dove SoC binding was not documented, yet. Add the documentation
and also describe Global Configuration register node in it.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 .../devicetree/bindings/arm/marvell,dove.txt       | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/marvell,dove.txt

diff --git a/Documentation/devicetree/bindings/arm/marvell,dove.txt b/Documentation/devicetree/bindings/arm/marvell,dove.txt
new file mode 100644
index 000000000000..aaaf64c56e44
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/marvell,dove.txt
@@ -0,0 +1,22 @@
+Marvell Dove Platforms Device Tree Bindings
+-----------------------------------------------
+
+Boards with a Marvell Dove SoC shall have the following properties:
+
+Required root node property:
+- compatible: must contain "marvell,dove";
+
+* Global Configuration registers
+
+Global Configuration registers of Dove SoC are shared by a syscon node.
+
+Required properties:
+- compatible: must contain "marvell,dove-global-config" and "syscon".
+- reg: base address and size of the Global Configuration registers.
+
+Example:
+
+gconf: global-config@e802c {
+	compatible = "marvell,dove-global-config", "syscon";
+	reg = <0xe802c 0x14>;
+};
-- 
1.8.5.2

