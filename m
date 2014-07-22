Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbaGVOxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:53:43 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:57909 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755704AbaGVOwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:52:53 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, dbaryshkov@gmail.com
Subject: [PATCH 4/5] ARM: sti: Add Restart support for the STiH416 (Orly2) board
Date: Tue, 22 Jul 2014 15:52:31 +0100
Message-Id: <1406040752-25229-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406040752-25229-1-git-send-email-lee.jones@linaro.org>
References: <1406040752-25229-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih416.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
index 84758d7..95b15b0 100644
--- a/arch/arm/boot/dts/stih416.dtsi
+++ b/arch/arm/boot/dts/stih416.dtsi
@@ -28,6 +28,12 @@
 		ranges;
 		compatible	= "simple-bus";
 
+		restart {
+			compatible = "st,stih416-restart";
+			st,syscfg = <&syscfg_sbc>;
+			status = "okay";
+		};
+
 		powerdown: powerdown-controller {
 			#reset-cells = <1>;
 			compatible = "st,stih416-powerdown";
-- 
1.8.3.2

