Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbaKYM2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:28:54 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57604 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbaKYM2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:28:38 -0500
From: Romain Perier <romain.perier@gmail.com>
To: heiko@sntech.de
Cc: johan@kernel.org, lee.jones@linaro.org, broonie@kernel.org,
        grant.likely@linaro.org, robh@kernel.org, devicetree@vger.kernel.org,
        lgirdwood@gmail.com, mark.rutland@arm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        balbi@ti.com
Subject: [PATCH v5 2/2] dt-bindings: Update documentation for "system-power-controller" and fix misspellings
Date: Tue, 25 Nov 2014 12:28:26 +0000
Message-Id: <1416918506-9366-3-git-send-email-romain.perier@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416918506-9366-1-git-send-email-romain.perier@gmail.com>
References: <1416918506-9366-1-git-send-email-romain.perier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 .../devicetree/bindings/power/power-controller.txt   | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/power/power-controller.txt b/Documentation/devicetree/bindings/power/power-controller.txt
index 845868b..4f7a3bc 100644
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
+"of_device_is_system_power_controller" from of.h .
 
 Example:
 
 act8846: act8846@5 {
 	 compatible = "active-semi,act8846";
 	 status = "okay";
-	 poweroff-source;
+	 system-power-controller;
 }
-- 
1.9.1

