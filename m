Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaHTUpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:45:09 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:57021 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbaHTUme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:42:34 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>
Cc: =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pm@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: [PATCH 2/9] Documentation: devicetree: Add binding for Synopsys DDR controller
Date: Wed, 20 Aug 2014 13:41:48 -0700
Message-Id: <1408567315-28479-3-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.0.1.1.gfbfc394
In-Reply-To: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1408567315-28479-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 .../devicetree/bindings/memory-controllers/synopsys.txt       | 11 +++++++++++
 1 file changed, 11 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/memory-controllers/synopsys.txt

diff --git a/Documentation/devicetree/bindings/memory-controllers/synopsys.txt b/Documentation/devicetree/bindings/memory-controllers/synopsys.txt
new file mode 100644
index 000000000000..f9c6454146b6
--- /dev/null
+++ b/Documentation/devicetree/bindings/memory-controllers/synopsys.txt
@@ -0,0 +1,11 @@
+Binding for Synopsys IntelliDDR Multi Protocol Memory Controller
+
+Required properties:
+ - compatible: Should be 'xlnx,zynq-ddrc-a05'
+ - reg: Base address and size of the controllers memory area
+
+Example:
+	memory-controller@f8006000 {
+		compatible = "xlnx,zynq-ddrc-a05";
+		reg = <0xf8006000 0x1000>;
+	};
-- 
2.0.1.1.gfbfc394

