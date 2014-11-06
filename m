Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaKFOWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:22:49 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:41317 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaKFOTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:19:49 -0500
From: Romain Perier <romain.perier@gmail.com>
To: heiko@sntech.de
Cc: grant.likely@linaro.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        lgirdwood@gmail.com, broonie@kernel.org, johan@kernel.org,
        mark.rutland@arm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com
Subject: [PATCH v3 2/2] dt-bindings: Update documentation for "system-power-controller" and fix misspellings
Date: Thu,  6 Nov 2014 14:23:03 +0000
Message-Id: <1415283784-10885-3-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415283784-10885-1-git-send-email-romain.perier@gmail.com>
References: <1415283784-10885-1-git-send-email-romain.perier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 .../devicetree/bindings/power/power-controller.txt   | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/power/power-controller.txt b/Documentation/devicetree/bindings/power/power-controller.txt
index 845868b..9afa847 100644
--- a/Documentation/devicetree/bindings/power/power-controller.txt
+++ b/Documentation/devicetree/bindings/power/power-controller.txt
@@ -1,18 +1,18 @@
-* Generic Poweroff capability
+* Generic system power control capability
 
-Power-management integrated circuits or miscellaneous harware components are
-sometimes able to control the system power. The device driver associated to these
-components might needs to define poweroff capability, which tells to the kernel
-how to switch off the system. The corresponding driver must have the standard
-property "poweroff-source" in its device node. This property marks the device as
-able to shutdown the system. In order to test if this property is found
-programmatically, use the helper function "of_system_has_poweroff_source" from
-of.h .
+Power-management integrated circuits or miscellaneous hardware components are
+sometimes able to control the system power. The device driver associated with these
+components might need to define this capability, which tells the kernel that
+it can be used to switch off the system. The corresponding device must have the
+standard property "system-power-controller" in its device node. This property
+marks the device as able to control the system power. In order to test if this
+property is found programmatically, use the helper function
+"of_is_system_power_controller" from of.h .
 
 Example:
 
 act8846: act8846@5 {
 	 compatible = "active-semi,act8846";
 	 status = "okay";
-	 poweroff-source;
+	 system-power-controller;
 }
-- 
1.9.1

