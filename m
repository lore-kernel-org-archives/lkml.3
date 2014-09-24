Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaIXOw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:52:26 -0400
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:41500 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbaIXOtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:49:24 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        ctl@merrii.com, Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH v2 6/7] devicetree: bindings: Document supported Allwinner sunxi SoCs
Date: Wed, 24 Sep 2014 22:49:00 +0800
Message-Id: <1411570141-29960-7-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411570141-29960-1-git-send-email-wens@csie.org>
References: <1411570141-29960-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a list of supported Allwinner SoC bindings.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 Documentation/devicetree/bindings/arm/sunxi.txt | 12 ++++++++++++
 1 file changed, 12 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/sunxi.txt

diff --git a/Documentation/devicetree/bindings/arm/sunxi.txt b/Documentation/devicetree/bindings/arm/sunxi.txt
new file mode 100644
index 0000000..d7d1039
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/sunxi.txt
@@ -0,0 +1,12 @@
+Allwinner sunXi Platforms Device Tree Bindings
+
+Each device tree must specify which Allwinner SoC it uses,
+using one of the following compatible stirngs:
+
+  allwinner,sun4i-a10
+  allwinner,sun5i-a10s
+  allwinner,sun5i-a13
+  allwinner,sun6i-a31
+  allwinner,sun7i-a20
+  allwinner,sun8i-a23
+  allwinner,sun9i-a80
-- 
2.1.0

