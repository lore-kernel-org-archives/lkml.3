Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab3BKCo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 21:44:59 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42972 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab3BKCo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 21:44:58 -0500
From: "Kumar, Anil" <anilkumar.v@ti.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <tony@atomide.com>, <linus.walleij@linaro.org>, <b-cousson@ti.com>,
        <anilkumar.v@ti.com>
Subject: [PATCH] pinctrl: pinctrl-single: fix the binding documentation
Date: Mon, 11 Feb 2013 08:16:03 +0530
Message-ID: <1360550763-5404-1-git-send-email-anilkumar.v@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As there are no use of #address-cells and #size-cells properties
in pinctrl-single driver DT node. Fix pinctrl-single binding documentation
to remove these properties.

Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
---
Tested on da850 EVM.

:100644 100644 2c81e45... c6384e2... M	Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
 .../devicetree/bindings/pinctrl/pinctrl-single.txt |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
index 2c81e45..c6384e2 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
@@ -50,8 +50,6 @@ Example:
 pmx_core: pinmux@4a100040 {
 	compatible = "pinctrl-single";
 	reg = <0x4a100040 0x0196>;
-	#address-cells = <1>;
-	#size-cells = <0>;
 	pinctrl-single,register-width = <16>;
 	pinctrl-single,function-mask = <0xffff>;
 };
@@ -60,8 +58,6 @@ pmx_core: pinmux@4a100040 {
 pmx_wkup: pinmux@4a31e040 {
 	compatible = "pinctrl-single;
 	reg = <0x4a31e040 0x0038>;
-	#address-cells = <1>;
-	#size-cells = <0>;
 	pinctrl-single,register-width = <16>;
 	pinctrl-single,function-mask = <0xffff>;
 };
@@ -69,8 +65,6 @@ pmx_wkup: pinmux@4a31e040 {
 control_devconf0: pinmux@48002274 {
 	compatible = "pinctrl-single";
 	reg = <0x48002274 4>;	/* Single register */
-	#address-cells = <1>;
-	#size-cells = <0>;
 	pinctrl-single,bit-per-mux;
 	pinctrl-single,register-width = <32>;
 	pinctrl-single,function-mask = <0x5F>;
-- 
1.7.4.1

