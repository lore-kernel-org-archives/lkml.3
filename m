Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbaDPVXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:23:55 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:57079 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459AbaDPVXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:23:53 -0400
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Shawn Guo <shawn.guo@freescale.com>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH v2] ARM: dts: imx6q-gk802: Enable HDMI
Date: Wed, 16 Apr 2014 23:23:50 +0200
Message-Id: <1397683430-3931-1-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
Changes since v1:
 - Reordered ddc-i2c-bus and status properties
---
 arch/arm/boot/dts/imx6q-gk802.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q-gk802.dts b/arch/arm/boot/dts/imx6q-gk802.dts
index 4a9b4dc..0f0c50b 100644
--- a/arch/arm/boot/dts/imx6q-gk802.dts
+++ b/arch/arm/boot/dts/imx6q-gk802.dts
@@ -48,6 +48,11 @@
 	};
 };
 
+&hdmi {
+	ddc-i2c-bus = <&i2c3>;
+	status = "okay";
+};
+
 /* Internal I2C */
 &i2c2 {
 	pinctrl-names = "default";
-- 
1.9.1

