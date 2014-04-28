Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbaD1O7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:59:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49112 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752665AbaD1O7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:59:31 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 1/7] reset: sunxi: document sunxi's reset controllers bindings
Date: Mon, 28 Apr 2014 16:58:44 +0200
Message-Id: <1398697130-8338-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1398697130-8338-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1398697130-8338-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add DT bindings documentation for sunxi's reset controllers.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 .../bindings/reset/allwinner,sunxi-clock-reset.txt  | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reset/allwinner,sunxi-clock-reset.txt

diff --git a/Documentation/devicetree/bindings/reset/allwinner,sunxi-clock-reset.txt b/Documentation/devicetree/bindings/reset/allwinner,sunxi-clock-reset.txt
new file mode 100644
index 0000000..a582804
--- /dev/null
+++ b/Documentation/devicetree/bindings/reset/allwinner,sunxi-clock-reset.txt
@@ -0,0 +1,21 @@
+Allwinner sunxi Peripheral Reset Controller
+===========================================
+
+Please also refer to reset.txt in this directory for common reset
+controller binding usage.
+
+Required properties:
+- compatible: Should be one of the following depending on your SoC:
+  "allwinner,sun6i-a31-ahb1-reset"
+  "allwinner,sun6i-a31-clock-reset"
+- reg: should be register base and length as documented in the
+  datasheet
+- #reset-cells: 1, see below
+
+example:
+
+ahb1_rst: reset@01c202c0 {
+	#reset-cells = <1>;
+	compatible = "allwinner,sun6i-a31-ahb1-reset";
+	reg = <0x01c202c0 0xc>;
+};
-- 
1.8.3.2

