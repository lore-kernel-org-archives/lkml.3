Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933890Ab3DJGzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 02:55:19 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:49258 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3DJGzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 02:55:17 -0400
From: Prabhakar lad <prabhakar.csengg@gmail.com>
To: devicetree-discuss@lists.ozlabs.org
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] pinctrl: pinctrl-single: add missing double quote
Date: Wed, 10 Apr 2013 12:25:01 +0530
Message-Id: <1365576901-9518-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

add a missing double quote for compatible property for pmx_wkup.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 .../devicetree/bindings/pinctrl/pinctrl-single.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
index 2c81e45..e0ec0fc 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
@@ -58,7 +58,7 @@ pmx_core: pinmux@4a100040 {
 
 /* second controller instance for pins in wkup domain */
 pmx_wkup: pinmux@4a31e040 {
-	compatible = "pinctrl-single;
+	compatible = "pinctrl-single";
 	reg = <0x4a31e040 0x0038>;
 	#address-cells = <1>;
 	#size-cells = <0>;
-- 
1.7.4.1

