Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbbAHTmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 14:42:15 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42684 "EHLO
	mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757476AbbAHTkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 14:40:41 -0500
From: Baruch Siach <baruch@tkos.co.il>
To: linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
Cc: Baruch Siach <baruch@tkos.co.il>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH v2 4/8] irqchip: devicetree: document Conexant Digicolor irq binding
Date: Thu,  8 Jan 2015 21:40:00 +0200
Message-Id: <3bdf8fa0bf971b4881024e72312c3c9d29298e79.1420744369.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1420744368.git.baruch@tkos.co.il>
References: <cover.1420744368.git.baruch@tkos.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 .../bindings/interrupt-controller/digicolor-ic.txt   | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/digicolor-ic.txt

diff --git a/Documentation/devicetree/bindings/interrupt-controller/digicolor-ic.txt b/Documentation/devicetree/bindings/interrupt-controller/digicolor-ic.txt
new file mode 100644
index 000000000000..fdf9a4c59bf3
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupt-controller/digicolor-ic.txt
@@ -0,0 +1,20 @@
+Conexant Digicolor Interrupt Controller
+
+Required properties:
+
+- compatible : should be "cnxt,cx92755-ic"
+- reg : Specifies base physical address and size of the MISC area, that is
+  where the interrupt controller registers are located
+- interrupt-controller : Identifies the node as an interrupt controller
+- #interrupt-cells : Specifies the number of cells needed to encode an
+  interrupt source. The value shall be 1.
+
+Example:
+
+	intc: intc@f0000000 {
+		compatible = "cnxt,cx92755-ic";
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		reg = <0xf0000000 0x1000>;
+	};
+
-- 
2.1.4

