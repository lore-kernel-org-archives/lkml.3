Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575Ab3K1L33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 06:29:29 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36230 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758539Ab3K1L31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 06:29:27 -0500
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Tony Lindgren <tony@atomide.com>, <linux-kernel@vger.kernel.org>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 1/3] pinctrl: single: fix DT bindings documentation
Date: Thu, 28 Nov 2013 13:29:18 +0200
Message-ID: <1385638160-30125-1-git-send-email-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove extra comma in pinctrl-single documentation.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
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

