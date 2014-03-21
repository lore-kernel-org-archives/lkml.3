Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbaCUKsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 06:48:16 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:45069 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760282AbaCUKsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 06:48:14 -0400
Date: Fri, 21 Mar 2014 11:48:31 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] drm/i2c: tda998x: Fix lack of required reg in DT
 documentation
Message-ID: <20140321114831.2ecb3059@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C address (reg) is required for the TDA998x driver to be loaded
and initialized.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
- v3
	- change subject to drm/i2c
- v2
	- don't force the I2C address to be 0x70
This patch applies to linux-next.
---
 Documentation/devicetree/bindings/drm/i2c/tda998x.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
index d7df01c..fc7effa 100644
--- a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
+++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
@@ -3,6 +3,8 @@ Device-Tree bindings for the NXP TDA998x HDMI transmitter
 Required properties;
   - compatible: must be "nxp,tda998x"
 
+  - reg: I2C address
+
 Optional properties:
   - interrupts: interrupt number and trigger type
 	default: polling
-- 
1.9.1


-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
_______________________________________________
dri-devel mailing list
dri-devel@lists.freedesktop.org
http://lists.freedesktop.org/mailman/listinfo/dri-devel
