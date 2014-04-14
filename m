Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaDNSQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 14:16:00 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:32873 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaDNSP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 14:15:57 -0400
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Shawn Guo <shawn.guo@freescale.com>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH] ARM: dts: imx6q-gk802: Enable HDMI
Date: Mon, 14 Apr 2014 20:15:53 +0200
Message-Id: <1397499353-6116-1-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables HDMI output on GK802 HDMI dongles.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 arch/arm/boot/dts/imx6q-gk802.dts | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/imx6q-gk802.dts b/arch/arm/boot/dts/imx6q-gk802.dts
index 4a9b4dc..16d3491 100644
--- a/arch/arm/boot/dts/imx6q-gk802.dts
+++ b/arch/arm/boot/dts/imx6q-gk802.dts
@@ -48,6 +48,11 @@
 	};
 };
 
+&hdmi {
+	status = "okay";
+	ddc-i2c-bus = <&i2c3>;
+};
+
 /* Internal I2C */
 &i2c2 {
 	pinctrl-names = "default";
-- 
1.9.1

