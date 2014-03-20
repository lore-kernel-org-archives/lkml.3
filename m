Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbaCTJ0x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:26:53 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:58548 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbaCTJ0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:26:51 -0400
X-Mailbox-Line: From 132ea5a4272d4927e8e389427d9c96e6a6d7166d Mon Sep 17 00:00:00 2001
From: Jean-Francois Moine <moinejf@free.fr>
Date: Thu, 20 Mar 2014 09:58:10 +0100
Subject: [PATCH] ASoC: tda998x: Fix lack of required reg in DT documentation
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-Id: <20140320092639.48F68A6279@smtp3-g21.free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C address (reg) is required for the TDA998x driver to be loaded
and initialized.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
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
 
+  - reg: I2C address - must be <0x70>
+
 Optional properties:
   - interrupts: interrupt number and trigger type
 	default: polling
-- 
1.9.1

