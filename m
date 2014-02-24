Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaBXIn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:43:29 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:60592 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaBXInM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:43:12 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/10] devicetree: bindings: add missing Marvell Dove SoC documentation
Date: Mon, 24 Feb 2014 09:42:53 +0100
Message-Id: <1393231382-11078-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1393231382-11078-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marvell Dove SoC binding was not documented, yet. Add the documentation
and also describe Global Configuration register node in it.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Rob Landley <rob@landley.net>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
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
1.8.5.3

