Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbaAIMvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:51:42 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34212 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbaAIMvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:51:31 -0500
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: <linux-kernel@vger.kernel.org>, Linus Walleij <linus.walleij@linaro.org>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 1/3] pinctrl: single: fix DT bindings documentation
Date: Thu, 9 Jan 2014 14:50:27 +0200
Message-ID: <1389271829-6272-1-git-send-email-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove extra comma in pinctrl-single documentation.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
index 7069a0b84e3a..bc0dfdfdb148 100644
--- a/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
+++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt
@@ -98,7 +98,7 @@ below for more information.
 In case when one register changes more than one pin's mux the
 pinctrl-single,bits need to be used which takes three parameters:
 
-	pinctrl-single,bits = <0xdc 0x18, 0xff>;
+	pinctrl-single,bits = <0xdc 0x18 0xff>;
 
 Where 0xdc is the offset from the pinctrl register base address for the
 device pinctrl register, 0x18 is the desired value, and 0xff is the sub mask to
-- 
1.8.3.2

