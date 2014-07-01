Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbaGANEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 09:04:50 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:36614 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbaGANEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 09:04:48 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] dt-bindings: add Marvell Dove LCD controller documentation
Date: Tue,  1 Jul 2014 15:04:28 +0200
Message-Id: <1404219871-18419-2-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1404219871-18419-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1404219871-18419-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

Add the Marvell Dove LCD controller DT binding documentation.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: devicetree@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 .../bindings/drm/armada/marvell,dove-lcd.txt       |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/drm/armada/marvell,dove-lcd.txt

diff --git a/Documentation/devicetree/bindings/drm/armada/marvell,dove-lcd.txt b/Documentation/devicetree/bindings/drm/armada/marvell,dove-lcd.txt
new file mode 100644
index 0000000..97c600d
--- /dev/null
+++ b/Documentation/devicetree/bindings/drm/armada/marvell,dove-lcd.txt
@@ -0,0 +1,14 @@
+Device Tree bindings for Armada DRM CRTC driver
+
+Required properties:
+ - compatible: value should be "marvell,dove-lcd".
+ - reg: base address and size of the LCD controller
+ - interrupts: single interrupt number for the LCD controller
+
+Example:
+
+	lcd0: lcd-controller@820000 {
+		compatible = "marvell,dove-lcd";
+		reg = <0x820000 0x1000>;
+		interrupts = <47>;
+	};
-- 
1.7.2.5

