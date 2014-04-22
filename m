Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbaDVNiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:38:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48795 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751229AbaDVNiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:38:12 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH] ARM: sunxi: dt: list all pinctrl compatible strings
Date: Tue, 22 Apr 2014 15:38:06 +0200
Message-Id: <1398173886-9376-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

List all sunxi pinctrl compatible strings in order to be able to grep for
those values.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 .../devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt      | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
index dff0e5f..d8d0656 100644
--- a/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
+++ b/Documentation/devicetree/bindings/pinctrl/allwinner,sunxi-pinctrl.txt
@@ -6,8 +6,13 @@ the first two functions being GPIO in and out. The configuration on
 the pins includes drive strength and pull-up.
 
 Required properties:
-- compatible: "allwinner,<soc>-pinctrl". Supported SoCs for now are:
-  sun5i-a13.
+- compatible: Should be one of the followings (depending on you SoC):
+  "allwinner,sun4i-a10-pinctrl"
+  "allwinner,sun5i-a10s-pinctrl"
+  "allwinner,sun5i-a13-pinctrl"
+  "allwinner,sun6i-a31-pinctrl"
+  "allwinner,sun6i-a31-r-pinctrl"
+  "allwinner,sun7i-a20-pinctrl"
 - reg: Should contain the register physical address and length for the
   pin controller.
 
-- 
1.8.3.2

