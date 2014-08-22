Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbaHVOCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:02:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33923 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339AbaHVOBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:01:30 -0400
From: Nishanth Menon <nm@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Tero Kristo <t-kristo@ti.com>, Paul Walmsley <paul@pwsan.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        <devicetree@vger.kernel.org>, Dave Gerlach <d-gerlach@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 1/3] pinctrl: bindings: Add OMAP pinctrl binding
Date: Fri, 22 Aug 2014 09:01:00 -0500
Message-ID: <1408716062-26055-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408716062-26055-1-git-send-email-nm@ti.com>
References: <1408716062-26055-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic skeleton of OMAP pinctrl bindings. This is compatible with
pinctrl,single bindings and is meant purely as a reference point.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 .../bindings/pinctrl/ti,omap-pinctrl.txt           |    9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/pinctrl/ti,omap-pinctrl.txt

diff --git a/Documentation/devicetree/bindings/pinctrl/ti,omap-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/ti,omap-pinctrl.txt
new file mode 100644
index 0000000..156d964
--- /dev/null
+++ b/Documentation/devicetree/bindings/pinctrl/ti,omap-pinctrl.txt
@@ -0,0 +1,9 @@
+OMAP Pinctrl definitions
+
+Required properties:
+- compatible : Should be one of:
+  "ti,omap3-padconf" - OMAP3 compatible pinctrl
+  "ti,omap4-padconf" - OMAP4 compatible pinctrl
+  "ti,omap5-padconf" - OMAP5 compatible pinctrl
+
+See Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt for further details.
-- 
1.7.9.5

