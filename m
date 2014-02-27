Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaB0V4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:56:24 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:9129 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaB0V4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:56:22 -0500
X-IronPort-AV: E=Sophos;i="4.97,557,1389772800"; 
   d="scan'208";a="16754887"
From: Markus Mayer <markus.mayer@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>, Matt Porter <matt.porter@linaro.org>
CC: Device Tree List <devicetree@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Broadcom Kernel Feedback 
	<bcm-kernel-feedback-list@broadcom.com>
Subject: [PATCH 1/3] ARM: DT: bcm21664: Device tree bindings
Date: Thu, 27 Feb 2014 13:56:04 -0800
Message-ID: <1393538166-22868-2-git-send-email-markus.mayer@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393538166-22868-1-git-send-email-markus.mayer@linaro.org>
References: <1393538166-22868-1-git-send-email-markus.mayer@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding documents for the Broadcom BCM21664 SoC.

Signed-off-by: Markus Mayer <markus.mayer@linaro.org>
---
 .../devicetree/bindings/arm/bcm/bcm21664.txt       |   15 +++++++++++++++
 .../devicetree/bindings/arm/bcm/kona-resetmgr.txt  |   14 ++++++++++++++
 2 files changed, 29 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/bcm/bcm21664.txt
 create mode 100644 Documentation/devicetree/bindings/arm/bcm/kona-resetmgr.txt

diff --git a/Documentation/devicetree/bindings/arm/bcm/bcm21664.txt b/Documentation/devicetree/bindings/arm/bcm/bcm21664.txt
new file mode 100644
index 0000000..e077425
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/bcm/bcm21664.txt
@@ -0,0 +1,15 @@
+Broadcom BCM21664 device tree bindings
+--------------------------------------
+
+This document describes the device tree bindings for boards with the BCM21664
+SoC.
+
+Required root node property:
+  - compatible: brcm,bcm21664
+
+Example:
+	/ {
+		model = "BCM21664 SoC";
+		compatible = "brcm,bcm21664";
+		[...]
+	}
diff --git a/Documentation/devicetree/bindings/arm/bcm/kona-resetmgr.txt b/Documentation/devicetree/bindings/arm/bcm/kona-resetmgr.txt
new file mode 100644
index 0000000..93f31ca
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/bcm/kona-resetmgr.txt
@@ -0,0 +1,14 @@
+Broadcom Kona Family Reset Manager
+----------------------------------
+
+The reset manager is used on the Broadcom BCM21664 SoC.
+
+Required properties:
+  - compatible: brcm,bcm21664-resetmgr
+  - reg: memory address & range
+
+Example:
+	brcm,resetmgr@35001f00 {
+		compatible = "brcm,bcm21664-resetmgr";
+		reg = <0x35001f00 0x24>;
+	};
-- 
1.7.9.5

